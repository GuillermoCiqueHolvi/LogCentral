// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "LogCentral",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_12)
    ],
    products: [
        .library(name: "LogCentral", targets: ["LogCentral"])
    ],
    targets: [
        .target(name: "LogCentral", path: "Sources"),
        .testTarget(name: "LogCentralTests", dependencies: ["LogCentral"], path: "Tests")
    ],
    swiftLanguageVersions: [.v5]
)
