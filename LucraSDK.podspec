Pod::Spec.new do |s|
    s.name             = 'LucraSDK'
    s.version          = '7.0.2'
    s.summary          = 'LucraSDK for iOS'
    s.description      = <<-DESC
    LucraSDK for iOS.
    DESC
    s.homepage         = 'https://lucrasports.com'
    s.license          = { :type => 'Copyright', :text => 'Copyright 2024 Lucra' }
    s.authors          = 'Lucra, Inc.'
    s.module_name      = "LucraSDKTelemetry"
    s.source           = { :http => "https://lucra-sdk.s3.amazonaws.com/ios/cocoapods/#{s.version}/LucraSDK.zip" }
    s.cocoapods_version = ">= 1.13.0"
    s.swift_version     = '5.8'
    s.ios.deployment_target = '15.0'
    s.default_subspecs = 'Core', 'Telemetry'

    s.subspec 'Core' do |core|
      core.vendored_frameworks = "LucraSDK.xcframework", "MobileIntelligence.xcframework", "GeoComplySDK.xcframework"
      core.preserve_paths = "LucraSDK.xcframework/*", "MobileIntelligence.xcframework/*", "GeoComplySDK.xcframework/*"
    end

    s.subspec 'Telemetry' do |telemetry|
      telemetry.dependency 'LucraSDK/Core'
      telemetry.source_files = 'LucraTelemetry/**/*.swift'
      telemetry.dependency 'Sentry', '>= 8.58.0', '< 9.0'
    end
end
