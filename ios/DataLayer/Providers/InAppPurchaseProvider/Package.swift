// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InAppPurchaseProvider",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "InAppPurchaseProvider",
            targets: ["InAppPurchaseProvider"]
        ),
    ],
    dependencies: [
        .package(path: "../../../DomainLayer/SharedDomain"),
        .package(path: "../../../DomainLayer/Utilities"),
        .package(url: "https://github.com/RevenueCat/purchases-ios-spm.git", exact: "5.7.0")
    ],
    targets: [
        .target(
            name: "InAppPurchaseProvider",
            dependencies: [
                .product(name: "SharedDomain", package: "SharedDomain"),
                .product(name: "Utilities", package: "Utilities"),
                .product(name: "RevenueCat", package: "purchases-ios-spm")
            ]
        ),

    ]
)
