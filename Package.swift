// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "8.0.0"

let hostedPackageURL = "https://lucra-sdk.s3.amazonaws.com/ios/spm/\(version)"

let package = Package(
    name: "LucraSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "LucraSDK", targets: ["LucraSDK", "LucraCore"]),
        .library(name: "LucraSDK-StaticSentry", targets: ["LucraSDK", "LucraCoreStatic"])
    ],
    dependencies: [
        .package(url: "https://github.com/getsentry/sentry-cocoa", "8.58.0"..<"10.0.0")
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
            path: "LucraCore/Dynamic"
        ),
        .target(
            name: "LucraCoreStatic",
            dependencies: [
                "LucraSDK",
                "MobileIntelligence",
                "GeoComplySDK",
                .product(name: "Sentry", package: "sentry-cocoa")
            ],
            path: "LucraCore/Static"
        ),
        .binaryTarget(
            name: "LucraSDK",
            url: "\(hostedPackageURL)/LucraSDK.xcframework.zip",
            checksum: "4512d22d0a7e355f0ee5383526c7c0e352b5127b5dd2f91b5829b4fd225a92aa"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "7cd967fa2dd8c7a4dc4f0af4826552ae980f45141ddeef44d02ecc14c7c0f98e"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "381bcab14c0c0c3eab0e4f7bf9853b375d5af0ffaa6535c1cc1739d9751872fb"
        )
    ]
)
