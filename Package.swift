// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "LogCentral",
    products: [
        .library(name: "LogCentral", targets: ["LogCentral"])
    ],
    targets: [
        .target(name: "LogCentral", path: "Sources"),
        .testTarget(name: "LogCentralTests", dependencies: ["LogCentral"], path: "Tests")
    ]
)
