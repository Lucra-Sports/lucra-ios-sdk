# ``LucraSDK``

# Documentation

You can find usage documentation at [Lucra Native iOS SDK](https://docs.lucrasports.com/lucra-sdk/3v52KwIeTxQOM0ni1gLl/).

Explore more via the [example projects](https://github.com/Lucra-Sports/lucra-ios-sdk/tree/main/Example).

# Dependencies

LucraSDK dynamically links [Sentry](https://github.com/getsentry/sentry-cocoa) for
diagnostics, and expects the host app to provide a single, matching copy of the dynamic
`Sentry.framework` at runtime.

- **Swift Package Manager / CocoaPods:** integrating LucraSDK as documented brings Sentry in
  automatically — the Swift package links the `Sentry-Dynamic` product and the podspec declares
  the `Sentry` dependency. No extra setup is required.
- **Version alignment:** LucraSDK ships **Sentry 8.58.4**. If your app already uses Sentry, align
  it to **8.58.4 or newer within 8.x** and link the dynamic `Sentry-Dynamic` product (not the
  static `Sentry`). An older/next-major pin fails dependency resolution before building; a static
  Sentry alongside Lucra's dynamic one, or a second copy in the process, crashes at launch.
- **CocoaPods linkage:** LucraSDK vendors dynamic xcframeworks, so keep `use_frameworks!`
  (dynamic) in your `Podfile` and do not set `:linkage => :static`. Static linkage builds but
  the app crashes at launch with `Library not loaded: @rpath/Sentry.framework/Sentry`.

If Sentry is missing, the app terminates during launch with a dynamic-linker error:
`Library not loaded: @rpath/Sentry.framework/Sentry`.
