// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "0.7.3"

let hostedPackageURL = "https://lucra-sdk.s3.amazonaws.com/ios/spm/\(version)"

let package = Package(
    name: "LucraSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "LucraSDK", targets: ["LucraSDK", "LucraCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.5.0")),
        .package(url: "https://github.com/iterable/swift-sdk", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/zendesk/support_sdk_ios", .upToNextMajor(from: "8.0.0")),
        .package(url: "https://github.com/auth0/Auth0.swift.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/hmlongco/Resolver", .upToNextMajor(from: "1.5.0")),
        .package(url: "https://github.com/kean/Pulse.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/kean/NukeUI", .upToNextMajor(from: "0.8.1")),
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
                .byName(name: "Pulse"),
                .product(name: "PulseUI", package: "Pulse"),
                .byName(name: "NukeUI"),
                .byName(name: "Alamofire"),
                .product(name: "IterableSDK", package: "swift-sdk"),
                .product(name: "ZendeskSupportSDK", package: "support_sdk_ios"),
            ],
            path: "LucraSDKTarget"
        ),
        .binaryTarget(
            name: "LucraSDK",
            url: "\(hostedPackageURL)/LucraSDK.xcframework.zip",
            checksum: "9865177677fb4e0902f6bdaa2517bbc1e12a6d791315ef1f925bbaa486a887f6"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "953296a019c29d29d821184d9714137da084ef0da847b2d5255994e654ea855a"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "c9cbb7c8bc67fc79317be2d279a4504fd621dd8e77ad7481691603005d47c64b"
        ),
        .binaryTarget(
            name: "GCSDKDomain",
            url: "\(hostedPackageURL)/GCSDKDomain.xcframework.zip",
            checksum: "1e3f4e23c61fe660eb49afcdd784fc3a96036d2a3f4fe1be2a01b7f6a8ef843b"
        ),
        .binaryTarget(
            name: "GeoComplySDK291",
            url: "\(hostedPackageURL)/GeoComplySDK291.xcframework.zip",
            checksum: "b0e4f79a151412308ade9624278c226b4603d0c87c00675294371f9d9b58634b"
        )
    ]
)
