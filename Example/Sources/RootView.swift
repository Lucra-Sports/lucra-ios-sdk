//
//  ContentView.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 6/5/23.
//

import SwiftUI
import LucraSDK

struct RootView: View {
    @StateObject private var lucraClient = LucraClient(config: .init(environment: .init(authenticationClientID: lucraAPIKey,
                                                                                        environment: lucraEnvironment,
                                                                                        urlScheme: lucraURLScheme
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
                ExampleList()
            }
            .environmentObject(lucraClient)
        } else {
            NavigationView {
                ExampleList()
            }
            .environmentObject(lucraClient)
        }
    }
}

struct ExampleList: View {
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
        }
        .navigationTitle("SDK Sample App")
    }
}

