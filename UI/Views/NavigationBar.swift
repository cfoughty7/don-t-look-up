//
//  NavigationBar.swift
//  UI
//
//  Created by Carter Foughty on 2/6/25.
//

import SwiftUI

/// A custom navigation bar view which mimics the default navigation bar behavior in iOS.
/// This is useful in cases where the navigation bar content should have dynamic height.
struct NavigationBar<Content: View>: View {
    
    // MARK: - API
    
    /// Creates an instance of a `NavigationBar`
    ///
    /// - Parameter displayBackground: Indicates whether the bar background should be visible
    /// - Parameter cornerRadius: The top corner radius of the navigation bar, if any. This is a mildly
    /// clumsy workaround for not being able to clip the scroll content to automatically adopt relevant corner
    /// radii due to the loss of scroll content in the safe area. While a slightly contrived solution, it works for our simple purpose.
    /// - Parameter content: The content to show in the scroll view with a parameter indicating whether
    /// the background is visible.
    init(
        displayBackground: Bool,
        cornerRadius: CGFloat? = nil,
        content: @escaping (_ isBackgroundVisible: Bool) -> Content
    ) {
        self.displayBackground = displayBackground
        self.cornerRadius = cornerRadius
        self.content = content
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    private let displayBackground: Bool
    private let cornerRadius: CGFloat?
    private let content: (_ isBackgroundVisible: Bool) -> Content
    
    // MARK: - Body
    
    public var body: some View {
        if let cornerRadius {
            navigationBar
                .clipShape(UnevenRoundedRectangle(
                    topLeadingRadius: cornerRadius,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: cornerRadius,
                    style: .continuous
                ))
        } else {
            navigationBar
        }
    }

    // MARK: - Helpers
    
    private var navigationBar: some View {
        content(displayBackground)
            .frame(maxWidth: .infinity)
            .background {
                if displayBackground {
                    VStack(spacing: 0) {
                        Rectangle()
                            .fill(Material.thin)
                            .ignoresSafeArea(edges: .top)
                            .transition(.opacity)
                        Divider().frame(height: 1)
                            .overlay(Color.white.opacity(0.05))
                    }
                }
            }
            .animation(.snappy(duration: 0.2), value: displayBackground)
            .zIndex(10)
    }
}

#Preview {
    ZStack(alignment: .top) {
        NavigationBar(displayBackground: true) { _ in
            Text("Nav Bar")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
        }
        
        Color.mineral
            .frame(height: 200)
    }
}
