//
//  APIExample.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 7/10/23.
//
import SwiftUI
import LucraSDK

struct APIExampleGamesView: View {
    @StateObject private var viewModel: APIExampleGamesViewModel
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    init(lucraClient: LucraClient) {
        self._viewModel = .init(wrappedValue: APIExampleGamesViewModel(lucraClient: lucraClient))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }
                
                if viewModel.matchups.isEmpty {
                    Toggle("Make this a wager?", isOn: $viewModel.isWager)
                        .padding()
                    
                    if viewModel.isWager {
                        DecimalTextField(amount: $viewModel.wagerAmount)
                            .preferredColorScheme(.light)
                            .padding()
                    }
                    
                    button(title: "Create Matchup") {
                        viewModel.createMatchup()
                    }
                } else {
                    ForEach(viewModel.matchups) { matchup in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("**Client Info**")
                                .font(.title)
                            Text("**ID:** \(matchup.id)")
                            Text("**Title:** \(matchup.title)")
                            if let lucraMatchupId = matchup.lucraMatchupId{
                                Text("**Lucra Info**")
                                    .font(.title)
                                
                                Text("**Matchup ID:** \(lucraMatchupId)")
                                
                                if let full = matchup.fullLucraMatchup {
                                    FullMatchupCard(matchup: full)
                                }
                                
                                button(title: "Load Full Matchup") {
                                    viewModel.loadMatchup(matchupId: lucraMatchupId)
                                }
                            }
                            
                            
                            button(title: "Cancel Matchup") {
                                viewModel.cancelMatchup(matchup: matchup)
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
        .minimumScaleFactor(0.5)
        .lucraFlow($viewModel.flow, client: viewModel.lucraClient)
    }
    
    private func button(title: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .bold()
                .foregroundColor(.white)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 15)
        .background(Color.blue)
        .cornerRadius(.infinity, corners: .allCorners)
    }
}


private struct FullMatchupCard: View {
    let matchup: LucraMatchup
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("**Full Lucra Info**")
                .font(.title)
            
            Text("\(String(describing: try? matchup.toDictionary()))")
            .padding(.vertical)
        }
    }
}
