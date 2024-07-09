// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "1.7.0"

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
            checksum: "64b381bda772ba704a2a805d5f4ce92308f4a4ad4173d2d2e670592ad16f2053"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "e737d3d9bae2a5fc3c8184f86d5c25e836d70d05da4914f805eeea8889b7c6c0"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "b2bcd8f228e731e4838b1388b1a56156b6486a2905251c976699de961202947a"
        )
    ]
)
