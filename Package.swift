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
                      url: "https://github.com/zgr-im/zgr-pushservice-ios-sdk-builds/releases/download/1.6.3/ZGRImSDK.xcframework.zip",
                      checksum: "3c3fb737411ef72f29e3174d3d22c54befaead8a1f1c228a80a01a7bac4b5987")
    ]
)
