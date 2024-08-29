//
//  ConvertToCreditProvider.swift
//  SPMSample
//
//  Created by Wellison Pereira on 8/29/24.
//

import LucraSDK
import SwiftUI

/// A Sample View to manipulate the values of the provider in real time.
struct SampleC2CView: View {
    
    @EnvironmentObject private var lucraClient: LucraClient
    @ObservedObject var provider: ExampleC2CProvider
    
    @AppStorage("ConfigureC2CEnabled") private var enabled: Bool = true
    @State private var delayEnabled: Bool = false
    
    init(provider: ConvertToCreditProvider) {
        self.enabled = true
        self.provider = provider as! ExampleC2CProvider
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Toggle("Enable C2C", isOn: $enabled) { enabled in
                    self.enabled = enabled
                    lucraClient.registerConvertToCreditProvider(enabled ? provider : nil)
                }
                
                if enabled {
                    Text("The C2C Provider will update accordingly with the values listed here. \n ")
                    
                    VStack(alignment: .leading) {
                        Text("Title")
                            .lucraFont(.h6)
                        TextField("Title", text: $provider.title)
                            .autocorrectionDisabled()
                    }.padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        Text("Converted Amount")
                            .lucraFont(.h6)
                        
                        TextField("Converted Amount", value: $provider.convertedAmount, formatter: NumberFormatter.withDollarSymbol)
                            .disabled(true)
                    }.padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        Text("Converted Amount To Display")
                            .lucraFont(.h6)
                        TextField("Converted Amount To Display", text: $provider.convertedAmountDisplay)
                            .disabled(true)
                    }.padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        Text("Conversion Terms")
                            .lucraFont(.h6)
                        TextField("Conversion Terms", text: $provider.conversionTerms)
                            .autocorrectionDisabled()
                    }.padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        Text("Short Description")
                            .lucraFont(.h6)
                        TextField("Short Description", text: $provider.shortDescription)
                    }.padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        Text("Long Description")
                            .lucraFont(.h6)
                        TextField("Long Description", text: $provider.longDescription)
                    }.padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        Text("Icon")
                            .lucraFont(.h6)
                        TextField("Icon", text: $provider.icon)
                            .autocorrectionDisabled()
                    }.padding(.bottom)
                    
                    Toggle("Delay", isOn: $delayEnabled) { enabled in
                        self.delayEnabled = enabled
                        provider.delay = enabled
                    }
                }
            }
            .padding()
            .textFieldStyle(.roundedBorder)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// C2CProvider - Pass this into the LucraClient registerConvertToCreditProvider function.
class ExampleC2CProvider: ConvertToCreditProvider, ObservableObject {
    
    @Published var id: String = UUID().uuidString
    @Published var title: String = "Title"
    @Published var convertedAmount: Decimal = 10.00
    @Published var convertedAmountDisplay: String = "$10.00"
    @Published var shortDescription: String = "This is a short description."
    @Published var conversionTerms: String = "No Fee | Instant Transfer"
    @Published var longDescription: String = "You will receive an email confirming your credit and then it will be available to use!"
    @Published var icon: String = "coin"
    @Published var metadata: String = "{}"
    @Published var delay: Bool = false
    
    func withdrawMethod(for amount: Decimal) async -> LucraSDK.CreditWithdrawal {
        (self.convertedAmount, self.convertedAmountDisplay) = handleAmount(for: amount)
        
        // Generate a new ID on transaction so we don't get duplicate ID responses.
        id = UUID().uuidString
        
        let method = CreditWithdrawal(id: id,
                                      title: title,
                                      icon: icon,
                                      theme: CreditWithdrawal.Theme(),
                                      conversionTerms: conversionTerms,
                                      convertedAmount: convertedAmount,
                                      convertedDisplayAmount: convertedAmountDisplay,
                                      shortDescription: shortDescription,
                                      longDescription: longDescription,
                                      metadata: metadata)
        
        // An optional delay that
        if delay {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
        }
        
        return method
    }
    
    private func handleAmount(for amount: Decimal) -> (Decimal, String) {
        return (amount, "\(amount * 3) Credits")
    }
}
