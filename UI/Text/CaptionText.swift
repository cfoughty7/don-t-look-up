//
//  CaptionText.swift
//  don't look up
//
//  Created by Carter Foughty on 2/7/25.
//


import SwiftUI

/// A `Text` view with the caption text `TypeStyle`.
public struct CaptionText: View {
    
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
            .font(TypeStyle.caption)
    }
    
    // MARK: - Helpers
}

#Preview {
    CaptionText("CAPTION TEXT")
}
