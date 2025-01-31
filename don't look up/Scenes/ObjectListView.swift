//
//  ObjectListView.swift
//  don't look up
//
//  Created by Carter Foughty on 1/31/25.
//

import SwiftUI

struct ObjectListView: View {
    
    // MARK: - API
    
    // MARK: - Constants
    
    private let mockData = [
        "Asteroid 1", "Asteroid 2", "Asteroid 3", "Asteroid 4", "Asteroid 5"
    ]
    
    // MARK: - Variables
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(mockData, id: \.self) { asteroid in
                Text(asteroid)
            }
        }
    }

    // MARK: - Helpers
    
}

#Preview {
    ObjectListView()
}
