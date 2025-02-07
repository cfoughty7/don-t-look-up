//
//  Publisher+Extensions.swift
//  UITests
//
//  Created by Carter Foughty on 2/7/25.
//

import Combine

extension Publisher {
    
    /// Provides the first value output by a publisher by taking advantage
    /// of the `values` property which converts the `Publisher` into an `AsyncSequence`
    func firstValue() async throws -> Output? {
        for try await value in self.values {
            return value
        }
        // If no value is emitted, return nil
        return nil
    }
}
