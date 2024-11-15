//
//  ConfigureRewardProviderView.swift
//  CocoaPodsSample
//
//  Created by Wellison Pereira on 11/15/24.
//

import SwiftUI
import LucraSDK

struct ConfigureRewardProviderView: View {
    @EnvironmentObject private var provider: ClientRewardProvider
    @State private var selectedDelay: UInt64 = 0
    @State private var isLoading: Bool = false
    
    @State private var id: String = ""
    @State private var title: String = ""
    @State private var descriptor: String = ""
    @State private var iconUrl: String = ""
    @State private var bannerIconUrl: String = ""
    @State private var disclaimer: String = ""
    @State private var metadata: String = ""
    @State private var redeemLogic: ClientRewardProviderRedeemLogic = .inApp
    
    var body: some View {
        List {
            Section {
                rewardPill()
            } footer: {
                Text("Preview only")
            }
            
            Button("Apply changes") {
                self.provider.availableRewards = [buildModifiedRewardObject()]
                self.provider.artificialDelay = UInt64(selectedDelay)
                self.provider.redeemLogic = redeemLogic
            }
            .frame(maxWidth: .infinity)
            
            Section {
                row(title: "ID", value: $id)
                row(title: "Title", value: $title)
                row(title: "Descriptor", value: $descriptor)
                row(title: "Icon URL", value: $iconUrl)
                row(title: "Banner Icon URL", value: $bannerIconUrl)
                row(title: "Disclaimer", value: $disclaimer)
                row(title: "Metadata", value: $metadata)
            } header: {
                Text("Data model")
            }
            
            Section {
                HStack {
                    Picker("Loading Delay in Seconds", selection: $selectedDelay) {
                        ForEach(Array(UInt64(0)...UInt64(10)), id: \.self) { item in
                            Text("\(item)").tag(item)
                        }
                    }
                    .pickerStyle(.automatic)
                }
                
                HStack {
                    Picker("Redeem logic", selection: $redeemLogic) {
                        let data = [ClientRewardProviderRedeemLogic.inApp, ClientRewardProviderRedeemLogic.browser(url: "https://lucrasports.com")]
                        ForEach(data, id: \.self) { item in
                            Text(item.displayableName).tag(item.hashValue)
                        }
                    }
                    .pickerStyle(.automatic)
                }
            } header: {
                Text("Other customizations")
            }
        }
        .navigationTitle("Rewards Provider")
        .onAppear {
            onAppear()
        }
        .onChange(of: selectedDelay) { _ in
            load()
        }
    }
    
    private func load() {
        Task { @MainActor in
            self.isLoading = true
            try? await Task.sleep(nanoseconds: UInt64(selectedDelay * 1_000_000_000))
            self.isLoading = false
        }
    }
    
    private func buildModifiedRewardObject() -> LucraReward {
        .init(rewardId: id,
              title: title,
              descriptor: descriptor,
              iconUrl: iconUrl,
              bannerIconUrl: bannerIconUrl,
              disclaimer: disclaimer,
              metadata: metadata.jsonStringToDictionary())
    }
    
    private func onAppear() {
        let reward = provider.availableRewards.first!
        self.id = reward.rewardId
        self.title = reward.title
        self.descriptor = reward.descriptor
        self.iconUrl = reward.iconUrl
        self.bannerIconUrl = reward.bannerIconUrl ?? "Not set"
        self.disclaimer = reward.disclaimer ?? "Not set"
        self.metadata = reward.metadata?.toString() ?? "Not set"
        self.redeemLogic = provider.redeemLogic
        self.selectedDelay = 1
    }
    
    private func row(title: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            let placeholder = value.wrappedValue.isEmpty ? "Not Set" : value.wrappedValue
            Text("**\(title)**")
            TextField(text: value, label: { Text(placeholder) })
                .textFieldStyle(.roundedBorder)
        }
    }
    
    @ViewBuilder
    private func rewardPill() -> some View {
        if isLoading {
            loadingSkeleton()
        } else {
            HStack {
                LucraAsyncImage(iconUrl,
                                resize: .aspectFill) {
                    // placeholder
                    Image(systemName: "gift.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                                .frame(width: 42,
                                       height: 42,
                                       alignment: .center)
                                .clipShape(Circle())
                                .padding(7)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .lucraFont(.h6)
                    
                    Text(descriptor)
                        .lucraFont(.h7)
                        .foregroundStyle(Color.lucraPrimary)
                }
                .lineLimit(1)
                
                Spacer()
            }
        }
    }
    
    private func loadingSkeleton() -> some View {
        HStack {
            Circle()
                .frame(width: 42,
                       height: 42,
                       alignment: .center)
                .padding(7)
                .shimmer()
            
            VStack(alignment: .leading, spacing: 5) {
                Rectangle()
                    .frame(height: 15)
                    .cornerRadius(10)
                    .shimmer()
                
                Rectangle()
                    .frame(height: 15)
                    .cornerRadius(10)
                    .shimmer()
            }
            .frame(maxWidth: .infinity)
            .padding(.trailing, 25)
        }
    }
}
