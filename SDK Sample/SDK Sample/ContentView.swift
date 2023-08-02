//
//  ContentView.swift
//  SDK Sample
//
//  Created by Michael Schmidt on 6/5/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ExampleList()
            }
        } else {
            NavigationView {
                ExampleList()
            }
        }
    }
}

struct ExampleList: View {
    var body: some View {
        List {
            NavigationLink("SwiftUI Example") {
                SwiftUIExample()
            }
            NavigationLink("UIKit Example") {
                UIKitSampleViewControllerRepresentable()
            }
            NavigationLink("API Example") {
                APIExample()
            }
        }
        .navigationTitle("SDK Sample App")
    }
}

