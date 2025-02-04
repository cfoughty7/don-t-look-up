//
//  Color.swift
//  UI
//
//  Created by Carter Foughty on 2/3/25.
//

import SwiftUI

/// Makes our colors in the `Color` asset catalog publicly available. Unfortunately, the scope
/// of the auto-generated assets is not configurable, so we need to jump through this hoop.
public extension Color {
    
    static let cosmos = Color.cosmosInternal
    static let earth = Color.earthInternal
    static let home = Color.homeInternal
    static let impact = Color.impactInternal
    static let mineral = Color.mineralInternal
    static let readout = Color.readoutInternal
    static let warning = Color.warningInternal
}
