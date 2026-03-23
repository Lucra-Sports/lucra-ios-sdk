// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "5.2.0"

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
            checksum: "b14df7416055798cf99208457d4a10ed46d310efada0f6b24a3d49b817016929"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "57cdc0449613f714377446bebc22a61548e9d24aeaf84fda04f097191e191ec3"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "f2c9b606132649550cdf115a4cb18ed384fb1617c885d73418d9368c63d760e0"
        )
    ]
)
