// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Integrations",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Integrations",
            targets: ["Integrations"]
        ),
    ],
    dependencies: [
        .package(name: "UIToolkit", path: "../UIToolkit"),
        .package(name: "Utilities", path: "../../DomainLayer/Utilities"),
        .package(name: "SharedDomain", path: "../../DomainLayer/SharedDomain"),
        .package(name: "DependencyInjection", path: "../../Application/DependencyInjection"),
        .package(url: "https://github.com/hmlongco/Factory.git", .upToNextMajor(from: "2.3.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Integrations",
            dependencies: [
                .product(name: "UIToolkit", package: "UIToolkit"),
                .product(name: "Utilities", package: "Utilities"),
                .product(name: "SharedDomain", package: "SharedDomain"),
                .product(name: "DependencyInjection", package: "DependencyInjection"),
                .product(name: "DependencyInjectionMocks", package: "DependencyInjection"),
                .product(name: "Factory", package: "Factory")
            ]
        ),
        .testTarget(
            name: "IntegrationsTests",
            dependencies: [
                "Integrations",
                .product(name: "SharedDomain", package: "SharedDomain"),
                .product(name: "DependencyInjection", package: "DependencyInjection"),
                .product(name: "Factory", package: "Factory")
            ]
        ),
    ]
)
