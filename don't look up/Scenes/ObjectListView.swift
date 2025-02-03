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
    
    // MARK: - Variables
    
    @StateObject private var viewModel = ObjectListViewModel()
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            if viewModel.objects.isEmpty {
                Text("Loading...")
            } else {
                VStack(spacing: 10) {
                    ForEach(viewModel.objects, id: \.self) { asteroid in
                        Text(asteroid.name)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            await viewModel.appeared()
        }
    }

    // MARK: - Helpers
    
}

#Preview {
    ObjectListView()
}
