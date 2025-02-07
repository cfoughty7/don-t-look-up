//
//  Dependencies.swift
//  Service
//
//  Created by Carter Foughty on 2/2/25.
//

import Factory

public extension Container {
    
    /// The instance of `NearEarthObjectService` to use when accessing NEO data throughout the app.
    var nearEarthObjectService: Factory<NearEarthObjectService> {
        self {
            // Can be replaced with `MockNearEarthObjectService` in order to
            // test the app with canned responses.
            DefaultNearEarthObjectService()
        }.scope(.singleton)
    }
}
