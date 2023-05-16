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
                      url: "https://github.com/zgr-im/zgr-pushservice-ios-sdk-builds/releases/download/1.6.4/ZGRImSDK.xcframework.zip",
                      checksum: "74f1312b5bf9938728052a73e1d4458165a54413e4736c9ef414b3f73e1ecd15")
    ]
)
