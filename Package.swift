// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "TunnelKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v17)
    ],
    products: [
        .library(name: "TunnelKit", targets: ["TunnelKit"]),
        .library(name: "TunnelKitOpenVPN", targets: ["TunnelKitOpenVPN"]),
        .library(name: "TunnelKitOpenVPNAppExtension", targets: ["TunnelKitOpenVPNAppExtension"]),
        .library(name: "TunnelKitWireGuard", targets: ["TunnelKitWireGuard"]),
        .library(name: "TunnelKitWireGuardAppExtension", targets: ["TunnelKitWireGuardAppExtension"]),
        .library(name: "TunnelKitLZO", targets: ["TunnelKitLZO"])
    ],
    dependencies: [
        // External dependencies
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver", from: "1.9.0"),
        .package(url: "https://github.com/passepartoutvpn/openssl-apple", from: "3.2.105"),
        // ✅ Fixed: use the public upstream WireGuard Apple package
        .package(url: "https://github.com/canstralian/wireguard-apple.git", branch: "master")
    ],
    targets: [
        // MARK: - Core Targets
        .target(
            name: "TunnelKit",
            dependencies: [
                "TunnelKitCore",
                "TunnelKitManager"
            ]
        ),
        .target(
            name: "TunnelKitCore",
            dependencies: [
                "__TunnelKitUtils",
                "CTunnelKitCore",
                "SwiftyBeaver"
            ]
        ),
        .target(
            name: "TunnelKitManager",
            dependencies: ["SwiftyBeaver"]
        ),
        .target(
            name: "TunnelKitAppExtension",
            dependencies: ["TunnelKitCore"]
        ),

        // MARK: - OpenVPN Targets
        .target(
            name: "TunnelKitOpenVPN",
            dependencies: [
                "TunnelKitOpenVPNCore",
                "TunnelKitOpenVPNManager"
            ]
        ),
        .target(
            name: "TunnelKitOpenVPNCore",
            dependencies: [
                "TunnelKitCore",
                "CTunnelKitOpenVPNCore",
                "CTunnelKitOpenVPNProtocol"
            ]
        ),
        .target(
            name: "TunnelKitOpenVPNManager",
            dependencies: [
                "TunnelKitManager",
                "TunnelKitOpenVPNCore"
            ]
        ),
        .target(
            name: "TunnelKitOpenVPNProtocol",
            dependencies: [
                "TunnelKitOpenVPNCore",
                "CTunnelKitOpenVPNProtocol"
            ]
        ),
        .target(
            name: "TunnelKitOpenVPNAppExtension",
            dependencies: [
                "TunnelKitAppExtension",
                "TunnelKitOpenVPNCore",
                "TunnelKitOpenVPNManager",
                "TunnelKitOpenVPNProtocol"
            ]
        ),

        // MARK: - WireGuard Targets
        .target(
            name: "TunnelKitWireGuard",
            dependencies: [
                "TunnelKitWireGuardCore",
                "TunnelKitWireGuardManager"
            ]
        ),
        .target(
            name: "TunnelKitWireGuardCore",
            dependencies: [
                "__TunnelKitUtils",
                "TunnelKitCore",
                .product(name: "WireGuardKit", package: "wireguard-apple"),
                "SwiftyBeaver"
            ]
        ),
        .target(
            name: "TunnelKitWireGuardManager",
            dependencies: [
                "TunnelKitManager",
                "TunnelKitWireGuardCore"
            ]
        ),
        .target(
            name: "TunnelKitWireGuardAppExtension",
            dependencies: [
                "TunnelKitWireGuardCore",
                "TunnelKitWireGuardManager"
            ]
        ),

        // MARK: - LZO Compression
        .target(
            name: "TunnelKitLZO",
            dependencies: [],
            exclude: [
                "lib/COPYING",
                "lib/Makefile",
                "lib/README.LZO",
                "lib/testmini.c"
            ]
        ),

        // MARK: - C Helpers
        .target(name: "CTunnelKitCore", dependencies: []),
        .target(name: "CTunnelKitOpenVPNCore", dependencies: []),
        .target(
            name: "CTunnelKitOpenVPNProtocol",
            dependencies: [
                "CTunnelKitCore",
                "CTunnelKitOpenVPNCore",
                "openssl-apple"
            ]
        ),
        .target(name: "__TunnelKitUtils", dependencies: []),

        // MARK: - Tests
        .testTarget(
            name: "TunnelKitCoreTests",
            dependencies: ["TunnelKitCore"],
            exclude: ["RandomTests.swift", "RawPerformanceTests.swift", "RoutingTests.swift"]
        ),
        .testTarget(
            name: "TunnelKitOpenVPNTests",
            dependencies: [
                "TunnelKitOpenVPNCore",
                "TunnelKitOpenVPNAppExtension",
                "TunnelKitLZO"
            ],
            exclude: [
                "DataPathPerformanceTests.swift",
                "EncryptionPerformanceTests.swift"
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "TunnelKitLZOTests",
            dependencies: ["TunnelKitCore", "TunnelKitLZO"]
        )
    ]
)
