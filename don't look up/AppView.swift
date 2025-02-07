//
//  AppView.swift
//  don't look up
//
//  Created by Carter Foughty on 1/31/25.
//

import SwiftUI

/// A `UserDefaults` key for a value indicating whether the user has onboarded.
let hasOnboardedKey = "hasOnboarded"

@main
struct AppView: App {
    
    /// A simple `UserDefaults` flag indicating whether the user has already onboarded
    @AppStorage(hasOnboardedKey) private var hasOnboarded = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if hasOnboarded {
                    ObjectListView()
                } else {
                    WelcomeView()
                }
            }
            .animation(.snappy, value: hasOnboarded)
            // The app has a dark theme, so apply the scheme
            // so that system controls respect that.
            .colorScheme(.dark)
        }
    }
}
