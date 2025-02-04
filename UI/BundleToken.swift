//
//  BundleToken.swift
//  UI
//
//  Created by Carter Foughty on 2/4/25.
//

import Foundation

/// A utility class used to obtain a reference to the `Bundle` containing this class.
public final class BundleToken {
    
    /// The `Bundle` associated with the `BundleToken` class.
    static let bundle = Bundle(for: BundleToken.self)
}
