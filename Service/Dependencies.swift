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
//            DefaultNearEarthObjectService()
            MockNearEarthObjectService()
        }.scope(.singleton)
    }
}
