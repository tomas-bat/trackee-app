// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AuthProvider",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AuthProvider",
            targets: ["AuthProvider"]
        ),
        .library(
            name: "AuthProviderMocks",
            targets: ["AuthProviderMocks"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: "10.22.1"),
        .package(path: "../../Utilities/DataUtilities")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AuthProvider",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "DataUtilities", package: "DataUtilities")
            ]
        ),
        .target(
            name: "AuthProviderMocks",
            dependencies: [
                "AuthProvider"
            ]
        )
    ]
)
