// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "4.3.0"

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
            checksum: "62d3b6cfb59e5161727f6d8e6f2b8032ed3aabb6974fca026773a6ff7f4e44a5"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "22bc88cc9a156288f37f09a8812082ae09cae3c630af54d1e51f4a11b9cbb6ab"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "fbb497f43f0786d51a083b99270ba79f4fc8a6e22715a1fd945c76d19d615c94"
        )
    ]
)
