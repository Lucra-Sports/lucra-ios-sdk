//
//  ContentView.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 6/5/23.
//

import SwiftUI
import LucraSDK

struct RootView: View {
    @State private var flow: LucraFlow?
    @State private var clientRewardProvider = ClientRewardProvider()
    @State private var navigate: Bool = false
    @EnvironmentObject private var lucraClient: LucraClient
    @State var convertToCreditProvider: ConvertToCreditProvider? = ExampleC2CProvider()

    var body: some View {
        Group {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    ExampleList(lucraClient: lucraClient, convertToCreditProvider: convertToCreditProvider)
                }
                .environmentObject(lucraClient)
                .environmentObject(clientRewardProvider)
            } else {
                NavigationView {
                    ExampleList(lucraClient: lucraClient, convertToCreditProvider: convertToCreditProvider)
                }
                .environmentObject(lucraClient)
                .environmentObject(clientRewardProvider)
            }
        }
        .lucraFlow($flow, client: lucraClient)
        .onAppear {
            lucraClient.registerConvertToCreditProvider(convertToCreditProvider)
            lucraClient.registerRewardProvider(clientRewardProvider)
            lucraClient.registerDeeplinkProvider({ link in
                switch await ClientDeeplinkService().pack(deeplink: link) {
                case .success(let urlString):
                    return urlString
                case .failure(let error):
                    debugPrint(error.errorDescription ?? error.localizedDescription)
                    return ""
                }
            })
        }
        .onOpenURL { url in
            handleDeeplink(url)
            lucraClient.handlePaypalVenmoCallback(url: url)
        }
        .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
            guard let url = userActivity.webpageURL else { return }
            handleDeeplink(url)
        }
    }
    
    private func handlePushNotification(_ notification: UNNotification) {
        guard let flow = lucraClient.handlePushNotification(notification: notification) else { return }
        self.flow = flow
    }
    
    private func handleDeeplink(_ url: URL) {
        ClientDeeplinkService().unpack(deeplink: url) { url in
            if let flow = lucraClient.handleDeeplink(url: url) {
                self.flow = flow
            } else {
                // not lucra, client can handle themself
            }
        }
    }
}

struct ExampleList: View {
    @ObservedObject var lucraClient: LucraClient
    @State var convertToCreditProvider: ConvertToCreditProvider?
    
    var body: some View {
        List {
            Section(header: Text("SDK Navigation")) {
                NavigationLink("SwiftUI Example") {
                    SwiftUIExample()
                }
                NavigationLink("UIKit Example") {
                    UIKitSampleViewControllerRepresentable()
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            
            Section(header: Text("Configuration")) {
                NavigationLink("API Example") {
                    List {
                        NavigationLink("Sports You Watch") {
                            APIExampleSportsView(lucraClient: lucraClient)
                        }
                        NavigationLink("Games You Play") {
                            APIExampleGamesView(lucraClient: lucraClient)
                        }
                        NavigationLink("Tournaments") {
                            TournamentsLandingView(lucraClient: lucraClient)
                        }
                    }
                }
                NavigationLink("Configure User") {
                    ConfigureUserView(lucraClient: lucraClient)
                }
                NavigationLink("Configure Reward Provider") {
                    ConfigureRewardProviderView()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Logout") {
                    Task {
                        await lucraClient.logout()
                    }
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                lucraClient.ui.component(.userProfilePill)
                    .fixedSize()
            }
        }
    }
}
