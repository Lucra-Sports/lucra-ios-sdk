//
//  SwiftUIExample.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 6/26/23.
//

import SwiftUI
import LucraSDK

struct SwiftUIExample: View {
    @StateObject private var lucraClient = LucraClient(config: .init(environment: .init(authenticationClientID: lucraAPIKey,
                                                                                        environment: lucraEnvironment,
                                                                                        urlScheme: lucraURLScheme),
                                                                     appearance: ClientTheme()))
    @Environment(\.dismiss) private var dismiss
    @State private var currentLucraFlow: LucraFlow?

    var body: some View {
        VStack(spacing: 25) {
            Text("SwiftUI Example")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Image("DylanPingPong")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            
            Spacer()
            
            button(title: "Add Funds") {
                currentLucraFlow = .addFunds
            }
            
            button(title: "Create Games Matchup") {
                currentLucraFlow = .createGamesMatchup
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    currentLucraFlow = .profile
                } label: {
                    Text("⚡️ \((lucraClient.user?.balance ?? 0.0).money)")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color.blue)
                .cornerRadius(.infinity, corners: .allCorners)
            }
        })
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .lucraFlow($currentLucraFlow, client: lucraClient)
    }
    
    private func button(title: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .bold()
                .foregroundColor(.white)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 15)
        .background(Color.blue)
        .cornerRadius(.infinity, corners: .allCorners)
    }
}
