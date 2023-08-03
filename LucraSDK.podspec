Pod::Spec.new do |s|
    s.name             = 'LucraSDK'
    s.version          = '0.0.1'
    s.summary          = 'LucraSDK for iOS'

    s.description      = <<-DESC
    LucraSDK for iOS.
    DESC

    s.homepage         = 'https://lucrasports.com'
    s.license          = { :type => 'Copyright', :text => 'Copyright 2023 Lucra' }
    s.authors          = 'Lucra, Inc.'

    s.module_name = "LucraSDK"
    s.source = { :http => "https://kineticlucrasdk.s3.amazonaws.com/LucraSDK.zip" }
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
