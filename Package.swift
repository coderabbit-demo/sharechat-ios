// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "FeedKit",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(name: "FeedKit", targets: ["FeedKit"]),
    ],
    targets: [
        .target(name: "FeedKit"),
        .testTarget(
            name: "FeedKitTests",
            dependencies: ["FeedKit"],
            resources: [.copy("Fixtures")]
        ),
    ]
)
