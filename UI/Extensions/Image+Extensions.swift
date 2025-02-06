//
//  Image+Extensions.swift
//  UI
//
//  Created by Carter Foughty on 2/5/25.
//

import SwiftUI

public extension Image {
    
    /// Creates an `Image` based on the system name of an `SFSymbol`
    init(symbol: SFSymbol) {
        self = Image(systemName: symbol.rawValue)
    }
}
