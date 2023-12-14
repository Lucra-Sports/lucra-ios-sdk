//
//  ConfigureUserView.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 12/11/23.
//

import SwiftUI
import LucraSDK

struct ConfigureUserView: View {
    @ObservedObject var lucraClient: LucraClient
    
    @State var username: String
    @State var avatarURL: String
    @State var phoneNumber: String
    @State var email: String
    @State var firstName: String
    @State var lastName: String
    @State var address: String
    @State var addressCont: String
    @State var city: String
    @State var state: String
    @State var zip: String


    init(lucraClient: LucraClient) {
        self._lucraClient = .init(initialValue: lucraClient)
        self._username = .init(initialValue: lucraClient.user?.username ?? "")
        self._avatarURL = .init(initialValue: lucraClient.user?.avatarURL ?? "")
        self._phoneNumber = .init(initialValue: lucraClient.user?.phoneNumber ?? "")
        self._email = .init(initialValue: lucraClient.user?.email ?? "")
        self._firstName = .init(initialValue: lucraClient.user?.firstName ?? "")
        self._lastName = .init(initialValue: lucraClient.user?.lastName ?? "")
        self._address = .init(initialValue: lucraClient.user?.address?.address ?? "")
        self._addressCont = .init(initialValue: lucraClient.user?.address?.addressCont ?? "")
        self._city = .init(initialValue: lucraClient.user?.address?.city ?? "")
        self._state = .init(initialValue: lucraClient.user?.address?.state ?? "")
        self._zip = .init(initialValue: lucraClient.user?.address?.zip ?? "")

    }

    var body: some View {
        ScrollView {
            VStack {
                Text("Values will be passed in to the SDK `configure(user:)` function.")
                    .padding()
                TextField("Username", text: $username)
                TextField("Avatar URL", text: $avatarURL)
                TextField("Phone", text: $phoneNumber)
                TextField("Email", text: $email)
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
                TextField("Address", text: $address)
                TextField("Address Continued", text: $addressCont)
                TextField("City", text: $city)
                TextField("State", text: $state)
                TextField("Zip", text: $zip)
                
                Button("Submit") {
                    lucraClient.configure(user: .init(username: username,
                                                      avatarURL: avatarURL,
                                                      phoneNumber: phoneNumber,
                                                      email: email,
                                                      firstName: firstName,
                                                      lastName: lastName,
                                                      address: .init(address: address,
                                                                     addressCont: addressCont,
                                                                     city: city,
                                                                     state: state,
                                                                     zip: zip)))
                }
                .padding()
            }
            .padding()
            .textFieldStyle(.roundedBorder)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
