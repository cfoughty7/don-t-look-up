//
//  NearEarthObjectService.swift
//  Service
//
//  Created by Carter Foughty on 2/2/25.
//

import API
import Factory

/// An interface for types which provide access to `NearEarthObject` data.
public protocol NearEarthObjectService: Actor {
    
    /// Asynchronously fetches and returns an array of `NearEarthObject` values.
    func fetch(date: Date) async throws -> [NearEarthObject]
}

/// The default implementation of `NearEarthObjectService`, which provides access to `NearEarthObject`
/// values fetched from an API and cached for quick access.
///
/// For a more complicated app, I would likely build another set of components to manage request
/// de-duplication and data caching, but that seemed unnecessary for this build.
actor DefaultNearEarthObjectService: NearEarthObjectService {
    
    // MARK: - API
    
    func fetch(date: Date) async throws -> [NearEarthObject] {
        let result = try await apiClient.send(NearEarthObjectListRequest(date: date))
        return result.nearEarthObjects
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    @Injected(\.apiClient) private var apiClient
    
    // MARK: - Helpers
}
