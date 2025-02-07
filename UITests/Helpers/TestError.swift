//
//  TestError.swift
//  don't look up
//
//  Created by Carter Foughty on 2/7/25.
//

import Core

enum TestError: AppError, Hashable {
    case test
    case test2
    
    var uiError: UIError {
        UIError.default
    }
}
