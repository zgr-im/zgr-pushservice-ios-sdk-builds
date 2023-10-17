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
                      url: "https://github.com/zgr-im/zgr-pushservice-ios-sdk-builds/releases/download/1.7.2/ZGRImSDK.xcframework.zip",
                      checksum: "cf43c864c228c64f2abb569e7824c1f1f37305fce4b43cb1ddc15bd0cc8aac80")
    ]
)
