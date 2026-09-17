//
//  Environment.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 8/28/23.
//

import Foundation
import LucraSDK

// In a real app these values should be passed in/stored via a secure method

// PRODUCTION
//#error("Please set your configuration below then delete this line.")
//let lucraAPIURL = "<YOUR PROD URL>"
//let lucraAPIKey = "<YOUR PROD KEY>"
//let lucraEnvironment: LucraEnvironment = .production
//let lucraURLScheme = "<YOUR URL SCHEME>"
//let lucraMerchantID = "<YOUR APPLE PAY MERCHANT ID>"

// SANDBOX
//#error("Please set your configuration below then delete this line.")
let lucraAPIKey = "5a98d144-50f8-48b0-955d-5ae94f21c6ae"
let lucraEnvironment: LucraEnvironment = .staging
let lucraURLScheme = "<YOUR URL SCHEME>"
let lucraMerchantID = "<YOUR APPLE PAY MERCHANT ID>"

