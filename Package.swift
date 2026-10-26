// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "7.0.2"

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
            checksum: "0f9fff7986e3e51b6c1ec63b33338d1df889ca3d20e48bf717f00bcb27e2cf2b"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "727eb0405eefca2217b4162bffe979738f3e4c1c0fdf57d8a531794c5af34366"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "f7946e0c94ad14c8df2ba69e558467d6a00d989da3255ffe8d6d25d66630715a"
        )
    ]
)
