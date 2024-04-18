// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppInfoProvider",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppInfoProvider",
            targets: ["AppInfoProvider"]
        ),
        .library(
            name: "AppInfoProviderMocks",
            targets: ["AppInfoProviderMocks"]
        )
    ],
    dependencies: [
        .package(path: "../../../DomainLayer/SharedDomain"),
        .package(path: "../../../DomainLayer/Utilities")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppInfoProvider",
            dependencies: [
                .product(name: "SharedDomain", package: "SharedDomain"),
                .product(name: "Utilities", package: "Utilities")
            ]
        ),
        .target(
            name: "AppInfoProviderMocks",
            dependencies: [
                "AppInfoProvider"
            ]
        )
    ]
)
