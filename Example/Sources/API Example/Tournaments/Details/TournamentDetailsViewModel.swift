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

    let matchupId: String

    @Published private(set) var tournament: TournamentUI?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorDetails: String?

    @Published private(set) var joinTournamentTask: Task<(), Never>?

    init(lucraClient: LucraClient, matchupId: String) {
        self.lucraClient = lucraClient
        self.matchupId = matchupId
    }

    public func loadTournament() {
        isLoading = true
        errorDetails = nil

        Task {
            defer { isLoading = false }

            let result = await lucraClient.api.retrieveTournamentDetails(for: matchupId)

            switch result {
            case .success(let tournament):
                self.tournament = tournament
            case .failure(let error):
                self.errorDetails = error.localizedDescription
            }
        }
    }

    public func joinTournament(joinCode: String? = nil) {
        joinTournamentTask = Task {
            defer { joinTournamentTask = nil }

            let result = await lucraClient.api.joinTournament(matchupId: matchupId,
                                                              joinCode: joinCode?.isEmpty == false ? joinCode : nil)

            switch result {
            case .success:
                loadTournament()
            case .failure(let error):
                self.errorDetails = error.localizedDescription
            }
        }
    }

}

// MARK: - Copy

extension TournamentDetailsViewModel {

    var tournamentTitle: String {
        (tournament?.title ?? "").uppercased()
    }

    var participantsDetail: String {
        guard let tournament else { return "" }

        let total = tournament.totalParticipants ?? 0

        guard let max = tournament.maxParticipants else {
            return "\(total) Participants"
        }

        return "\(total)/\(max) Participants"
    }

    var buyInDetail: String {
        guard let tournament else { return "" }

        if tournament.freeBuyIn {
            return "FREE ENTRY"
        }

        return tournament.buyInAmount?.moneyNoCents ?? ""
    }

    var timerDetail: String {
        tournament?.timer?.caption ?? tournament?.expiresAt?.short ?? ""
    }

    var canJoin: Bool {
        guard let tournament else { return false }
        return tournament.attemptData?.canJoinTournament == true
    }

    var requiresJoinCode: Bool {
        tournament?.isPrivate == true
    }

}
