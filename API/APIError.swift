//
//  APIError.swift
//  don't look up
//
//  Created by Carter Foughty on 2/1/25.
//

import Foundation

/// A simplified list of errors for any `APIRequest`
public enum APIError: Error, Equatable {
    
    /// A fallback for errors that weren't anticipated
    case unexpected(String)

    /// The request returned a 401
    case unauthorized
    
    /// The request couldn't be sent because the device is offline
    case offline
}
