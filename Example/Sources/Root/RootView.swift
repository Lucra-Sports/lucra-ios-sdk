//
//  ContentView.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 6/5/23.
//

import SwiftUI
import LucraSDK

struct RootView: View {
    @StateObject private var lucraClient = LucraClient(config: .init(environment: .init(apiURL: lucraAPIURL,
                                                                                        apiKey: lucraAPIKey,
                                                                                        environment: lucraEnvironment,
                                                                                        urlScheme: lucraURLScheme,
                                                                                        merchantID: lucraMerchantID
                                                                                       ),
                                                                     appearance: ClientTheme(background: "#001448",
                                                                                             surface: "#1C2575",
                                                                                             primary: "#09E35F",
                                                                                             secondary: "#5E5BD0",
                                                                                             tertiary: "#9C99FC",
                                                                                             onBackground: "#FFFFFF",
                                                                                             onSurface: "#FFFFFF",
                                                                                             onPrimary: "#001448",
                                                                                             onSecondary: "#FFFFFF",
                                                                                             onTertiary: "#FFFFFF"
                                                                                            )))
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ExampleList(lucraClient: lucraClient)
            }
            .environmentObject(lucraClient)
        } else {
            NavigationView {
                ExampleList(lucraClient: lucraClient)
            }
            .environmentObject(lucraClient)
        }
    }
}

struct ExampleList: View {
    @ObservedObject var lucraClient: LucraClient
    
    var body: some View {
        List {
            NavigationLink("SwiftUI Example") {
                SwiftUIExample()
            }
            NavigationLink("UIKit Example") {
                UIKitSampleViewControllerRepresentable()
                    .navigationBarTitleDisplayMode(.inline)
            }
            NavigationLink("API Example") {
                APIExample()
            }
            NavigationLink("Configure User") {
                ConfigureUserView(lucraClient: lucraClient)
            }
        }
        .navigationTitle("SDK \(LucraSDK.sdkVersion)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Logout") {
                    Task {
                        await lucraClient.logout()
                    }
                }
            }
        }
        .onOpenURL(perform: { url in
            lucraClient.handlePaypalVenmoCallback(url: url)
        })
        .onAppear {
            lucraClient.registerDeeplinkProvider({ link in
                switch await ClientDeeplinkService().pack(deeplink: link) {
                case .success(let urlString):
                    return urlString
                case .failure(let error):
                    throw error
                }
            })
        }
    }
}
