//
//  Color+Extensions.swift
//  don't look up
//
//  Created by Carter Foughty on 2/6/25.
//

import SwiftUI

extension Color {
    
    /// Provides a mixed `Color` from `readout` to `impact`, driven by the provided `value`.
    /// If the value is less than 0.5, `readout` is mixed with `warning`. If the value is greater than
    /// or equal to 0.5, `warning` is mixed with `impact`.
    /// - Parameter value: A color mix value ranging from 0 to 1
    static func risk(value: Double) -> Color {
        if value < 0.5 {
            // If the position is less than 0.5, mix `readout` with `warning`
            return Color.readout
                .mix(with: Color.warning, by: value / 0.5)
        } else {
            // If the position is greater than or equal to 0.5, mix `warning` with `impact`
            return Color.warning
                .mix(with: Color.impact, by: (value - 0.5) / 0.5)
        }
    }
}
