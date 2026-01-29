//
//  APIExampleViewModel.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 3/14/24.
//

import SwiftUI
import LucraSDK
//import Styleguide

struct ClientMatchup: Identifiable {
    let id: String
    let title: String
    let lucraMatchupId: String?
    var fullLucraMatchup: LucraMatchup?
}

class APIExampleGamesViewModel: ObservableObject {
    let lucraClient: LucraClient
    
    @Published var flow: LucraFlow? = nil
    
    @Published var matchups: [ClientMatchup] = []
    @Published var isWager: Bool = false
    @Published var wagerAmount: Decimal = 1.0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    
    init(lucraClient: LucraClient) {
        self.lucraClient = lucraClient
    }
    
    func loadMatchup(matchupId: String) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            let result = await lucraClient.api.getRecreationalGamesMatchup(matchupId: matchupId)
            
            switch result {
            case .success(let matchup):
                if let index = matchups.firstIndex(where: { $0.lucraMatchupId == matchupId }) {
                    matchups[index].fullLucraMatchup = matchup
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func createMatchup() {
        self.errorMessage = nil
        self.isLoading = true
        
        if isWager {
            Task { @MainActor [weak self] in
                guard let self else { return }
                do {
                    let result = await lucraClient.api.createRecreationalGame(gameTypeId: "DARTS", atStake: .init(cashReward: wagerAmount), playStyle: .groupVsGroup)
                    switch result {
                    case .success(let matchup):
                        createClientMatchup(lucraMatchupId: matchup)
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                    
                } catch let userError as UserStateError {
                    switch userError {
                    case .notInitialized:
                        flow = .onboarding
                    case .unverified:
                        flow = .verifyIdentity
                    case .notAllowed:
                        self.errorMessage = "You are not allowed to perform this action."
                    case .insufficientFunds:
                        flow = .addFunds
                    @unknown default:
                        fatalError()
                    }
                } catch let locationError as LocationError {
                    // Could also show custom location handling here
                    self.errorMessage = locationError.localizedDescription
                } catch let error {
                    self.errorMessage = error.localizedDescription
                }
                
                self.isLoading = false
            }
        } else {
            createClientMatchup()
        }
    }
    
    func cancelMatchup(matchup: ClientMatchup) {
        self.errorMessage = nil
        
        if let lucraMatchupId = matchup.lucraMatchupId {
            Task { @MainActor [weak self] in
                guard let self else { return }
                do {
                    try await lucraClient.api.cancelRecreationalGame(matchupId: lucraMatchupId)
                    cancelClientMatchup(matchup: matchup)
                } catch let error {
                    self.errorMessage = error.localizedDescription
                }
            }
        } else {
            cancelClientMatchup(matchup: matchup)
        }
    }
    
    private func cancelClientMatchup(matchup: ClientMatchup) {
        // MARK: - This is where the client app would cancel its matchup
        self.matchups.removeAll()
        self.isLoading = false
    }
    
    private func createClientMatchup(lucraMatchupId: String? = nil) {
        // MARK: - This is where the client app would create its matchup and store the Lucra matchup id for further interactions with the LucraSDK such as adding opponents to the matchup, cancelling the matchup etc.
        
        self.isLoading = false
        
        guard let lucraMatchupId else {
            return self.matchups.append(.init(id: "1234", title: "Client only matchup", lucraMatchupId: nil))
        }
        
        self.matchups.append(.init(id: "1234", title: "Client matchup with Lucra wager", lucraMatchupId: lucraMatchupId))
    }
}
