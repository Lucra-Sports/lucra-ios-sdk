//
//  MiniGamesViewModel.swift
//  LucraSDK
//
//  Created by Wellison Pereira on 7/15/26.
//

import LucraSDK
import SwiftUI

public class MiniGamesViewModel: ObservableObject {

    @ObservedObject private(set) var lucraClient: LucraClient
    @Published private(set) var inProgress: [LucraUserProfileMatchupItem]
    @Published private(set) var completed: [LucraUserProfileMatchupItem]
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorDetails: String?

    init(lucraClient: LucraClient) {
        self.lucraClient = lucraClient
        self.inProgress = []
        self.completed = []
    }

    /// Loads the signed-in user's recent matchups headlessly and sections them
    /// client-side on status. A finished matchup has a status of `.result`.
    public func loadMatchups() {
        isLoading = true
        errorDetails = nil

        Task { @MainActor in
            defer { isLoading = false }

            let result = await lucraClient.api.fetchUserProfileMatchups(limit: 50)

            switch result {
            case .success(let (matchups, _)):
                self.inProgress = matchups.filter { $0.status == .inProgress }
                self.completed = matchups.filter { $0.status == .result }
            case .failure(let error):
                self.errorDetails = error.localizedDescription
            }
        }
    }
}
