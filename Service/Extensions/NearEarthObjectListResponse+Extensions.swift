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
        let diameters = nearEarthObjectModels.map {
            ($0.estimatedDiameter.meters.estimatedDiameterMax + $0.estimatedDiameter.meters.estimatedDiameterMin) / 2
        }
        let velocities: [Double] = nearEarthObjectModels.compactMap {
            guard let value = $0.closeApproachData.first?.relativeVelocity.kilometersPerSecond else { return nil }
            return Double(value)
        }
        let missDistances: [Double] = nearEarthObjectModels.compactMap {
            guard let value = $0.closeApproachData.first?.missDistance.kilometers else { return nil }
            return Double(value)
        }
        
        guard let maxDiameter = diameters.max(),
              let minDiameter = diameters.min(),
              let maxVelocity = velocities.max(),
              let minVelocity = velocities.min(),
              let maxMissDistance = missDistances.max(),
              let minMissDistance = missDistances.min() else { return [] }
        
        return nearEarthObjectModels.compactMap {
            guard let closeApproachData = $0.closeApproachData.first,
                  let relativeVelocity = Double(
                    closeApproachData.relativeVelocity.kilometersPerSecond
                  ),
                  let missDistance = Double(
                    closeApproachData.missDistance.kilometers
                  ) else { return nil }
            
            let estimatedDiameter = ($0.estimatedDiameter.meters.estimatedDiameterMax + $0.estimatedDiameter.meters.estimatedDiameterMin) / 2
            let normalizedDiameter = (estimatedDiameter - minDiameter) / (maxDiameter - minDiameter)
            let normalizedRelativeVelocity = (relativeVelocity - minVelocity) / (maxVelocity - minVelocity)
            let normalizedMissDistance = (missDistance - minMissDistance) / (maxMissDistance - minMissDistance)
            
            return NearEarthObject(
                id: $0.id,
                referenceID: $0.neoReferenceId,
                name: $0.name,
                absoluteMagnitude: $0.absoluteMagnitudeH,
                estimatedDiameter: estimatedDiameter,
                isPotentiallyHazardousAsteroid: $0.isPotentiallyHazardousAsteroid,
                closeApproachDate: closeApproachData.closeApproachDateFull,
                relativeVelocity: relativeVelocity,
                missDistance: missDistance,
                orbitingBody: closeApproachData.orbitingBody,
                normalizedDiameter: normalizedDiameter,
                normalizedRelativeVelocity: normalizedRelativeVelocity,
                normalizedMissDistance: normalizedMissDistance
            )
        }
    }
}
