// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let version = "7.0.1"

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
            checksum: "53fba8ab9a12a99eae455d0ac9659b33cf21fe0b14d807adfb74158abf7769b7"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            url: "\(hostedPackageURL)/MobileIntelligence.xcframework.zip",
            checksum: "db8c92c50f4d002764fd9f450f7a2e4a2c3cbf4abf5472edef5963300b7a923a"
        ),
        .binaryTarget(
            name: "GeoComplySDK",
            url: "\(hostedPackageURL)/GeoComplySDK.xcframework.zip",
            checksum: "782b1a10bb0ec7b5caec0e4f42e766f93014565f4b75af56b6cacaa1c61e5538"
        )
    ]
)
