//
//  APIError.swift
//  don't look up
//
//  Created by Carter Foughty on 2/1/25.
//

import Core

/// A simplified list of errors for any `APIRequest`
public enum APIError: AppError, Equatable {
    
    /// A fallback for errors that weren't anticipated
    case unexpected(String)

    /// The request returned a 401
    case unauthorized
    
    /// The request couldn't be sent because the device is offline
    case offline
    
    /// Error data to present to the user
    public var uiError: UIError {
        switch self {
        case .unexpected: UIError.default
        case .unauthorized: UIError.default
        case .offline:
            UIError(
                symbol: .wifiSlash,
                title: "Offline",
                message: "Try again when you device is online."
            )
        }
    }
}
