//
//  NearEarthObject.swift
//  Service
//
//  Created by Carter Foughty on 2/2/25.
//

import Foundation

/// Represents any near Earth object and provides information about its size and trajectory.
public struct NearEarthObject: Hashable, Sendable {
    
    public enum Size: Sendable {
        case small
        case med
        case large
    }
    
    public enum Risk: Sendable {
        case low
        case med
        case high
    }
    
    public var id: String
    public var referenceID: String
    public var name: String
    public var absoluteMagnitude: Double
    public var estimatedDiameter: Double // m
    public var isPotentiallyHazardousAsteroid: Bool
    public var closeApproachDate: Date
    public var relativeVelocity: Double // km/sec
    public var missDistance: Double // km
    public var orbitingBody: String
    
    public var normalizedDiameter: Double
    public var normalizedRelativeVelocity: Double
    public var normalizedMissDistance: Double
    
    public var size: Size {
        if estimatedDiameter < 100 {
            return .small
        } else if estimatedDiameter < 250 {
            return .med
        } else {
            return .large
        }
    }
    
    public var risk: Risk
    
    init(
        id: String,
        referenceID: String,
        name: String,
        absoluteMagnitude: Double,
        estimatedDiameter: Double,
        isPotentiallyHazardousAsteroid: Bool,
        closeApproachDate: Date,
        relativeVelocity: Double,
        missDistance: Double,
        orbitingBody: String,
        normalizedDiameter: Double,
        normalizedRelativeVelocity: Double,
        normalizedMissDistance: Double
    ) {
        self.id = id
        self.referenceID = referenceID
        self.name = name
        self.absoluteMagnitude = absoluteMagnitude
        self.estimatedDiameter = estimatedDiameter
        self.isPotentiallyHazardousAsteroid = isPotentiallyHazardousAsteroid
        self.closeApproachDate = closeApproachDate
        self.relativeVelocity = relativeVelocity
        self.missDistance = missDistance
        self.orbitingBody = orbitingBody
        self.normalizedDiameter = normalizedDiameter
        self.normalizedRelativeVelocity = normalizedRelativeVelocity
        self.normalizedMissDistance = normalizedMissDistance
        
        let size = estimatedDiameter
        // A relatively arbitrary equation that results in fun doomsday ratings
        let doomScore = (size * pow(relativeVelocity, 2.0)) / pow(missDistance, 1.2) * 10_000_000_000
        
        switch doomScore {
        case ..<80_000: self.risk = .low
        case 80_000..<500_000: self.risk = .med
        default: self.risk = .high
        }
    }
}
