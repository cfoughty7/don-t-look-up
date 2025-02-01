//
//  API.swift
//  API
//
//  Created by Carter Foughty on 1/31/25.
//

import Foundation

/// Provides basic parameters for requests to a REST API
protocol API {
    
    /// The base `URL` for requests to the NASA REST API
    var nasaBaseURL: URL { get }
    
    /// The API key for requests to the NASA REST API
    var nasaKey: String { get }
}

struct DefaultAPI: API {
    let nasaBaseURL = URL(string: "https://api.nasa.gov/neo/rest/v1")!
    let nasaKey = "dXM7sxDgChK3jh8LlXRXTvwAK8S1jW7pLrYfALBt"
}
