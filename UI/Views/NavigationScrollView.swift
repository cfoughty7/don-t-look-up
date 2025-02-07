//
//  NavigationScrollView.swift
//  UI
//
//  Created by Carter Foughty on 2/6/25.
//

import SwiftUI

/// A `ScrollView` with a `NavigationBar` view baked in. This view observes the scroll position
/// and automatically displays or hides the `NavigationBar` background as needed.
public struct NavigationScrollView<NavigationBarContent: View, Content: View>: View {
    
    // MARK: - API
    
    /// Creates an instance of a `NavigationScrollView`
    ///
    /// - Parameter cornerRadius: The top corner radius of the navigation bar, if any. This is a mildly
    /// clumsy workaround for not being able to clip the scroll content to automatically adopt relevant corner
    /// radii due to the loss of scroll content in the safe area. While a slightly contrived solution, it works for our simple purpose.
    /// - Parameter navBarContent: The view to display in the navigation bar.
    /// - Parameter content: The scroll view content.
    public init(
        navBarCornerRadius: CGFloat? = nil,
        navBarContent: @escaping (_ isBackgroundVisible: Bool) -> NavigationBarContent,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.navBarCornerRadius = navBarCornerRadius
        self.navBarContent = navBarContent
        self.content = content
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    @State private var isNavBarBackgroundVisible = false
    
    private let navBarCornerRadius: CGFloat?
    private let navBarContent: (_ isBackgroundVisible: Bool) -> NavigationBarContent
    private let content: () -> Content
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 0) {
            NavigationBar(displayBackground: isNavBarBackgroundVisible, cornerRadius: navBarCornerRadius) { isBackgroundVisible in
                navBarContent(isBackgroundVisible)
            }
            
            ScrollView {
                content()
            }
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y
            } action: { _, newValue in
                // Show the nav bar background if the scroll position is
                // greater than or equal to 10. This can be made configurable
                // if need be.
                isNavBarBackgroundVisible = newValue >= 10
            }
        }
    }

    // MARK: - Helpers
    
}

#Preview {
    NavigationScrollView { _ in
        Text("Nav Bar")
            .padding(.vertical, 16)
    } content: {
        VStack {
            Text("Scrollable content")
            Spacer()
        }
    }
    .background(Color.mineral.ignoresSafeArea())
}
