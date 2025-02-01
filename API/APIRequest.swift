//
//  APIRequest.swift
//  API
//
//  Created by Carter Foughty on 1/31/25.
//

import Foundation

/// An interface for a `URLRequest`, providing a method to decode the generic `Result` type
public protocol APIRequest<Result>: Sendable {
    
    /// The type of data being requested
    associatedtype Result
    
    /// The `URLRequest` to send to fetch the expected `Result`
    var urlRequest: URLRequest { get }
    
    /// Decodes the response `Data` into the expected `Value` result type
    func decodeValue(data: Data) throws -> Result
}

public extension APIRequest where Result: Decodable {
    
    /// Default decoding implementation for `Result` types that conform to `Decodable`
    func decodeValue(data: Data) throws -> Result {
        try JSONDecoder.standard.decode(Result.self, from: data)
    }
}
