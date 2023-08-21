Pod::Spec.new do |s|
    s.name             = 'LucraSDK'
    s.version          = '0.2.0'
    s.summary          = 'LucraSDK for iOS'

    s.description      = <<-DESC
    LucraSDK for iOS.
    DESC

    s.homepage         = 'https://lucrasports.com'
    s.license          = { :type => 'Copyright', :text => 'Copyright 2023 Lucra' }
    s.authors          = 'Lucra, Inc.'

    s.module_name = "LucraSDK"
    s.source = { :http => "https://lucra-sdk.s3.amazonaws.com/ios/cocoapods/#{s.version}/LucraSDK.zip" }
    s.vendored_frameworks = "#{s.module_name}.xcframework", "MobileIntelligence.xcframework"
    s.preserve_paths = "#{s.module_name}.xcframework/*", "MobileIntelligence.xcframework/*"

    s.cocoapods_version = ">= 1.11.0"
    
    s.swift_version     = '5.8'

    s.ios.deployment_target  = '15.0'
    s.dependency 'Alamofire'
    s.dependency 'Iterable-iOS-SDK'
    s.dependency 'ZendeskSupportSDK'
    s.dependency 'Auth0'
    s.dependency 'Resolver'
    s.dependency 'PulseUI'
    s.dependency 'PulseCore'
    s.dependency 'NukeUI'
 
end
