//
//  MockNearEarthObjectService.swift
//  don't look up
//
//  Created by Carter Foughty on 2/3/25.
//

import Core

/// A mock implementation of `NearEarthObjectService`, which can be configured to provide
/// stubbed `NearEarthObject` values or throw errors using `DelayedValues`.
actor MockNearEarthObjectService: NearEarthObjectService {
    
    // MARK: - API
    
    func fetch(date: Date) async throws -> [NearEarthObject] {
        return try await delayedValues.next()
    }
    
    init() {
        self.delayedValues = DelayedValues(values: [
            .value(mockNEOs, delay: 5)
        ])
    }
    
    // MARK: - Constants
    
    private let mockNEOs = [
        NearEarthObject(
            id: "123",
            referenceID: "123",
            name: "(2024 BH)",
            absoluteMagnitude: 21.34,
            estimatedMinimumDiameter: 143.4019234645,
            estimatedMaximumDiameter: 320.6564489709,
            isPotentiallyHazardousAsteroid: true,
            closeApproachDate: Date(),
            relativeVelocity: 19.7498128142,
            missDistance: 38764558.550560687,
            orbitingBody: "Earth"
        ),
        NearEarthObject(
            id: "223",
            referenceID: "223",
            name: "(2013 RE6)",
            absoluteMagnitude: 21.34,
            estimatedMinimumDiameter: 143.4019234645,
            estimatedMaximumDiameter: 320.6564489709,
            isPotentiallyHazardousAsteroid: true,
            closeApproachDate: Date(),
            relativeVelocity: 19.7498128142,
            missDistance: 38764558.550560687,
            orbitingBody: "Earth"
        ),
        NearEarthObject(
            id: "323",
            referenceID: "323",
            name: "(2015 CB)",
            absoluteMagnitude: 21.34,
            estimatedMinimumDiameter: 143.4019234645,
            estimatedMaximumDiameter: 320.6564489709,
            isPotentiallyHazardousAsteroid: true,
            closeApproachDate: Date(),
            relativeVelocity: 19.7498128142,
            missDistance: 38764558.550560687,
            orbitingBody: "Earth"
        )
    ]
    
    // MARK: - Variables
    
    private let delayedValues: DelayedValues<[NearEarthObject]>
    
    // MARK: - Helpers
}
