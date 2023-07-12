// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LucraSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "LucraSDK",
            targets: ["LucraSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/AndreaMiotto/PartialSheet.git", .upToNextMajor(from: "2.1.14")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.5.0")),
        .package(url: "https://github.com/mrackwitz/Version", .upToNextMajor(from: "0.8.0")),
        .package(url: "https://github.com/stripe/stripe-ios.git", .upToNextMajor(from: "22.7.0")),
        .package(url: "https://github.com/Lucra-Sports/EncryptCard.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/twostraws/CodeScanner.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/AppsFlyerSDK/segment-appsflyer-ios", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/iterable/swift-sdk", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/zendesk/support_sdk_ios", .upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/apollographql/apollo-ios.git", .upToNextMajor(from: "0.50.0")),
        .package(url: "https://github.com/hmlongco/Resolver", .upToNextMajor(from: "1.5.0")),
        .package(url: "https://github.com/auth0/Auth0.swift.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "3.4.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "8.10.0")),
        .package(url: "https://github.com/hmlongco/Resolver", .upToNextMajor(from: "1.5.0")),
        .package(url: "https://github.com/kean/Pulse.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/kean/NukeUI", .upToNextMajor(from: "0.8.1")),
        
    ],
    targets: [
        .binaryTarget(
          name: "LucraSDK",
          url: "https://kineticlucrasdk.s3.amazonaws.com/LucraSDK.xcframework.zip",
          checksum: "68d61258dd56a52abc2bc0bc6595c9377ac14af494b2d069302c8610905a7e52"
        ),
        .testTarget(
            name: "LucraSDKTests",
            dependencies: ["LucraSDK"]),
    ]
)
