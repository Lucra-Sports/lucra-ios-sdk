// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LucraSDK",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "LucraSDK", targets: ["LucraSDK"]),
                .library(name: "LucraCore", targets: ["LucraCore"])
    ],
    dependencies: [
        .package(url: "https://github.com/AndreaMiotto/PartialSheet.git", .upToNextMajor(from: "2.1.14")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.5.0")),
        .package(url: "https://github.com/mrackwitz/Version", .upToNextMajor(from: "0.8.0")),
        .package(url: "https://github.com/Lucra-Sports/EncryptCard.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/twostraws/CodeScanner.git", .upToNextMajor(from: "2.0.0")),
// TODO: SDK is objc means we need bridging header maybe?        .package(url: "https://github.com/AppsFlyerSDK/segment-appsflyer-ios", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/iterable/swift-sdk", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/zendesk/support_sdk_ios", .upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/apollographql/apollo-ios.git", .upToNextMajor(from: "0.50.0")),
        .package(url: "https://github.com/auth0/Auth0.swift.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "3.4.0"),
//        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "8.10.0")),
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
                .product(name: "Apollo", package: "apollo-ios"),
                .product(name: "ApolloWebSocket", package: "apollo-ios"),
                .product(name: "Auth0", package: "Auth0.swift"),
                .byName(name: "PhoneNumberKit"),
//                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
//                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
//                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
//                .product(name: "FirebaseDynamicLinks", package: "firebase-ios-sdk"),
                .byName(name: "Resolver"),
                .byName(name: "Pulse"),
                .product(name: "PulseUI", package: "Pulse"),
                .byName(name: "NukeUI"),
                .byName(name: "Alamofire"),
                .byName(name: "CodeScanner"),
                .byName(name: "EncryptCard"),
                .byName(name: "PartialSheet"),
                .byName(name: "Version"),
//                .byName(name: "segment-appsflyer-ios"),

                .product(name: "IterableSDK", package: "swift-sdk"),
                .product(name: "ZendeskSupportSDK", package: "support_sdk_ios"),
            ],
            path: "LucraSDKTarget"
        ),
        .binaryTarget(
            name: "LucraSDK",
            url: "https://kineticlucrasdk.s3.amazonaws.com/LucraSDK.xcframework.zip",
            checksum: "b88c2654e8ed5d3a449e367362846dbfee3b3f192cd88c6b5b9de868ae1cea7b"
        ),
        .binaryTarget(
            name: "MobileIntelligence",
            path: "MobileIntelligence.xcframework")
    ]
)
