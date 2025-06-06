//
//  APIExampleSportsView.swift
//  SDK Sample
//
//  Created by Wellison Pereira on 5/2/24.
//

import SwiftUI
import LucraSDK

struct APIExampleSportsView: View {
    @StateObject private var viewModel: APIExampleSportsViewModel
    @State var contestId: String = ""
    
    init(lucraClient: LucraClient) {
        self._viewModel = .init(wrappedValue: APIExampleSportsViewModel(lucraClient: lucraClient))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Text("API Example Sports Matchup")
                    .lucraFont(.h2)
                TextField("Enter Matchup ID", text: $contestId)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .onSubmit {
                        viewModel.loadContest(contestId: contestId)
                    }
            }
            
            if let matchup = viewModel.matchup {
                VStack(alignment: .leading, spacing: 10) {
                    Text("**Full Lucra Info**")
                        .font(.title)
                    
                    Text("\(String(describing: try? matchup.toDictionary()))")
                }
                .id(contestId)
            } else {
                Text("Enter a Matchup ID")
            }
        }
    }
}

extension Encodable {
    /// Converting object to postable dictionary
    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
        let data = try encoder.encode(self)
        let object = try JSONSerialization.jsonObject(with: data)
        if let json = object as? [String: Any]  { return json }
        
        let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
        throw DecodingError.typeMismatch(type(of: object), context)
    }
}
