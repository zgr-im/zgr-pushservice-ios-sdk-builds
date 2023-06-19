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
                      url: "https://github.com/zgr-im/zgr-pushservice-ios-sdk-builds/releases/download/1.6.5/ZGRImSDK.xcframework.zip",
                      checksum: "fd7d0d8d6e6249ffeabba400280a7064660901afca3eb9545e8ebac1f3ce0ca7")
    ]
)
