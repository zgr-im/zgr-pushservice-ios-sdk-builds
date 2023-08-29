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
                      url: "https://github.com/zgr-im/zgr-pushservice-ios-sdk-builds/releases/download/1.7.1/ZGRImSDK.xcframework.zip",
                      checksum: "ee4435b500054dab78a8d2d35fadc87e62753224164b9b97a5c738d96419e5ae")
    ]
)
