// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-rfc-7405",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
    ],
    products: [
        .library(
            name: "RFC 7405",
            targets: ["RFC 7405"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-primitives/swift-standard-library-extensions.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-ascii-primitives.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-ietf/swift-rfc-5234.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "RFC 7405",
            dependencies: [
                .product(name: "RFC 5234", package: "swift-rfc-5234"),
                .product(
                    name: "Standard Library Extensions",
                    package: "swift-standard-library-extensions"
                ),
                .product(name: "ASCII Primitives", package: "swift-ascii-primitives"),
            ]
        ),
        .testTarget(
            name: "RFC 7405 Tests",
            dependencies: [
                "RFC 7405"
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

extension String {
    var tests: Self { self + " Tests" }
}

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
