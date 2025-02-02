//
//  MockVoidAPIRequest.swift
//  APITests
//
//  Created by Carter Foughty on 2/1/25.
//

@testable import API

/// A mock `APIRequest` where the result is `Void`.
struct MockVoidAPIRequest: APIRequest {
    
    // MARK: - API
    
    typealias Result = Void
    let urlRequest = URLRequest(url: URL(string: "https://google.com")!)
    
    init() {}
    
    func decodeValue(data: Data) throws -> Void {
        return ()
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    // MARK: - Helpers
}
