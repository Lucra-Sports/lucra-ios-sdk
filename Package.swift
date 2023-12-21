// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "0.7.5"

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
            checksum: "4923bc5fb48a19e741ca1e5abe97c31f37747198e38d3a4d02ec7a8dfe517878"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "2f8b85e7ad374d707b2ea822877102c67130fe303bfb24e188167c487608e9f5"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "e23d6ae15fd2f6d68ee6567cdc9f2405c096171daa9ec7fa99a38c512e1bde2d"
        ),
        .binaryTarget(
            name: "GCSDKDomain",
            url: "\(hostedPackageURL)/GCSDKDomain.xcframework.zip",
            checksum: "211de3e3e2af72268f48feb33107b73d1c660a38e90e0fc9c400281dd423ca87"
        ),
        .binaryTarget(
            name: "GeoComplySDK291",
            url: "\(hostedPackageURL)/GeoComplySDK291.xcframework.zip",
            checksum: "fffe9622b2327efecd6298fa7de4da88dcd4a6560a3ff4f420d3192ce4d60e00"
        )
    ]
)
