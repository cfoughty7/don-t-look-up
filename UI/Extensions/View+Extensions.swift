//
//  View+Extensions.swift
//  UI
//
//  Created by Carter Foughty on 2/5/25.
//

import SwiftUI

public extension View {
    
    /// Observes changes to the size of the view and performs an action
    /// - Parameter action: The action to perform when the view size changes
    func onSizeChange(action: @escaping (CGSize) -> Void) -> some View {
        self.onGeometryChange(for: CGSize.self, of: { $0.size }, action: action)
    }
}
