//
//  MockNearEarthObjectService.swift
//  don't look up
//
//  Created by Carter Foughty on 2/3/25.
//

import API
import Core

/// A mock implementation of `NearEarthObjectService` which can be configured to provide
/// stubbed `NearEarthObject` values or throw errors using `DelayedValues`.
actor MockNearEarthObjectService: NearEarthObjectService {
    
    // MARK: - API
    
    func fetch(date: Date) async throws -> [NearEarthObject] {
        return try await delayedValues.next()
    }
    
    init(delayedValues: DelayedValues<[NearEarthObject]>? = nil) {
        self.delayedValues = delayedValues ?? DelayedValues(values: [
            .error(APIError.unexpected(""), delay: 5),
            .value([.mock1, .mock2, .mock3, .mock4, .mock5, .mock6, .mock7, .mock8, .mock9], delay: 1),
            .value([.mock1, .mock2, .mock4, .mock7, .mock9, .mock10], delay: 3),
        ])
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    private let delayedValues: DelayedValues<[NearEarthObject]>
    
    // MARK: - Helpers
}
