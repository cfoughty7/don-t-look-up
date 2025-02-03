//
//  NearEarthObjectListResponse.swift
//  API
//
//  Created by Carter Foughty on 1/31/25.
//

import Foundation

/// The `Decodable` response type for a NASA Near Earth Object list request.
public struct NearEarthObjectListResponse: Decodable, Sendable {
    
    // MARK: - API
    
    public var nearEarthObjectModels: [NearEarthObjectModel]
    
    public init(from decoder: any Decoder) throws {
        // The NASA NEO list request returns data in an odd format
        // where the NEOs are in arrays that themselves are a child
        // of an object keyed by the close approach date. This means
        // the keys are dynamic, and so we must implement a custom
        // decoding strategy.
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Get all of the keys (close approach dates) that are in the
        // `nearEarthObjects` container.
        let nearEarthObjectsContainer = try container.nestedContainer(
            keyedBy: DynamicKey.self,
            forKey: .nearEarthObjects
        )
        // Loop over all the keys and add the `nearEarthObjects` to the array.
        let nearEarthObjectModels = try nearEarthObjectsContainer.allKeys.flatMap { key in
            try nearEarthObjectsContainer.decode([NearEarthObjectModel].self, forKey: key)
        }
        
        self.nearEarthObjectModels = nearEarthObjectModels
    }
    
    public struct NearEarthObjectModel: Decodable, Sendable, Hashable {
        public var id: String
        public var neoReferenceId: String
        public var name: String
        public var absoluteMagnitudeH: Double
        public var estimatedDiameter: EstimatedDiameter
        public var isPotentiallyHazardousAsteroid: Bool
        public var closeApproachData: [CloseApproach]
        public var isSentryObject: Bool
        
        public struct CloseApproach: Decodable, Sendable, Hashable {
            public var closeApproachDateFull: Date
            public var relativeVelocity: RelativeVelocity
            public var missDistance: MissDistance
            public var orbitingBody: String
            
            public struct RelativeVelocity: Decodable, Sendable, Hashable {
                public var kilometersPerSecond: String
            }
            
            public struct MissDistance: Decodable, Sendable, Hashable {
                public var kilometers: String
            }
        }

        public struct EstimatedDiameter: Decodable, Sendable, Hashable {
            public var meters: Meters
            
            public struct Meters: Decodable, Sendable, Hashable {
                public var estimatedDiameterMin: Double
                public var estimatedDiameterMax: Double
            }
        }
    }
    
    // MARK: - Constants
    
    private enum CodingKeys: CodingKey {
        case nearEarthObjects
    }
    
    /// A `CodingKey` which can be used for cases where the key name is unknown.
    private struct DynamicKey: CodingKey {
        
        var stringValue: String
        
        // We have no use for `Int` values
        var intValue: Int? { return nil }
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            return nil
        }
    }
    
    // MARK: - Variables
    
    // MARK: - Helpers
}
