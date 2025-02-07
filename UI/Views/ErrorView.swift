//
//  ErrorView.swift
//  UI
//
//  Created by Carter Foughty on 2/6/25.
//

import SwiftUI
import Core

/// An error view displaying data from a `UIError` and providing a retry button.
public struct ErrorView: View {
    
    // MARK: - API
    
    /// Creates an instance of an `ErrorView`
    /// - Parameter uiError: Provides the data to display to the user
    /// - Parameter onRetry: The function to perform when retry is tapped
    public init(_ uiError: UIError, onRetry: @escaping () -> Void) {
        self.uiError = uiError
        self.onRetry = onRetry
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    private let uiError: UIError
    private let onRetry: () -> Void
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Image(symbol: uiError.symbol)
                        .font(.title3)
                    TitleText(uiError.title)
                        .fontWeight(.semibold)
                        .padding(.top, 2)
                }
                
                BodyText(uiError.message)
            }
            
            PrimaryButton("RETRY", action: onRetry)
        }
        .foregroundStyle(Color.readout)
    }
    
    // MARK: - Helpers
}
