//
//  SDK_SampleApp.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 6/5/23.
//

import LucraSDK
import SwiftUI

@main
struct SDK_SampleApp: App {
    @StateObject private var lucraClient: LucraClient = .init(config: .init(environment: .init(apiKey: lucraAPIKey,
                                                                                               environment: lucraEnvironment,
                                                                                               urlScheme: lucraURLScheme,
                                                                                               merchantID: lucraMerchantID)))
    
    init() {
        registerLoggingService()
    }
    
    private func registerLoggingService() {
        if lucraEnvironment == .production {
            Resolver.register { BaseLogging(level: .error) as LoggingService }
                .scope(.application)
        } else {
            Resolver.register { SampleLogging(level: .debug) as LoggingService }
                .scope(.application)
        }
        
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(lucraClient)
        }
    }
}
