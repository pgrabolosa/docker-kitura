// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Kitura-Starter",
    dependencies: [
     .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.0.0"),
     .package(url: "https://github.com/IBM-Swift/SwiftKueryMySQL.git", from: "1.0.2")
    ],
    targets: [
        .target(
            name: "Kitura-Starter",
            dependencies: ["Kitura", "SwiftKueryMySQL"]),
    ]
)