//
//  AppError.swift
//  don't look up
//
//  Created by Carter Foughty on 2/6/25.
//

import Foundation

/// An interface for errors that may be specifically managed and presented in the UI
public protocol AppError: Error {
    
    /// Error data to present to the user
    var uiError: UIError { get }
}
