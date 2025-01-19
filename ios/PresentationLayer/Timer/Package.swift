// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Timer",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Timer",
            targets: ["Timer"]
        ),
    ],
    dependencies: [
        .package(path: "../UIToolKit"),
        .package(path: "../Profile"),
        .package(path: "../../DomainLayer/Utilities"),
        .package(path: "../../DomainLayer/SharedDomain"),
        .package(path: "../../Application/DependencyInjection"),
        .package(url: "https://github.com/hmlongco/Factory.git", .upToNextMajor(from: "2.3.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Timer",
            dependencies: [
                .product(name: "UIToolkit", package: "UIToolkit"),
                .product(name: "Profile", package: "Profile"),
                .product(name: "Utilities", package: "Utilities"),
                .product(name: "SharedDomain", package: "SharedDomain"),
                .product(name: "DependencyInjection", package: "DependencyInjection"),
                .product(name: "DependencyInjectionMocks", package: "DependencyInjection"),
                .product(name: "Factory", package: "Factory")
            ]
        ),
        .testTarget(
            name: "TimerTests",
            dependencies: [
                "Timer",
                .product(name: "UIToolkit", package: "UIToolkit"),
                .product(name: "SharedDomain", package: "SharedDomain"),
                .product(name: "DependencyInjection", package: "DependencyInjection"),
                .product(name: "Factory", package: "Factory")
            ]
        ),
    ]
)
