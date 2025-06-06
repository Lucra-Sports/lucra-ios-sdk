//
//  TournamentsLandingView.swift
//  LucraSDK
//
//  Created by Wellison Pereira on 12/19/24.
//

import LucraSDK
import SwiftUI

struct TournamentsLandingView: View {
	
	@StateObject var viewModel: TournamentsLandingViewModel
	@State private var searchID: String = "" // State for the entered ID
	@Environment(\.dismiss) private var dismiss
	
	init(lucraClient: LucraClient) {
		self._viewModel = .init(wrappedValue: TournamentsLandingViewModel(lucraClient: lucraClient))
	}
	
	var body: some View {
		VStack {
			// Search Section
			HStack {
				TextField("Tournament ID", text: $searchID)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.padding(.horizontal)
				
				Button("Search") {
					viewModel.loadTournaments(with: searchID.isEmpty ? nil : searchID)
				}
				.lucraButtonStyle(.secondary)
				.disabled(viewModel.isLoading || searchID.isEmpty)
				.padding(.trailing)
			}
			.padding(.top)
			
			// Tournament List
			ScrollView {
				if viewModel.tournaments.isEmpty {
					if let error = viewModel.errorDetails {
						Text(error)
							.lucraFont(.h8)
							.padding(.bottom, 8)
					}
					
					Button(viewModel.isLoading ? "Fetching List Of Tournaments" : "Get Tournaments") {
						viewModel.loadTournaments()
					}
					.disabled(viewModel.isLoading)
					.lucraButtonStyle(.secondary)
					.padding()
				} else {
					if let error = viewModel.errorDetails {
						Text(error)
							.lucraFont(.h8)
							.padding(.bottom, 8)
					}
					
					ForEach(viewModel.tournaments) { tournament in
						VStack(alignment: .leading, spacing: 8) {
							TournamentCard(tournament: tournament)
							
							if viewModel.isUserInTournament(tournament: tournament) {
								NavigationLink(destination: TournamentDetailsView(lucraClient: viewModel.lucraClient, tournament: tournament)) {
									Text("View Tournament")
										.lucraFont(.h8)
								}
								.lucraButtonStyle(.primary)
							}
							
							if !viewModel.isUserInTournament(tournament: tournament) {
								Button("Join Tournament") {
									viewModel.joinTournament(tournament: tournament)
								}
								.lucraButtonStyle(.secondary)
								.disabled(viewModel.joinTournamentTask != nil)
							}
						}
						.frame(maxWidth: .infinity, alignment: .leading)
						.foregroundStyle(Color.background)
						.lucraButtonStyle(.secondary)
						.padding()
					}
				}
			}
			.disabled(viewModel.isLoading)
			.background(Color.background)
		}
	}
}

fileprivate struct TournamentCard: View {
    
    @State var tournament: TournamentsMatchup
    
    var body: some View {
        tournamentCard
    }
    
    var tournamentCard: some View {
        ContentSummaryContainer(sectionText: "", content: {
			Color.surface
                .frame(height: 225)
                .cornerRadius(10)
                .overlay(
                    VStack {
                        tournamentDetails
                        HStack(alignment: .center, spacing: 8) {
                            tournamentSubCard(title: "ENTRY FEE", detail: tournament.fee.moneyNoCents, image: "entry_fee")
                            tournamentSubCard(title: "POT TOTAL", detail: tournament.potTotal.moneyNoCents, image: "pot_total")
                            tournamentSubCard(title: "YOU WON", detail: "", image: "winner_total", enabled: false) //TODO: - Map this properly
                        }
                    }
                )
        })
    }
    
    var tournamentDetails: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(tournament.title)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.onSurface)
                    .lucraFont(.h2)
                
                HStack {
                    HStack(spacing: 4) {
                        Image("expiration_time")
                            .foregroundColor(.onSurface)
                            .frame(width: 12, height: 12)
                        
                        Text(tournament.expiresAt?.short ?? "")
                            .foregroundColor(.onSurface)
                            .lucraFont(.h8)
                    }
                    .padding(.trailing, 8)
                    
                    HStack(spacing: 4) {
                        Image("participants")
                            .foregroundColor(.onSurface)
                            .frame(width: 18, height: 18)
                        
                        Text("\(tournament.participants.count) Participants")
                            .foregroundColor(.onSurface)
                            .lucraFont(.h8)
                    }
                }
            }
            
            Spacer()
            
            LucraAsyncImage(tournament.iconUrl, resize: .aspectFit) {
                Image("tournament_placeholder")
                    .resizable()
                    .frame(width: 80, height: 80, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .colorMultiply(.onSurface)
            }
            .frame(width: 80, height: 80, alignment: .center)
            .aspectRatio(contentMode: .fit)
        }
        .frame(height: 120)
        .padding(.horizontal)
    }
    
    func tournamentSubCard(title: String, detail: String, image: String, enabled: Bool = true) -> some View {
        Color.onSurface
            .opacity(0.1)
            .frame(width: 100, height: 50)
            .cornerRadius(10)
            .overlay {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .foregroundColor(.onSurface)
                        .opacity(0.5)
                        .lucraFont(.h8)

                    HStack(alignment: .center) {
                        Text(detail)
                            .foregroundColor(.onSurface)
                            .lucraFont(.h6)

                        Image(image)
                            .frame(width: 15, height: 15)
                            .offset(x: 20, y: 2)
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .opacity(enabled ? 1 : 0)
    }
    
}
