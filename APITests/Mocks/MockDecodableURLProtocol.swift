//
//  MockDecodableURLProtocol.swift
//  APITests
//
//  Created by Carter Foughty on 2/1/25.
//

import Foundation

/// A `URLProtocol` which mocks a successful response with `MockResult` JSON data.
class MockDecodableURLProtocol: URLProtocol {
    
    // MARK: - API
    
    /// The mock result `Codable` type whose encoded form is embedded in the `HTTPURLResponse`
    struct MockResult: Codable, Equatable {
        var value: String
        
        static let standard = MockResult(value: "Mock Value")
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": "application/json"]
        )!
        
        let jsonData = try! JSONEncoder.standard.encode(MockResult.standard)
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: jsonData)
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    // MARK: - Helpers
}
