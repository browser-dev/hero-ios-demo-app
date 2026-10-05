# HeroWebView demo app for iOS

An Xcode project that opens `vitalik.eth`, `shakeshift` and other crypto
domains in `HeroWebView`, the Hero engine shipped as `HeroWebView.xcframework`.
It builds against the SDK the way any other app does.

## The SDK

The project reads the xcframework from `HERO_WEB_VIEW_SDK_DIR`, which defaults
to `HeroWebViewSDK/` next to the project. `release.sh` fills that directory
itself: it asks the rc updater for the latest SDK, the zip the
`hero-rc-ios-webview-sdk` CI job publishes with every rc tag, and downloads it
only when its version differs from the one in `HeroWebViewSDK/.version`.

- `https://rc-updates.hero.io/v2/api/latest?os=webview-sdk-ios` redirects to
  the zip; its file name carries the version.
- The zip also carries the SDK's `README.md`, with the integration steps the
  Integrate tab shows.

## Build

Requirements: Xcode with the iOS 18 SDK or later; `--sim` needs an iPhone
simulator on Apple silicon (the SDK's simulator slice is arm64).

```
./release.sh          # build/Build/Products/Release-iphoneos/HeroWebViewDemo.app
./release.sh --sim    # builds for a simulator, boots it, installs and launches the app
```

Both work from a clean checkout (`git clean -xdff`). The device build is
unsigned unless `DEVELOPMENT_TEAM=<team id>` is set. `--sim` uses a booted
iPhone, else the newest runtime's first iPhone; set `SIMULATOR_APP` when the
Simulator window lives outside the selected Xcode.

## Tests

Once `release.sh` has fetched the SDK:

```
xcodebuild test -project HeroWebViewDemo.xcodeproj \
  -scheme HeroWebViewDemo -destination id=<simulator>
```

Pass `HERO_WEB_VIEW_SDK_DIR=<dir>` to build against another SDK, such as a local
`out/<type>_<branding>_ios_web_view_sdk` from the browser tree.

The Browse tab has a button per name service (ENS, Handshake, Solana, BNB, NEAR,
ICP, Tezos, Filecoin, Polkadot, Arbitrum, Hedera, Unstoppable, Algorand) and
"Play all", which opens each in turn: the next one after the page finishes and
7 s on screen, or after 40 s. `AddressToURLTests` and `DemoTourTests` cover the
address field and the tour.

The SDK needs iOS 18, and an app needs an App Transport Security exception for
`ipfs.localhost`, or IPFS names fail; `HeroWebViewDemo/Info.plist` has one.
