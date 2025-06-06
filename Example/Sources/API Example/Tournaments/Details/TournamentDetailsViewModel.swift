//
//  TournamentDetailsViewModel.swift
//  SDK Sample
//
//  Created by Wellison Pereira on 12/20/24.
//

import LucraSDK
import SwiftUI

public class TournamentDetailsViewModel: ObservableObject {
    
    @ObservedObject var lucraClient: LucraClient
    @Published private(set) var tournament: TournamentsMatchup
    
    init(lucraClient: LucraClient, tournament: TournamentsMatchup) {
        self.lucraClient = lucraClient
        self.tournament = tournament
    }
    
}

// MARK: - Copy

extension TournamentDetailsViewModel {
    
    var tournamentTitle: String {
        tournament.title.uppercased()
    }
    
}
