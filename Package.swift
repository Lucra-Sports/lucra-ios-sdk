// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "1.3.7"

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
        .package(url: "https://github.com/kean/NukeUI", .upToNextMajor(from: "0.8.1"))
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
                .byName(name: "NukeUI"),
                .product(name: "ZendeskSupportSDK", package: "support_sdk_ios")
            ],
            path: "LucraSDKTarget"
        ),
        .binaryTarget(
            name: "LucraSDK",
            url: "\(hostedPackageURL)/LucraSDK.xcframework.zip",
            checksum: "f43855f87b701324c0785f83c53991a9961bc48226f2f4cd39d62f404a89a996"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "d48bf984cbc54c204e1cfaa08882fef21c50bfe41497f3451bd84894b8903f0c"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "46b9050b534e3ef813c7856636046f544852f23faf9471ddcaf295075ea763cb"
        ),
        .binaryTarget(
            name: "GCSDKDomain",
            url: "\(hostedPackageURL)/GCSDKDomain.xcframework.zip",
            checksum: "299c26e00ba1ab2ed196499e8a6735942ba80beccbfd31ac5161d4c683b66d1a"
        ),
        .binaryTarget(
            name: "GeoComplySDK291",
            url: "\(hostedPackageURL)/GeoComplySDK291.xcframework.zip",
            checksum: "28f97889142321c70550327f966c348a156cde025bd2fb91a5c42b465b59f8a9"
        )
    ]
)
