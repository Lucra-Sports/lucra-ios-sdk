//
//  MiniGamesView.swift
//  LucraSDK
//
//  Created by Wellison Pereira on 7/15/26.
//

import LucraSDK
import SwiftUI

struct MiniGamesView: View {

    @StateObject var viewModel: MiniGamesViewModel
    @State private var currentLucraFlow: LucraFlow?

    init(lucraClient: LucraClient) {
        self._viewModel = .init(wrappedValue: MiniGamesViewModel(lucraClient: lucraClient))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                flows

                recentMatchups
            }
            .padding()
        }
        .navigationBarTitle("Mini Games")
        .lucraFlow($currentLucraFlow, client: viewModel.lucraClient)
        .onAppear {
            viewModel.loadMatchups()
        }
    }

    // Full screen Mini Games flows presented via the `.lucraFlow` modifier.
    private var flows: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Flows")
                .lucraFont(.h6)

            Button("Mini Games Home") {
                currentLucraFlow = .miniGamesHome
            }
            .lucraButtonStyle(.primary)

            Button("Mini Games Profile") {
                currentLucraFlow = .miniGamesProfile
            }
            .lucraButtonStyle(.secondary)
        }
    }

    // Recent matchups fetched headlessly via `fetchUserProfileMatchups(limit:)`.
    // Tapping a matchup presents its details with `.miniGamesMatchupDetails(matchupId:)`.
    @ViewBuilder
    private var recentMatchups: some View {
        HStack {
            Text("Recent Matchups")
                .lucraFont(.h6)

            Spacer()

            if viewModel.isLoading {
                ProgressView()
            } else {
                Button("Refresh") {
                    viewModel.loadMatchups()
                }
                .lucraButtonStyle(.secondary)
            }
        }

        if let error = viewModel.errorDetails {
            Text(error)
                .lucraFont(.h8)
        } else if !viewModel.isLoading && viewModel.inProgress.isEmpty && viewModel.completed.isEmpty {
            Text("No matchups yet. Play a mini game to get started.")
                .lucraFont(.h8)
        }

        if !viewModel.inProgress.isEmpty {
            MatchupSection(title: "In Progress", items: viewModel.inProgress) { item in
                currentLucraFlow = .miniGamesMatchupDetails(matchupId: item.id)
            }
        }

        if !viewModel.completed.isEmpty {
            MatchupSection(title: "Completed", items: viewModel.completed) { item in
                currentLucraFlow = .miniGamesMatchupDetails(matchupId: item.id)
            }
        }
    }
}

fileprivate struct MatchupSection: View {

    let title: String
    let items: [LucraUserProfileMatchupItem]
    let onTap: (LucraUserProfileMatchupItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .lucraFont(.h8)

            ForEach(items, id: \.id) { item in
                Button {
                    onTap(item)
                } label: {
                    MatchupRow(item: item)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

fileprivate struct MatchupRow: View {

    let item: LucraUserProfileMatchupItem

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .lucraFont(.h7)
                    .lineLimit(1)

                Text(subtitle)
                    .lucraFont(.h8)
                    .opacity(0.6)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
        }
        .padding()
        .background(Color.surface)
        .foregroundColor(.onSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var subtitle: String {
        switch item.status {
        case .result:
            if let outcome = item.outcome {
                return outcome.rawValue.capitalized
            }
            return "Completed"
        case .inProgress:
            return "In Progress"
        case .upcoming:
            return "Upcoming"
        case .pending:
            return "Pending"
        default:
            return ""
        }
    }
}
