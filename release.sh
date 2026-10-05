#!/usr/bin/env bash
# Builds the Release demo against the latest HeroWebView.xcframework.
# --sim builds for the simulator instead, then boots one, installs the app and launches it.
set -euo pipefail

readonly ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT="$ROOT/HeroWebViewDemo.xcodeproj"
readonly SCHEME=HeroWebViewDemo
readonly BUNDLE_ID=io.hero.webviewdemo
readonly SDK_DIR="$ROOT/HeroWebViewSDK"
readonly SDK_VERSION_FILE="$SDK_DIR/.version"
readonly DERIVED_DATA="$ROOT/build"
# The hero-rc-ios-webview-sdk CI job publishes every rc tag's SDK here.
readonly UPDATER_URL="https://rc-updates.hero.io/v2/api/latest?os=webview-sdk-ios"

usage() {
  echo "usage: $0 [--sim]" >&2
  exit 2
}

sim=false
for arg in "$@"; do
  case "$arg" in
    --sim) sim=true ;;
    *) usage ;;
  esac
done

# The updater redirects to HeroBrowserSetup_webview-sdk-ios_<version>.zip.
fetch_sdk() {
  local url version
  url="$(curl -fsS -o /dev/null -w '%{redirect_url}' "$UPDATER_URL")"
  if [[ -z "$url" ]]; then
    echo "The updater gave no SDK for $UPDATER_URL" >&2
    exit 1
  fi
  version="${url##*_}"
  version="${version%.zip}"

  if [[ -f "$SDK_VERSION_FILE" && "$(<"$SDK_VERSION_FILE")" == "$version" ]]; then
    echo "HeroWebView SDK $version is current"
    return
  fi

  echo "Downloading HeroWebView SDK $version from $url"
  local tmp
  tmp="$(mktemp -d)"
  curl -fsSL -o "$tmp/sdk.zip" "$url"
  rm -rf "$SDK_DIR"
  mkdir -p "$SDK_DIR"
  unzip -q "$tmp/sdk.zip" -d "$SDK_DIR"
  rm -rf "$tmp"
  if [[ ! -d "$SDK_DIR/HeroWebView.xcframework" ]]; then
    echo "The SDK zip has no HeroWebView.xcframework" >&2
    exit 1
  fi
  echo "$version" >"$SDK_VERSION_FILE"
}

# A booted iPhone if there is one, else the first iPhone on the newest runtime.
pick_simulator() {
  xcrun simctl list devices available -j | python3 -c '
import json, sys
runtimes = json.load(sys.stdin)["devices"]
phones = [(runtime, d) for runtime, devices in runtimes.items() if ".iOS-" in runtime
          for d in devices if d["name"].startswith("iPhone")]
booted = [d for _, d in phones if d["state"] == "Booted"]
if booted:
    print(booted[0]["udid"])
elif phones:
    version = lambda r: [int(p) for p in r.rsplit(".iOS-", 1)[1].split("-")]
    print(max(phones, key=lambda p: version(p[0]))[1]["udid"])
'
}

build_device() {
  # A team signs the app for a phone; without one the app is built unsigned.
  local signing=(CODE_SIGNING_ALLOWED=NO)
  if [[ -n "${DEVELOPMENT_TEAM:-}" ]]; then
    signing=(-allowProvisioningUpdates "DEVELOPMENT_TEAM=$DEVELOPMENT_TEAM")
  fi
  xcodebuild -project "$PROJECT" -scheme "$SCHEME" -configuration Release \
    -destination generic/platform=iOS -derivedDataPath "$DERIVED_DATA" \
    "${signing[@]}" build
  echo "Built $DERIVED_DATA/Build/Products/Release-iphoneos/$SCHEME.app"
}

run_on_simulator() {
  local udid app
  udid="$(pick_simulator)"
  if [[ -z "$udid" ]]; then
    echo "No iPhone simulator; add one in Xcode" >&2
    exit 1
  fi
  # The SDK's simulator slice is arm64 only, and Release builds every simulator arch.
  xcodebuild -project "$PROJECT" -scheme "$SCHEME" -configuration Release \
    -destination "id=$udid" -derivedDataPath "$DERIVED_DATA" ONLY_ACTIVE_ARCH=YES build
  app="$DERIVED_DATA/Build/Products/Release-iphonesimulator/$SCHEME.app"
  echo "Built $app"

  # bootstatus -b boots the simulator if needed and returns once it has booted.
  xcrun simctl bootstatus "$udid" -b
  local simulator_app="${SIMULATOR_APP:-$(xcode-select -p)/Applications/Simulator.app}"
  if [[ -d "$simulator_app" ]]; then
    open "$simulator_app" --args -CurrentDeviceUDID "$udid"
  else
    echo "No Simulator.app at $simulator_app (set SIMULATOR_APP); the simulator runs headless"
  fi
  xcrun simctl install "$udid" "$app"
  xcrun simctl launch "$udid" "$BUNDLE_ID"
}

cd "$ROOT"
fetch_sdk
if [[ "$sim" == true ]]; then
  run_on_simulator
else
  build_device
fi
