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
            checksum: "b82244e98cddb4ad90ecf68ea70abd5b8f702916f155f1b5994224d9554a458d"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "3c117b73f8a98a47196cfc2fae2311fcf7bbe3d442387e0dc06b34a44c45c5d7"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "53f63dde9c3e54147030d78173ed689519dcf9fd9e1a463a649928ef916eef81"
        ),
        .binaryTarget(
            name: "GCSDKDomain",
            url: "\(hostedPackageURL)/GCSDKDomain.xcframework.zip",
            checksum: "45268064a56698092074b0a90ace72886d484e2c1d63ace0be63201fb9efa094"
        ),
        .binaryTarget(
            name: "GeoComplySDK291",
            url: "\(hostedPackageURL)/GeoComplySDK291.xcframework.zip",
            checksum: "bbb81947bbc89915d99627426d6fd70cb15e73977f1c187b6658f2afafd18531"
        )
    ]
)
