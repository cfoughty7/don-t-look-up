//
//  Scene.swift
//  don't look up
//
//  Created by Carter Foughty on 2/6/25.
//

import Foundation

/// Enumerates available `SceneKit` models
public enum Model {
    case earth
    case asteroidSmall
    case asteroidMedium
    case asteroidLarge
    
    /// The name of the model
    var name: String {
        switch self {
        case .earth: "Earth.ply"
        case .asteroidSmall: "AsteroidSmall.usdz"
        case .asteroidMedium: "AsteroidMedium.usdz"
        case .asteroidLarge: "AsteroidLarge.usdz"
        }
    }
    
    /// Indicates whether a model's should automatically rotate in the y direction.
    var autorotate: Bool {
        switch self {
        case .earth: true
        case .asteroidSmall, .asteroidMedium, .asteroidLarge: false
        }
    }
    
    /// Indicates whether a model's rotation should be locked to y axis rotation,
    /// or left to right from the user's perspective.
    var lockRotation: Bool {
        switch self {
        case .earth: true
        case .asteroidSmall, .asteroidMedium, .asteroidLarge: false
        }
    }
}
