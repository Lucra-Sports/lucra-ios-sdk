// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "1.4.0-optional-test"

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
        .package(url: "https://github.com/hmlongco/Resolver", .upToNextMajor(from: "1.5.0")),
    ],
    targets: [
        .target(
            name: "LucraCore",
            dependencies: [
                "LucraSDK",
                "MobileIntelligence",
                "GeoComplySDK",
                "GCSDKDomain",
                "GeoComplySDK291",
                .product(name: "Auth0", package: "Auth0.swift"),
                .byName(name: "Resolver"),
                .product(name: "ZendeskSupportSDK", package: "support_sdk_ios")
            ],
            path: "LucraSDKTarget"
        ),
        .binaryTarget(
            name: "LucraSDK",
            url: "\(hostedPackageURL)/LucraSDK.xcframework.zip",
            checksum: "09a466308c88845c6e2d639f83f3a60f06894763195ddcd2f3b3816fc8787297"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "ad399331b26a1dc93318e3f50915f232a5b073eb6b0ed12fe0680a02f3dcdf70"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "f3fd52f9f7d54414fb6acf73f4e13040389bf0d9a3a9a0aa5c2bbc451154ed5f"
        ),
        .binaryTarget(
            name: "GCSDKDomain",
            url: "\(hostedPackageURL)/GCSDKDomain.xcframework.zip",
            checksum: "5cdeff74ac422dcfe5f2b5e92d1329c1b459a1e6e1bb1af7f07ea89c7b203ca1"
        ),
        .binaryTarget(
            name: "GeoComplySDK291",
            url: "\(hostedPackageURL)/GeoComplySDK291.xcframework.zip",
            checksum: "aa4e245e7433353a56cdc80f2f02a4224d3c9533cac411998dbe8a011a6316a2"
        )
    ]
)
