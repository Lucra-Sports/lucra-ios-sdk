// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "5.0.1"

let hostedPackageURL = "https://lucra-sdk.s3.amazonaws.com/ios/spm/\(version)"

let package = Package(
    name: "LucraSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "LucraSDK", targets: ["LucraSDK", "LucraCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/auth0/Auth0.swift.git", .upToNextMajor(from: "2.0.0"))
    ],
    targets: [
        .target(
            name: "LucraCore",
            dependencies: [
                "LucraSDK",
                "MobileIntelligence",
                "GeoComplySDK",
                .product(name: "Auth0", package: "Auth0.swift")
            ],
            path: "LucraSDKTarget"
        ),
        .binaryTarget(
            name: "LucraSDK",
            url: "\(hostedPackageURL)/LucraSDK.xcframework.zip",
            checksum: "8fb26507ab3d2dac90fc7589df87f98f95ad49ed71332ed8e7d1c4f5de2a4db3"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "d3780f3e3213e9d31025e033964b20bdd6ebd89ed143bfcb67d3d2be2d3e8cb9"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "7b5e3af662793d713e9634ba0f2c8ed59fd1c57aea9a62cf1b621969eb452210"
        )
    ]
)
