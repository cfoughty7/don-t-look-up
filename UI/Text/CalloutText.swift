//
//  CalloutText.swift
//  UI
//
//  Created by Carter Foughty on 2/4/25.
//

import SwiftUI

/// A `Text` view with the callout text `TypeStyle`.
public struct CalloutText: View {
    
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
            .font(TypeStyle.callout)
    }
    
    // MARK: - Helpers
}
