//
//  SwiftUIExample.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 6/26/23.
//

import SwiftUI
import LucraSDK

struct SwiftUIExample: View {
    @EnvironmentObject var lucraClient: LucraClient

    @Environment(\.dismiss) private var dismiss
    @State private var currentLucraFlow: LucraFlow?
    @State private var homePagePopupPresented: Bool = false
    @State private var createGamesPopupPresented: Bool = false
    @State private var tournamentDetailsPopupPresented: Bool = false
    @State private var miniGamesMatchupDetailsPopupPresented: Bool = false

    // MARK: - Flow initializer parameters

    @State private var homePageLocation: String = ""
    @State private var createGamesGameId: String = ""
    @State private var tournamentDetailsMatchupId: String = ""
    @State private var miniGamesMatchupDetailsId: String = ""

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                // Profile
                button(title: LucraFlow.profile.displayName) {
                    initLucraFlow(.profile)
                }

                // Home Page
                button(title: LucraFlow.homePage(location: nil).displayName) {
                    homePagePopupPresented = true
                }

                // MiniGames Home
                button(title: LucraFlow.miniGamesHome.displayName) {
                    initLucraFlow(.miniGamesHome)
                }

                // MiniGames Profile
                button(title: LucraFlow.miniGamesProfile.displayName) {
                    initLucraFlow(.miniGamesProfile)
                }

                // MiniGames Rewards
                button(title: LucraFlow.miniGamesRewards.displayName) {
                    initLucraFlow(.miniGamesRewards)
                }

                // MiniGames Matchup Details
                button(title: LucraFlow.miniGamesMatchupDetails(matchupId: "").displayName) {
                    miniGamesMatchupDetailsPopupPresented = true
                }

                // Wallet
                button(title: LucraFlow.wallet.displayName) {
                    initLucraFlow(.wallet)
                }

                // Verify Identity
                button(title: LucraFlow.verifyIdentity.displayName) {
                    initLucraFlow(.verifyIdentity)
                }

                // Demographic Collection
                button(title: LucraFlow.demographicCollection.displayName) {
                    initLucraFlow(.demographicCollection)
                }

                // Create Games Matchup
                button(title: LucraFlow.createGamesMatchup(gameId: nil, location: nil).displayName) {
                    createGamesPopupPresented = true
                }

                // Create Sports Matchup
                button(title: LucraFlow.createSportsMatchup.displayName) {
                    initLucraFlow(.createSportsMatchup)
                }

                // Add Funds
                button(title: LucraFlow.addFunds.displayName) {
                    initLucraFlow(.addFunds)
                }

                // Withdraw Funds
                button(title: LucraFlow.withdrawFunds.displayName) {
                    initLucraFlow(.withdrawFunds)
                }

                // Public Feed
                button(title: LucraFlow.publicFeed.displayName) {
                    initLucraFlow(.publicFeed)
                }

                // My Matchups
                button(title: LucraFlow.myMatchups.displayName) {
                    initLucraFlow(.myMatchups)
                }

                // Tournament Details
                button(title: LucraFlow.tournamentDetails(matchupId: "").displayName) {
                    tournamentDetailsPopupPresented = true
                }

                // Onboarding
                button(title: LucraFlow.onboarding.displayName) {
                    initLucraFlow(.onboarding)
                }

                // Achievements
                button(title: LucraFlow.achievements.displayName) {
                    initLucraFlow(.achievements)
                }
            }
            .padding()
        }
        .alert("Enter location ID", isPresented: $homePagePopupPresented) {
            TextField("Location", text: $homePageLocation)

            Button("Continue") {
                initLucraFlow(.homePage(location: homePageLocation))
            }

            Button("Dismiss", role: .cancel) {
                clearInputFields()
            }
        }
        .alert("Enter Game ID", isPresented: $createGamesPopupPresented) {
            TextField("Game ID", text: $createGamesGameId)

            Button("Continue") {
                initLucraFlow(.createGamesMatchup(gameId: createGamesGameId,
                                                  location: nil))
            }

            Button("Dismiss", role: .cancel) {
                clearInputFields()
            }
        }
        .alert("Enter Tournament ID", isPresented: $tournamentDetailsPopupPresented) {
            TextField("Tournament ID", text: $tournamentDetailsMatchupId)

            Button("Continue") {
                initLucraFlow(.tournamentDetails(matchupId: tournamentDetailsMatchupId))
            }

            Button("Dismiss", role: .cancel) {
                clearInputFields()
            }
        }
        .alert("Enter Matchup ID", isPresented: $miniGamesMatchupDetailsPopupPresented) {
            TextField("Matchup ID", text: $miniGamesMatchupDetailsId)

            Button("Continue") {
                initLucraFlow(.miniGamesMatchupDetails(matchupId: miniGamesMatchupDetailsId))
            }

            Button("Dismiss", role: .cancel) {
                clearInputFields()
            }
        }
        .navigationBarTitle("SwiftUI Example")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    currentLucraFlow = .profile
                } label: {
                    Text("⚡️ \((lucraClient.user?.balance ?? 0.0).money)")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color.blue)
                .cornerRadius(.infinity, corners: .allCorners)
            }
        })
        .lucraFlow($currentLucraFlow, client: lucraClient)
    }

    private func button(title: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .bold()
                .foregroundColor(.white)
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 15)
        .background(Color.blue)
        .cornerRadius(24, corners: .allCorners)
    }

    private func initLucraFlow(_ flow: LucraFlow) {
        currentLucraFlow = flow
        clearInputFields()
    }

    private func clearInputFields() {
        homePageLocation = ""
        createGamesGameId = ""
        tournamentDetailsMatchupId = ""
        miniGamesMatchupDetailsId = ""
    }
}
