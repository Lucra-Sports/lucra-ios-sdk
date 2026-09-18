// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "6.0.1"

let hostedPackageURL = "https://lucra-sdk.s3.amazonaws.com/ios/spm/\(version)"

let package = Package(
    name: "LucraSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "LucraSDK", targets: ["LucraSDK", "LucraCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/getsentry/sentry-cocoa", from: "8.58.4")
    ],
    targets: [
        .target(
            name: "LucraCore",
            dependencies: [
                "LucraSDK",
                "MobileIntelligence",
                "GeoComplySDK",
                .product(name: "Sentry-Dynamic", package: "sentry-cocoa")
            ],
            path: "LucraSDKTarget"
        ),
        .binaryTarget(
            name: "LucraSDK",
            url: "\(hostedPackageURL)/LucraSDK.xcframework.zip",
            checksum: "5d6a87dff34b5e69ffcf18069fce5dd86a477166c02ffbee03f2b55de608223e"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "9bd9a58bcaba80511fdb9fbc3a2dd063c38df5001b360f53dd91f6ae3551f2ac"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "e17d375a98f573d0be73889c11f3b89ca93eacb98ba963b2765ce467bd7b92c0"
        )
    ]
)
