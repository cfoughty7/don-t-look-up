//
//  NearEarthObject+Extensions.swift
//  don't look up
//
//  Created by Carter Foughty on 2/7/25.
//

import SwiftUI
import Service
import UI

extension NearEarthObject {
    
    /// The user-facing text description of a risk value
    var riskText: String {
        switch risk {
        case .low: "LOW"
        case .med: "MEDIUM"
        case .high: "HIGH"
        }
    }
    
    /// The user-facing color to associate with a risk color
    var riskColor: Color {
        switch risk {
        case .low: .readout
        case .med: .warning
        case .high: .impact
        }
    }
}
