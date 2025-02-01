//
//  JSONDecoder+Extensions.swift
//  Core
//
//  Created by Carter Foughty on 2/1/25.
//

import Foundation

public extension JSONDecoder {
    
    /// Provides an instance of a `JSONDecoder` with standard settings
    /// for the decoding strategies used for various data types.
    ///
    /// Standard settings include...
    ///   1. a key decoding strategy of `convertFromSnakeCase`
    ///   2. a date format of `yyyy-MMM-dd HH:mm`
    static var standard: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}
