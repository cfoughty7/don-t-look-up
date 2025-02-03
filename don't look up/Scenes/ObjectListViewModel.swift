//
//  ObjectListViewModel.swift
//  don't look up
//
//  Created by Carter Foughty on 1/31/25.
//

import Service
import Factory

@MainActor
class ObjectListViewModel: ObservableObject {
    
    // MARK: - API
    
    @Published private(set) var objects = [NearEarthObject]()
    
    init() {
        
    }
    
    func appeared() async {
        await performRequest()
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    @Injected(\.nearEarthObjectService) private var nearEarthObjectService

    // MARK: - Helpers
    
    private func performRequest() async {
        do {
            let result = try await nearEarthObjectService.fetch(date: Date())
            self.objects = result
        } catch {
            print("~~ \(error.localizedDescription)")
        }
    }
}
