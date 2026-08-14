// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "5.8.0"

let hostedPackageURL = "https://lucra-sdk.s3.amazonaws.com/ios/spm/\(version)"

let package = Package(
    name: "LucraSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "LucraSDK", targets: ["LucraSDK", "LucraCore"])
    ],
    targets: [
        .target(
            name: "LucraCore",
            dependencies: [
                "LucraSDK",
                "MobileIntelligence",
                "GeoComplySDK"
            ],
            path: "LucraSDKTarget"
        ),
        .binaryTarget(
            name: "LucraSDK",
            url: "\(hostedPackageURL)/LucraSDK.xcframework.zip",
            checksum: "b511e21b7211435cdf2680ccc3e5d179ea23081db035a5b183e7e92cba4a077b"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "57025e9cf417bc168491e50f723d0ece9ddef042e2fee3f2b20d082dc7e91317"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "498af5f39677aa2d99b8fce7b6adc691c62b2737dc7e682bbd1b2ed8f9a2e603"
        )
    ]
)
