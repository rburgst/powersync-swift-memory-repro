// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "PowerSyncMemoryRepro",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "PowerSyncMemoryRepro", targets: ["PowerSyncMemoryRepro"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/powersync-ja/powersync-swift",
            exact: "1.6.0"
        )
    ],
    targets: [
        .target(
            name: "PowerSyncMemoryRepro",
            dependencies: [
                .product(name: "PowerSync", package: "powersync-swift")
            ]
        ),
        .testTarget(
            name: "PowerSyncMemoryReproTests",
            dependencies: ["PowerSyncMemoryRepro"]
        )
    ]
)
