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
                      url: "https://github.com/zgr-im/zgr-pushservice-ios-sdk-builds/releases/download/1.6.1/ZGRImSDK.xcframework.zip",
                      checksum: "c0dc30ba4c9aed7d80e05e99380a8e46d724a430e40c37ffd9268fa293cc8cb6")
    ]
)
