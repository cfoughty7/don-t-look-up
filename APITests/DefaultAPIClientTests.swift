//
//  DefaultAPIClientTests.swift
//  APITests
//
//  Created by Carter Foughty on 1/31/25.
//

import Testing
import Factory
@testable import API

struct DefaultAPIClientTests {
    
    /// Tests a successful request where the result is `Void`
    @Test func successfulVoidRequest() async throws {
        let apiClient = DefaultAPIClient(urlProtocol: nil)
        let result: MockVoidAPIRequest.Result = try await apiClient.send(MockVoidAPIRequest())
        
        #expect(result == ())
    }
    
    /// Tests a successful request and decoding when the result is `Decodable`
    @Test func successfulDecodableRequest() async throws {
        let apiClient = DefaultAPIClient(urlProtocol: MockDecodableURLProtocol.self)
        let result = try? await apiClient.send(MockAPIRequest(throwOnDecode: false))
        
        #expect(result?.value == MockAPIRequest.Result.standard.value)
    }
    
    /// Tests the case when a request returns with a 401 status code
    @Test func unauthorizedRequest() async throws {
        let apiClient = DefaultAPIClient(urlProtocol: MockUnauthorizedURLProtocol.self)
        
        await #expect(throws: APIError.unauthorized) {
            try await apiClient.send(MockVoidAPIRequest())
        }
    }
    
    /// Tests a successful request of a `Decodable` type when the decoding fails.
    @Test func decodeFailure() async throws {
        let apiClient = DefaultAPIClient(urlProtocol: nil)
        
        do {
            let _ = try await apiClient.send(MockAPIRequest(throwOnDecode: true))
            #expect(Bool(false), "The request unexpectedly succeeded with successful decoding.")
        } catch let error {
            switch error {
            case APIError.unexpected: break
            default: #expect(Bool(false), "The request failed with an incorrect error.")
            }
        }
    }

    /// Tests a failed request due to the device being offline.
    @Test func deviceOffline() async throws {
        let apiClient = DefaultAPIClient(urlProtocol: MockOfflineURLProtocol.self)
        
        await #expect(throws: APIError.offline) {
            try await apiClient.send(MockVoidAPIRequest())
        }
    }
}
