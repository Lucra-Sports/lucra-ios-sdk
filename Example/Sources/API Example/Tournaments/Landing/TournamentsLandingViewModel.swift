//
//  TournamentsLandingViewModel.swift
//  LucraSDK
//
//  Created by Wellison Pereira on 12/19/24.
//

import LucraSDK
import SwiftUI

public class TournamentsLandingViewModel: ObservableObject {
    
    @ObservedObject private(set) var lucraClient: LucraClient
    @Published private(set) var tournaments: [TournamentsMatchup]
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorDetails: String?
    
    @Published private(set) var joinTournamentTask: Task<(), Never>?
    
    init(lucraClient: LucraClient) {
        self.tournaments = []
        self.lucraClient = lucraClient
    }
    
	public func loadTournaments(with id: String? = nil) {
        isLoading = true
        errorDetails = nil
        
        Task {
            defer { isLoading = false }
            
            do {
				if let id = id {
					if let tournament = try await lucraClient.api.tournamentsMatchup(for: id) {
						self.tournaments = [tournament]
					}
					
				} else {
					self.tournaments = try await lucraClient.api.getRecommendedTournaments()
				}
            } catch {
                self.errorDetails = error.localizedDescription
                print(error.localizedDescription)
            }
            
        }
    }
    
    public func joinTournament(tournament: TournamentsMatchup) {
        joinTournamentTask = Task {
            defer { joinTournamentTask = nil }
            
            do {
                try await lucraClient.api.joinTournament(id: tournament.id)
                loadTournaments()
            } catch {
                self.errorDetails = error.localizedDescription
                print(error.localizedDescription)
            }
        }
    }
    
    public func isUserInTournament(tournament: TournamentsMatchup) -> Bool {
        guard let username = lucraClient.user?.username else { return false }
        return tournament.participants.contains(where: { $0.username == username })
    }
    
}
