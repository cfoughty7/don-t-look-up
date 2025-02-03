//
//  NearEarthObject.swift
//  Service
//
//  Created by Carter Foughty on 2/2/25.
//

import Foundation

/// Represents any near Earth object and provides information about its size and trajectory.
public struct NearEarthObject: Hashable, Sendable {
    public var id: String
    public var referenceID: String
    public var name: String
    public var absoluteMagnitude: Double
    public var estimatedMinimumDiameter: Double // m
    public var estimatedMaximumDiameter: Double // m
    public var isPotentiallyHazardousAsteroid: Bool
    public var closeApproachDate: Date
    public var relativeVelocity: Double // km/sec
    public var missDistance: Double // km
    public var orbitingBody: String
    
    init(
        id: String,
        referenceID: String,
        name: String,
        absoluteMagnitude: Double,
        estimatedMinimumDiameter: Double,
        estimatedMaximumDiameter: Double,
        isPotentiallyHazardousAsteroid: Bool,
        closeApproachDate: Date,
        relativeVelocity: Double,
        missDistance: Double,
        orbitingBody: String
    ) {
        self.id = id
        self.referenceID = referenceID
        self.name = name
        self.absoluteMagnitude = absoluteMagnitude
        self.estimatedMinimumDiameter = estimatedMinimumDiameter
        self.estimatedMaximumDiameter = estimatedMaximumDiameter
        self.isPotentiallyHazardousAsteroid = isPotentiallyHazardousAsteroid
        self.closeApproachDate = closeApproachDate
        self.relativeVelocity = relativeVelocity
        self.missDistance = missDistance
        self.orbitingBody = orbitingBody
    }
}
