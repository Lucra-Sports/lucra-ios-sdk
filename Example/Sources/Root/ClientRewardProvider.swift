//
//  ClientRewardProvider.swift
//  CocoaPodsSample
//
//  Created by Wellison Pereira on 11/15/24.
//

import Foundation
import LucraSDK
import UIKit

enum ClientRewardProviderRedeemLogic: Hashable, Comparable {
    var displayableName: String {
        switch self {
        case .inApp: "In App"
        case .browser: "Open in Browser"
        }
    }
    
    case inApp, browser(url: String)
}

class ClientRewardProvider: ObservableObject {
    // redeem logic only
    @Published var rewardToShow: LucraReward?
    
    var artificialDelay: UInt64 = 2
    var redeemLogic: ClientRewardProviderRedeemLogic = .inApp
    var availableRewards: [LucraReward] = [.lucraPromo, .freeBurger, .freeCoffee]
    
    func navigateToRewardView(reward: LucraReward) {
        rewardToShow = reward
    }
    
    func attach() {
        debugPrint("ClientRewardProvider: attaching to view")
    }
}

extension ClientRewardProvider: LucraRewardProvider {
    
    func availableRewards() async -> [LucraReward] {
        // fake delay to simulate an actual request from client's BE
        let nanoseconds = artificialDelay * 1_000_000_000
        try? await Task.sleep(nanoseconds: nanoseconds)
        return availableRewards
    }
    
    func claimReward(reward: LucraReward) {
        switch redeemLogic {
        case .inApp:
            navigateToRewardView(reward: reward)
        case .browser(url: let url):
            let url = URL(string: url) ?? URL(string: "https://google.com")!
            UIApplication.shared.open(url)
        }
    }
    
    
    func viewRewards() {
        
    }
}

private extension LucraReward {
    static var lucraPromo: LucraReward {
        LucraReward(rewardId: "LucraInternalCompetition",
                    title: "Lucra Competition",
                    descriptor: "$2 Gift Card of Your Choice",
                    iconUrl: "https://lucrasports.com/images/about/images/energy-icon.svg",
                    bannerIconUrl: "https://i.imgur.com/AGEQN.jpeg",
                    disclaimer: "Just have fun!",
                    metadata: nil)
    }
    
    static var freeCoffee: LucraReward {
        LucraReward(rewardId: "iOSFreeCoffee",
                    title: "Free Coffee!",
                    descriptor: "Any special coffee up to $10!",
                    iconUrl: "https://lucrasports.com/images/about/images/energy-icon.svg",
                    bannerIconUrl: "https://i.imgur.com/8kolGy1.jpeg",
                    disclaimer: "Don't get addicted",
                    metadata: nil)
    }
    
    static var freeBurger: LucraReward {
        LucraReward(rewardId: "iOSFreeBurger",
                    title: "Free Burger!",
                    descriptor: "It's on the house!",
                    iconUrl: "https://lucrasports.com/images/about/images/energy-icon.svg",
                    bannerIconUrl: "https://i.imgur.com/TziClCl.jpeg",
                    disclaimer: "Try our special sauce!",
                    metadata: nil)
    }
}
