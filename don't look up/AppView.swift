//
//  AppView.swift
//  don't look up
//
//  Created by Carter Foughty on 1/31/25.
//

import SwiftUI

@main
struct AppView: App {

    var body: some Scene {
        WindowGroup {
            ObjectListView()
                // The app has a dark theme, so apply the scheme
                // so that system controls respect that.
                .colorScheme(.dark)
        }
    }
}
