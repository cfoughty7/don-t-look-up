//
//  MockError.swift
//  don't look upTests
//
//  Created by Carter Foughty on 2/7/25.
//

import Core

/// A mock `Error` type that can be used for testing.
enum MockError: AppError, Hashable {
    case error
    case error2
    
    var uiError: UIError {
        UIError.default
    }
}
