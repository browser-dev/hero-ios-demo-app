# HeroWebView demo app for iOS

An Xcode project that opens `vitalik.eth`, `shakeshift` and other crypto
domains in `HeroWebView`, the Hero engine shipped as `HeroWebView.xcframework`.
It builds against the SDK the way any other app does.

## The SDK

The project reads the xcframework from `HERO_WEB_VIEW_SDK_DIR`, which defaults
to `HeroWebViewSDK/` next to the project. The rc updater serves the latest
release build:

```
curl -L -o HeroWebViewSDK-ios.zip "https://rc-updates.hero.io/v2/api/latest?os=webview-sdk-ios"
unzip HeroWebViewSDK-ios.zip -d HeroWebViewSDK
```

The zip also carries the SDK's `README.md`, with the integration steps the
Integrate tab shows.

## Build and test

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
