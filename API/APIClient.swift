//
//  APIClient.swift
//  API
//
//  Created by Carter Foughty on 1/31/25.
//

import Foundation

public protocol APIClient: Actor {
    
    /// Sends the request and returns the response `Value`
    func send<Value>(_ request: any APIRequest<Value>) async throws -> Value
}

actor DefaultAPIClient: APIClient {
    
    // MARK: - API
    
    init() {}
    
    func send<Value>(_ request: any APIRequest<Value>) async throws -> Value {
        let urlRequest = request.urlRequest
        let session = URLSession(configuration: .default)
        
        do {
            // Perform the request
            guard let (data, response) = try await session.data(for: urlRequest) as? (Data, HTTPURLResponse) else {
                throw APIError.unexpected(
                    "The URLSession did not return valid data and response for request \(urlRequest.description)."
                )
            }
            
            switch response.statusCode {
            case 200..<300:
                // On a successful response, attempt to decode the result
                do {
                    return try request.decodeValue(data: data)
                } catch let error {
                    throw APIError.unexpected(
                        "Unable to decode response for request \(urlRequest.description): \(error.localizedDescription)"
                    )
                }
            case 401:
                // On 401, throw an unauthorized error
                throw APIError.unauthorized
            default:
                // As a simplification, throw an unexpected error for other status codes.
                throw APIError.unexpected(
                    "Request \(urlRequest.description) unexpectedly returned with status code \(response.statusCode)"
                )
            }
        } catch let error {
            // Map any errors that occur while sending the request.
            switch error {
            case let error as NSError where error.code == NSURLErrorNotConnectedToInternet:
                // Intercept offline errors
                throw APIError.offline
            case let error as APIError:
                // Rethrow any `APIError`s
                throw error
            default:
                // Otherwise, fall back to an unexpected error.
                throw APIError.unexpected(
                    "Unexpected error when sending request \(request.urlRequest): \(error.localizedDescription)"
                )
            }
        }
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    // MARK: - Helpers
}
