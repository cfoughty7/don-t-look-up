//
//  BackButton.swift
//  UI
//
//  Created by Carter Foughty on 2/5/25.
//

import SwiftUI

/// A `Button` view that can be used specifically to go back in navigation contexts.
public struct BackButton: View {
    
    // MARK: - API
    
    /// Creates an instance of a `BackButton` which
    /// dismisses a view in the current navigation context.
    public init() {}
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    
    public var body: some View {
        Button {
            dismiss()
        } label: {
            Image(symbol: .chevronLeft)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.mineral)
                .frame(width: 26, height: 26)
        }
        .buttonStyle(BackButtonStyle())
    }
    
    // MARK: - Helpers
}

fileprivate struct BackButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                Circle()
                    .fill(Color.white.opacity(configuration.isPressed ? 0.2 : 0.6))
            }
    }
}

#Preview {
    ZStack {
        BackButton()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.mineral.ignoresSafeArea())
}
