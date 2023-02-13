// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ZGRImSDK",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "ZGRImSDK", targets: ["ZGRImSDK"])
    ],
    targets: [
        .binaryTarget(name: "ZGRImSDK",
                      url: "https://github.com/zgr-im/zgr-pushservice-ios-sdk-builds/releases/download/1.6.2/ZGRImSDK.xcframework.zip",
                      checksum: "0243465c569d289fc7dd0093a5f8fb1dde9123aea2f8ea0c75803c2cc8cbd1d0")
    ]
)
