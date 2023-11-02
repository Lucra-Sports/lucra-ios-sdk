//
//  APIExample.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 7/10/23.
//

import SwiftUI
import LucraSDK
//import Styleguide

struct ClientMatchup: Identifiable {
    let id: String
    let title: String
    let lucraMatchup: GYPCreatedMatchupOutput?
}

class APIExampleViewModel: ObservableObject {
    @Published var lucraClient = LucraClient(config: .init(environment: .init(authenticationClientID: lucraAPIKey,
                                                                              environment: lucraEnvironment,
                                                                                 urlScheme: lucraURLScheme)))
    
    @Published var flow: LucraFlow? = nil

    @Published var matchups: [ClientMatchup] = []
    @Published var isWager: Bool = false
    @Published var wagerAmount: Decimal = 1.0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func createMatchup() {
        self.errorMessage = nil
        self.isLoading = true
                
        if isWager {
            Task { @MainActor [weak self] in
                guard let self else { return }
                do {
                    let matchup = try await lucraClient.api.createGamesMatchup(gameTypeId: "DARTS", atStake: wagerAmount)
                    createClientMatchup(lucraMatchup: matchup)
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

        if let lucraMatchup = matchup.lucraMatchup {
            Task { @MainActor [weak self] in
                guard let self else { return }
                do {
                    try await lucraClient.api.cancelGamesMatchup(matchupId: lucraMatchup.matchupId)
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
        
    private func createClientMatchup(lucraMatchup: GYPCreatedMatchupOutput? = nil) {
        // MARK: - This is where the client app would create its matchup and store the Lucra matchup id for further interactions with the LucraSDK such as adding opponents to the matchup, cancelling the matchup etc.
        
        self.isLoading = false

        guard let lucraMatchup else {
            return self.matchups.append(.init(id: "1234", title: "Client only matchup", lucraMatchup: nil))
        }
        
        self.matchups.append(.init(id: "1234", title: "Client matchup with Lucra wager", lucraMatchup: lucraMatchup))
    }
}

struct APIExample: View {
    @StateObject private var viewModel = APIExampleViewModel()
    let formatter: NumberFormatter = {
           let formatter = NumberFormatter()
           formatter.numberStyle = .decimal
           return formatter
       }()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            if viewModel.matchups.isEmpty {
                Toggle("Make this a wager?", isOn: $viewModel.isWager)
                
                if viewModel.isWager {
                    DecimalTextField(amount: $viewModel.wagerAmount, colorScheme: .light)
                        .preferredColorScheme(.light)
                        .padding()
                }
                
                button(title: "Create Matchup") {
                    viewModel.createMatchup()
                }
            } else {
                ForEach(viewModel.matchups) { matchup in
                    VStack(alignment: .leading, spacing: 25) {
                        Text("**Client Info**")
                            .font(.title)
                        Text("**ID:** \(matchup.id)")
                        Text("**Title:** \(matchup.title)")
                        if let lucraMatchup = matchup.lucraMatchup{
                            Text("**Lucra Info**")
                                .font(.title)

                            Text("**Matchup ID:** \(lucraMatchup.matchupId)")
                            Text("**Team ID 1:** \(lucraMatchup.ownerTeamId)")
                            Text("**Team ID 2:** \(lucraMatchup.opponentTeamId)")

                        }
                        
                        button(title: "Cancel Matchup") {
                            viewModel.cancelMatchup(matchup: matchup)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
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
