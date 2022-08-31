// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ModelAuthenticationLimitMiddleware",
    products: [
        .library(
            name: "ModelAuthenticationLimitMiddleware",
            targets: ["ModelAuthenticationLimitMiddleware"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/fluent-mysql-driver.git", from: "4.0.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "ModelAuthenticationLimitMiddleware",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentMySQLDriver", package: "fluent-mysql-driver"),
                .product(name: "Leaf", package: "leaf"),
                .product(name: "Vapor", package: "vapor"),
            ]),
        .testTarget(
            name: "ModelAuthenticationLimitMiddlewareTests",
            dependencies: ["ModelAuthenticationLimitMiddleware"]),
    ]
)
