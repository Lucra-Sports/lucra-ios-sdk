# ``LucraSDK``

# Documentation

You can find usage documentation at [Lucra Native iOS SDK](https://docs.lucrasports.com/lucra-sdk/3v52KwIeTxQOM0ni1gLl/).

Explore more via the [example projects](https://github.com/Lucra-Sports/lucra-ios-sdk/tree/main/Example).

# Dependencies

LucraSDK uses [Sentry](https://github.com/getsentry/sentry-cocoa) for its own diagnostics. It never
calls `SentrySDK.start`, installs no crash handler, and sends nothing to your Sentry project.

The framework itself does not link Sentry. The code that talks to Sentry ships as source and compiles
inside your app against the Sentry your project already resolves, so there is only ever one copy of
Sentry in the process.

- **Swift Package Manager:** add the product that matches how your app links Sentry. `LucraSDK` links
  Sentry's `Sentry-Dynamic` product and is right for apps with no Sentry of their own or with
  `Sentry-Dynamic`; `LucraSDK-StaticSentry` links the static `Sentry` product. Any sentry-cocoa from
  8.58.0 through 9.x resolves.
- **CocoaPods:** `pod 'LucraSDK'` compiles the telemetry sources into your Pods project with whichever
  linkage your `use_frameworks!` line sets, static included, with no Podfile hook. The pod declares
  `Sentry >= 8.58.0, < 9.0`.
