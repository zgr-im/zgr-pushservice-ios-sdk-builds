Pod::Spec.new do |spec|

  spec.name         = "ZGRImSDK"
  spec.version      = "1.7.2"
  spec.summary      = "ZGRImSDK.xcframework is a push-service library."
  spec.description  = <<-DESC
	ZGRImSDK.xcframework is a push-service library working with APNS.
                   DESC
  spec.homepage     = "https://github.com/zgr-im/zgr-pushservice-ios-sdk-builds"
  spec.author       = { "Alex" => "infoweb77@protonmail.com" }
  spec.license      = "MIT"
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/zgr-im/zgr-pushservice-ios-sdk-builds.git", :tag => "#{spec.version}" }
  spec.vendored_frameworks  = "ZGRImSDK.xcframework"

end
