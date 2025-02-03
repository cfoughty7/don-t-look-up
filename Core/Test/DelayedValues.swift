//
//  DelayedValues.swift
//  Core
//
//  Created by Carter Foughty on 2/3/25.
//

import Foundation

/// An asynchronous value provider that simulates delayed responses, returning values or errors with specified delays.
public actor DelayedValues<Value> {
    
    // MARK: - API
    
    /// An enum representing either a successful value or an error, each with an associated delay.
    public enum DelayedValue {
        /// A value that will be returned after the delay.
        case value(Value, delay: CGFloat)
        /// An error that will be thrown after the delay.
        case error(Error, delay: CGFloat)
        
        /// The delay (in seconds) before the value is returned or the error is thrown.
        var delay: CGFloat {
            switch self {
            case let .value(_, delay): delay
            case let .error(_, delay): delay
            }
        }
    }
    
    /// Creates an instance of `DelayedValues` with an ordered list of delayed values or errors.
    /// - Parameter values: An array of `DelayedValue` cases that will be sequenced as responses.
    public init(values: [DelayedValue]) {
        self.values = values
    }
    
    /// Returns the next value after applying its associated delay.
    public func next() async throws -> Value {
        guard let next = values.first else {
            fatalError("DelayedValues was created with an empty array of values.")
        }
        
        // If there is more than one value in the array, remove the one we are returning.
        // Leave the last value in the array and return it on subsequent requests.
        if values.count != 1 { values.removeFirst() }
        // Wait the delay period
        try await Task.sleep(for: .seconds(next.delay))
        
        switch next {
        case let .value(value, _): return value
        case let .error(error, _): throw error
        }
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    private var values: [DelayedValue]
    
    // MARK: - Helpers
}
