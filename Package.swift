// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "8.0.1"

let hostedPackageURL = "https://lucra-sdk.s3.amazonaws.com/ios/spm/\(version)"

let package = Package(
    name: "LucraSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "LucraSDK", targets: ["LucraSDK", "LucraCore"]),
        .library(name: "LucraSDK-StaticSentry", targets: ["LucraSDK", "LucraCoreStatic"])
    ],
    dependencies: [
        .package(url: "https://github.com/getsentry/sentry-cocoa", "8.58.0"..<"10.0.0")
    ],
    targets: [
        .target(
            name: "LucraCore",
            dependencies: [
                "LucraSDK",
                "MobileIntelligence",
                "GeoComplySDK",
                .product(name: "Sentry-Dynamic", package: "sentry-cocoa")
            ],
            path: "LucraCore/Dynamic"
        ),
        .target(
            name: "LucraCoreStatic",
            dependencies: [
                "LucraSDK",
                "MobileIntelligence",
                "GeoComplySDK",
                .product(name: "Sentry", package: "sentry-cocoa")
            ],
            path: "LucraCore/Static"
        ),
        .binaryTarget(
            name: "LucraSDK",
            url: "\(hostedPackageURL)/LucraSDK.xcframework.zip",
            checksum: "3454806e75fb3c2280d0a7fd10320c1b07167d451e7119afcf57c20f60976dec"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "90a85ee56f73f568d024bf0a3d7264c95f8644d8cc3968667b11b9f852fcda37"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "2dc6f34a2507f1625b90a99286843594b41ba709f50325c1f7ba5301fe58f3ca"
        )
    ]
)
