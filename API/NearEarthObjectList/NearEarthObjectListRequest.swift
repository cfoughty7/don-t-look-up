//
//  NearEarthObjectListRequest.swift
//  API
//
//  Created by Carter Foughty on 1/31/25.
//

import Core
import Factory

/// An `APIRequest` to the NASA Near Earth Object list REST API
public struct NearEarthObjectListRequest: APIRequest {
    
    // MARK: - API
    
    public typealias Result = NearEarthObjectListResponse
    public let urlRequest: URLRequest
    
    public init() {
        @Injected(\.api) var api
        let url = api.nasaBaseURL.appending(component: "feed")
        
        // Convert the URL to URLComponents. Force unwrap this because we can reasonably
        // assume that any issues are likely to arise during development.
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = [
            URLQueryItem(name: "start_date", value: "2025-01-01"),
            URLQueryItem(name: "end_date", value: "2025-01-08"),
            URLQueryItem(name: "api_key", value: api.nasaKey),
        ]
        
        // Convert the components back to a URL. Force unwrap this because we can
        // reasonably assume that any issues are likely to arise during development.
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "GET"
        self.urlRequest = urlRequest
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    // MARK: - Helpers
}
