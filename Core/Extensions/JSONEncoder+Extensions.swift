//
//  JSONEncoder+Extensions.swift
//  Core
//
//  Created by Carter Foughty on 2/1/25.
//

import Foundation

public extension JSONEncoder {
    
    /// Provides an instance of a `JSONEncoder` with standard settings
    /// for the encoding strategies used for various data types.
    ///
    /// Standard settings include...
    ///   1. a key encoding strategy of `convertToSnakeCase`
    ///   2. a date format of `yyyy-MMM-dd HH:mm`
    static var standard: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }
}
