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
    
    init(lucraClient: LucraClient, tournament: TournamentsMatchup) {
        self._viewModel = .init(wrappedValue: TournamentDetailsViewModel(lucraClient: lucraClient, tournament: tournament))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Section {
                    tournamentDetails
                }
                .padding(20)
            }
        }
        .background(Color.background)
    }
    
    var tournamentDetails: some View {
        ContentSummaryContainer(sectionText: "", content: {
            Color.surface
                .frame(height: 225)
                .cornerRadius(10)
                .overlay(
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text(viewModel.tournament.title)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.onSurface)
                                .lucraFont(.h2)
                            
                            HStack {
                                HStack(spacing: 4) {
                                    Image("expiration_time")
                                        .foregroundColor(.onSurface)
                                        .frame(width: 12, height: 12)
                                    
                                    Text(viewModel.tournament.expiresAt?.short ?? "")
                                        .foregroundColor(.onSurface)
                                        .lucraFont(.h8)
                                }
                                .padding(.trailing, 8)
                                
                                HStack(spacing: 4) {
                                    Image("participants")
                                        .foregroundColor(.onSurface)
                                        .frame(width: 18, height: 18)
                                    
                                    Text("\(viewModel.tournament.participants.count) Participants")
                                        .foregroundColor(.onSurface)
                                        .lucraFont(.h8)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        LucraAsyncImage(viewModel.tournament.iconUrl, resize: .aspectFit)
                            .frame(width: 80, height: 80, alignment: .center)
                            .aspectRatio(contentMode: .fit)
                    }
                )
        })
        
    }
    
}
