//
//  SwiftUIExample.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 6/26/23.
//

import SwiftUI
import LucraSDK

struct SwiftUIExample: View {
    @EnvironmentObject var lucraClient: LucraClient
    
    @Environment(\.dismiss) private var dismiss
    @State private var currentLucraFlow: LucraFlow?

    var body: some View {
        VStack(spacing: 25) {
            ForEach(LucraFlow.allCases) { flow in
                button(title: flow.displayName) {
                    currentLucraFlow = flow
                }
            }
        }
        .navigationBarTitle("SwiftUI Example")
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
