//
//  HugeText.swift
//  UI
//
//  Created by Carter Foughty on 2/5/25.
//

import SwiftUI

/// A `Text` view with the huge text `TypeStyle`.
public struct HugeText: View {
    
    // MARK: - API
    
    public init(_ text: String) {
        self.text = text
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    private let text: String
    
    // MARK: - Body
    
    public var body: some View {
        Text(text)
            .font(TypeStyle.huge)
    }
    
    // MARK: - Helpers
}

#Preview {
    HugeText("HUGE TEXT")
}
