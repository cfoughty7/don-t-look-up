//
//  MockAPIRequest.swift
//  APITests
//
//  Created by Carter Foughty on 2/1/25.
//

@testable import API

/// A mock `APIRequest` where the result is the `MockResult` defined on `MockDecodableURLProtocol`.
/// Instances can be configured to always throw when attempting to decode the result `Data`.
struct MockAPIRequest: APIRequest {
    
    // MARK: - API
    
    typealias Result = MockDecodableURLProtocol.MockResult
    let urlRequest = URLRequest(url: URL(string: "https://google.com")!)
    
    init(throwOnDecode: Bool = false) {
        self.throwOnDecode = throwOnDecode
    }
    
    func decodeValue(data: Data) throws -> MockDecodableURLProtocol.MockResult {
        if throwOnDecode {
            throw MockError.error
        } else {
            try JSONDecoder.standard.decode(MockDecodableURLProtocol.MockResult.self, from: data)
        }
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    /// Indicates whether `decodeValue(data:)` should always throw an error.
    private let throwOnDecode: Bool
    
    // MARK: - Helpers
}
