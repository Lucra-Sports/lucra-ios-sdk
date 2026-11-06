// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "8.0.0"

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
            checksum: "c82c99142a8a74b53cd40cab8dccd72b3458550e1df5ff4e5325071ccb039c19"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "c3cbae8b71b8be12f7032906b472215afc09fc3dc1d24d1ea1a51a08d76eb86f"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "3e8fd70a9974cfeb9164ca218c5de1127451f5e14d8ed6d680b2d00534881aec"
        )
    ]
)
