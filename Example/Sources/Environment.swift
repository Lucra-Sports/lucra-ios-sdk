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
//let lucraAPIKey = "<YOUR PROD KEY>"
//let lucraEnvironment: LucraEnvironment = .production
//let lucraURLScheme = "TODO:"

// SANDBOX
#warning("Default Sample App Key. Replace With your Sandbox key.")
let lucraAPIKey = "<your api key here>"
let lucraEnvironment: LucraEnvironment = .sandbox
let lucraURLScheme = "TODO:"
