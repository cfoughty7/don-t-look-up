//
//  NearEarthObjectListResponse+Extensions.swift
//  Service
//
//  Created by Carter Foughty on 2/2/25.
//

import API

extension NearEarthObjectListResponse {
    
    /// An array of simplified `NearEarthObject` values which are derived from the list response.
    var nearEarthObjects: [NearEarthObject] {
        nearEarthObjectModels.compactMap {
            guard let closeApproachData = $0.closeApproachData.first,
                  let relativeVelocity = Double(
                    closeApproachData.relativeVelocity.kilometersPerSecond
                  ),
                  let missDistance = Double(
                    closeApproachData.missDistance.kilometers
                  ) else { return nil }
            
            return NearEarthObject(
                id: $0.id,
                referenceID: $0.neoReferenceId,
                name: $0.name,
                absoluteMagnitude: $0.absoluteMagnitudeH,
                estimatedMinimumDiameter: $0.estimatedDiameter.meters.estimatedDiameterMin,
                estimatedMaximumDiameter: $0.estimatedDiameter.meters.estimatedDiameterMax,
                isPotentiallyHazardousAsteroid: $0.isPotentiallyHazardousAsteroid,
                closeApproachDate: closeApproachData.closeApproachDateFull,
                relativeVelocity: relativeVelocity,
                missDistance: missDistance,
                orbitingBody: closeApproachData.orbitingBody
            )
        }
    }
}
