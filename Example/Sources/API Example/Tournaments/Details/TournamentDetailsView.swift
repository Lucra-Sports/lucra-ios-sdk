//
//  TournamentDetailsView.swift
//  SDK Sample
//
//  Created by Wellison Pereira on 12/20/24.
//

import LucraSDK
import SwiftUI

struct TournamentDetailsView: View {

    @StateObject var viewModel: TournamentDetailsViewModel
    @State private var joinCode: String = ""

    init(lucraClient: LucraClient, matchupId: String) {
        self._viewModel = .init(wrappedValue: TournamentDetailsViewModel(lucraClient: lucraClient, matchupId: matchupId))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let error = viewModel.errorDetails {
                    Text(error)
                        .foregroundColor(.onBackground)
                        .lucraFont(.h8)
                }

                if viewModel.isLoading && viewModel.tournament == nil {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else if viewModel.tournament != nil {
                    tournamentDetails

                    joinTournament

                    payoutStructure

                    leaderboard

                    howToPlay
                }
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity)
        .background(Color.background)
        .onAppear {
            guard viewModel.tournament == nil else { return }
            viewModel.loadTournament()
        }
    }

    @ViewBuilder
    private var tournamentDetails: some View {
        if let tournament = viewModel.tournament {
            ContentSummaryContainer(sectionText: "", content: {
                Color.surface
                    .frame(height: 225)
                    .cornerRadius(10)
                    .overlay(
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(spacing: 6) {
                                    if tournament.isPrivate {
                                        Image(systemName: "lock.fill")
                                            .foregroundColor(.onSurface)
                                            .font(.caption)
                                    }

                                    Text(tournament.title)
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.onSurface)
                                        .lucraFont(.h2)
                                }

                                HStack {
                                    HStack(spacing: 4) {
                                        Image("expiration_time")
                                            .foregroundColor(.onSurface)
                                            .frame(width: 12, height: 12)

                                        Text(viewModel.timerDetail)
                                            .foregroundColor(.onSurface)
                                            .lucraFont(.h8)
                                    }
                                    .padding(.trailing, 8)

                                    HStack(spacing: 4) {
                                        Image("participants")
                                            .foregroundColor(.onSurface)
                                            .frame(width: 18, height: 18)

                                        Text(viewModel.participantsDetail)
                                            .foregroundColor(.onSurface)
                                            .lucraFont(.h8)
                                    }
                                }

                                Text(viewModel.buyInDetail)
                                    .foregroundColor(.onSurface)
                                    .lucraFont(.h8)
                            }

                            Spacer()

                            LucraAsyncImage(tournament.imageUrl, resize: .aspectFit) {
                                Image("tournament_placeholder")
                                    .resizable()
                                    .frame(width: 80, height: 80, alignment: .center)
                                    .aspectRatio(contentMode: .fit)
                                    .colorMultiply(.onSurface)
                            }
                            .frame(width: 80, height: 80, alignment: .center)
                            .aspectRatio(contentMode: .fit)
                        }
                        .padding(.horizontal)
                    )
            })
        }
    }

    @ViewBuilder
    private var joinTournament: some View {
        if viewModel.canJoin {
            VStack(alignment: .leading, spacing: 8) {
                if viewModel.requiresJoinCode {
                    TextField("Join Code", text: $joinCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                Button("Join Tournament") {
                    viewModel.joinTournament(joinCode: viewModel.requiresJoinCode ? joinCode : nil)
                }
                .lucraButtonStyle(.primary)
                .disabled(viewModel.joinTournamentTask != nil)
            }
        }
    }

    @ViewBuilder
    private var payoutStructure: some View {
        if let payout = viewModel.tournament?.payoutStructure, !payout.noPayout {
            section(title: payout.title) {
                if let jackpot = payout.jackpotAmount {
                    detailRow(payout.jackpotDescriptor ?? "Total Payout", jackpot)
                }

                ForEach(Array(payout.rewards.enumerated()), id: \.offset) { _, reward in
                    detailRow(reward.placeLabel ?? reward.positionLabel ?? "",
                              payout.showAmount ? (reward.amountLabel ?? reward.rewardLabel ?? "") : (reward.rewardLabel ?? ""))
                }
            }
        }
    }

    @ViewBuilder
    private var leaderboard: some View {
        if let leaderboard = viewModel.tournament?.leaderboard, !leaderboard.rows.isEmpty {
            section(title: "Leaderboard (\(leaderboard.pagination.totalCount))") {
                ForEach(leaderboard.rows) { row in
                    detailRow("\(row.rank ?? 0). \(row.name)", row.points ?? row.payout ?? "")
                }
            }
        }
    }

    @ViewBuilder
    private var howToPlay: some View {
        if let steps = viewModel.tournament?.howToPlay, !steps.isEmpty {
            section(title: "How To Play") {
                ForEach(steps, id: \.step) { step in
                    detailRow("\(step.step).", step.text)
                }
            }
        }
    }

    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.onBackground)
                .lucraFont(.h6)

            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.surface)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private func detailRow(_ leading: String, _ trailing: String) -> some View {
        HStack(alignment: .top) {
            Text(leading)
                .foregroundColor(.onSurface)
                .lucraFont(.h8)

            Spacer()

            Text(trailing)
                .multilineTextAlignment(.trailing)
                .foregroundColor(.onSurface)
                .lucraFont(.h8)
        }
    }

}
