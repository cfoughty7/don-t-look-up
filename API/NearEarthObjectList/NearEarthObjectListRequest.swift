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
    
    /// Creates an instance of a `NearEarthObjectListRequest` where the expected
    /// near earth objects have an approach date in a one week period.
    /// - Parameter date: The `Date` to use as the start of the one week window for object approach
    public init(date: Date) {
        @Injected(\.api) var api
        let url = api.nasaBaseURL.appending(component: "feed")
        
        // Assume an end date of seven days after the start date.
        let endDate = date.addingTimeInterval(7 * 24 * 60 * 60)
        let startDateString = Self.dateFormatter.string(from: date)
        let endDateString = Self.dateFormatter.string(from: endDate)
        
        // Convert the URL to URLComponents. Force unwrap this because we can reasonably
        // assume that any issues are likely to arise during development.
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = [
            URLQueryItem(name: "start_date", value: startDateString),
            URLQueryItem(name: "end_date", value: endDateString),
            URLQueryItem(name: "api_key", value: api.nasaKey),
        ]
        
        // Convert the components back to a URL. Force unwrap this because we can
        // reasonably assume that any issues are likely to arise during development.
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = "GET"
        self.urlRequest = urlRequest
    }
    
    // MARK: - Constants
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // MARK: - Variables
    
    // MARK: - Helpers
}
