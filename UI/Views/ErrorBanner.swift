//
//  ErrorBanner.swift
//  UI
//
//  Created by Carter Foughty on 2/6/25.
//

import SwiftUI
import Core

/// An error view displaying data from a `UIError` that should be presented
/// from the top of the screen.
struct ErrorBanner: View {
    
    // MARK: - API
    
    /// Creates an instance of an `ErrorBanner`
    /// - Parameter uiError: Provides the data to display to the user
    public init(_ uiError: UIError) {
        self.uiError = uiError
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    private let uiError: UIError
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Image(symbol: uiError.symbol)
                    .font(.title3)
                TitleText(uiError.title)
                    .fontWeight(.semibold)
                    .padding(.top, 2)
            }
            
            BodyText(uiError.message)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
        .foregroundStyle(Color.readout)
        .padding(18)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.mineral)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
        }
    }
    
    // MARK: - Helpers
}

#Preview {
    VStack {
        ErrorBanner(UIError.default)
            .padding(20)
        Spacer()
    }
    .background {
        Color.cosmos
            .ignoresSafeArea()
    }
}
