//
//  APIExampleSportsViewModel.swift
//  SDK Sample
//
//  Created by Wellison Pereira on 5/2/24.
//

import SwiftUI
import LucraSDK

class APIExampleSportsViewModel: ObservableObject {
    let lucraClient: LucraClient
    @Published var matchup: LucraMatchup?
    
    init(lucraClient: LucraClient) {
        self.lucraClient = lucraClient
    }
    
    func loadContest(contestId: String) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                self.matchup = try await lucraClient.api.matchup(for: contestId)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
}
