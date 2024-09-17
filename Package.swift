// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "1.8.4"

let hostedPackageURL = "https://lucra-sdk.s3.amazonaws.com/ios/spm/\(version)"

let package = Package(
    name: "LucraSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "LucraSDK", targets: ["LucraSDK", "LucraCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/zendesk/support_sdk_ios", .upToNextMajor(from: "8.0.0")),
        .package(url: "https://github.com/auth0/Auth0.swift.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/hmlongco/Resolver", .upToNextMajor(from: "1.5.0"))
    ],
    targets: [
        .target(
            name: "LucraCore",
            dependencies: [
                "LucraSDK",
                "MobileIntelligence",
                "GeoComplySDK",
                .product(name: "Auth0", package: "Auth0.swift"),
                .byName(name: "Resolver"),
                .product(name: "ZendeskSupportSDK", package: "support_sdk_ios")
            ],
            path: "LucraSDKTarget"
        ),
        .binaryTarget(
            name: "LucraSDK",
            url: "\(hostedPackageURL)/LucraSDK.xcframework.zip",
            checksum: "6ff19d48cba92950b2452e5cb73bb88242386381ed2e1e997735e7820939a60a"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "fd24c138c1beb5ed3cb6cc6daa9665faf5b2f5fe21e231fbc7a9722a3cf30ef3"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "7779a709b82984a5aac6cbe3330c86caf94f04f6c4ec20b9bdf9136e917ea146"
        )
    ]
)
