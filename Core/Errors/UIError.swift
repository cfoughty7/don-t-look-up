//
//  UIError.swift
//  don't look up
//
//  Created by Carter Foughty on 2/6/25.
//

import Foundation

/// Models error messages to be displayed in the UI
public struct UIError: Hashable, Identifiable {
    
    public var id: UUID = UUID()
    public var symbol: SFSymbol
    public var title: String
    public var message: String
    
    /// A default `UIError` which can be used when specific messages aren't needed
    public static var `default`: UIError {
        UIError(
            symbol: .exclamationmarkTriangle,
            message: "Something went wrong—please try again."
        )
    }
    
    /// Creates an instance of a `UIError`
    /// - Parameter symbol: A symbol that should be displayed alongside the error
    /// - Parameter title: The title or category of the error
    /// - Parameter message: A descriptive message about the error and what the user can do
    public init(symbol: SFSymbol, title: String = "ERROR", message: String) {
        self.symbol = symbol
        self.title = title
        self.message = message
    }
}
