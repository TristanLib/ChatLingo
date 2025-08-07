// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "ChatLingo",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    dependencies: [
        // OpenAI Swift SDK
        .package(url: "https://github.com/MacPaw/OpenAI.git", from: "0.2.4"),
        // Networking
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
        // Keychain
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "20.0.0"),
        // Lottie for animations
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.3.4"),
    ],
    targets: [
        .target(
            name: "ChatLingo",
            dependencies: [
                "OpenAI",
                "Alamofire",
                .product(name: "KeychainSwift", package: "keychain-swift"),
                .product(name: "Lottie", package: "lottie-ios")
            ]
        )
    ]
)