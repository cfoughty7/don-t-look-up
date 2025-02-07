//
//  PrimaryButton.swift
//  UI
//
//  Created by Carter Foughty on 2/6/25.
//

import SwiftUI
import Core

/// A `Button` view that can be used to emphasize important actions.
public struct PrimaryButton: View {
    
    // MARK: - API
    
    /// Creates an instance of a `PrimaryButton`.
    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    private let title: String
    private let action: () -> Void
    
    // MARK: - Body
    
    public var body: some View {
        Button {
            action()
        } label: {
            BodyText(title)
                .fontWeight(.semibold)
                .padding(.horizontal, 50)
                .padding(.top, 18)
                .padding(.bottom, 16)
        }
        .buttonStyle(PrimaryButtonStyle())
    }
    
    // MARK: - Helpers
}

fileprivate struct PrimaryButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.mineral.mix(with: .black, by: configuration.isPressed ? 0.2 : 0))
            }
    }
}

#Preview {
    ZStack {
        PrimaryButton("TAP ME") {}
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.cosmos.ignoresSafeArea())
}
