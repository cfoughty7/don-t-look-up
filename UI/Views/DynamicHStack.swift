//
//  DynamicHStack.swift
//  don't look up
//
//  Created by Carter Foughty on 2/5/25.
//

import SwiftUI

/// An `HStack` that will automatically display content vertically if horizontal space constraints apply.
public struct DynamicHStack<Content: View>: View {
    
    // MARK: - API
    
    /// Creates an instance of a `DynamicHStack`
    /// - Parameter spacing: The spacing to use between views in the stack
    /// - Parameter content: The `ViewBuilder` to populate the stack, which can
    /// vary if the views are displaying vertically
    public init(
        spacing: CGFloat,
        @ViewBuilder content: @escaping (_ isVertical: Bool) -> Content
    ) {
        self.spacing = spacing
        self.content = content
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    private let spacing: CGFloat
    private let content: (_ isVertical: Bool) -> Content
    
    // MARK: - Body
    
    public var body: some View {
        ViewThatFits {
            // Prefer to display the content horizontally.
            HStack(spacing: spacing) {
                content(false)
            }
            
            // Fallback to a vertical layout.
            VStack(spacing: spacing) {
                content(true)
            }
        }
    }
    
    // MARK: - Helpers
}

#Preview {
    VStack(spacing: 100) {
        DynamicHStack(spacing: 10) { isVertical in
            Color.red.frame(width: 100, height: 100)
            Color.blue.frame(width: 100, height: 100)
        }
        .padding(10)
        .background(Color.gray.opacity(0.2))
        
        DynamicHStack(spacing: 10) { isVertical in
            Color.red.frame(width: 100, height: 100)
            Color.blue.frame(width: 100, height: 100)
        }
        .frame(width: 150)
        .padding(10)
        .background(Color.gray.opacity(0.2))
    }
}
