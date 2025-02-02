//
//  MockOfflineURLProtocol.swift
//  APITests
//
//  Created by Carter Foughty on 2/1/25.
//

import Foundation

/// A `URLProtocol` which mocks an offline error response.
class MockOfflineURLProtocol: URLProtocol {
    
    // MARK: - API
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        client?.urlProtocol(self, didFailWithError: error)
    }
    
    override func stopLoading() {}
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    // MARK: - Helpers
}
