//
//  Dependencies.swift
//  API
//
//  Created by Carter Foughty on 2/1/25.
//

import Factory

public extension Container {

    /// The `APIClient` which can be used to send any `APIRequest`
    var apiClient: Factory<APIClient> {
        self { DefaultAPIClient(urlProtocol: nil) }.scope(.singleton)
    }
}

extension Container {
    
    /// The configuration for `API` related tasks
    var api: Factory<API> {
        self { DefaultAPI() }.scope(.singleton)
    }
}
