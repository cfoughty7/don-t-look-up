//
//  MockUnauthorizedURLProtocol.swift
//  APITests
//
//  Created by Carter Foughty on 2/1/25.
//

import Foundation

/// A `URLProtocol` which mocks a `URLResponse` with a 401 status code.
class MockUnauthorizedURLProtocol: URLProtocol {
    
    // MARK: - API
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: 401,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": "application/json"]
        )!
        
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    // MARK: - Helpers
}
