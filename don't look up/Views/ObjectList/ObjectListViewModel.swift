//
//  ObjectListViewModel.swift
//  don't look up
//
//  Created by Carter Foughty on 1/31/25.
//

import Core
import Service
import UI
import Combine
import Factory

@MainActor
class ObjectListViewModel: ObservableObject {
    
    // MARK: - API
    
    /// A model which represents a section, based on a date, of objects
    struct Section: Hashable {
        var date: Date
        var dateText: String
        var objects: [NearEarthObject]
    }
    
    /// The loading state of the asynchronous data
    @Published private(set) var state: LoadingController<[Section]>.State = .empty(nil)
    /// Any `UIError` that is captured when data is loaded
    @Published var error: UIError?
    /// The current navigation route
    @Published var navRoute: ObjectListNavRoute? = nil
    
    /// Text representing the number of near earth objects
    var objectCountText: String? {
        guard let objectCount = state.value?.reduce(
            into: 0,
            { $0 += $1.objects.count }
        ) else { return nil }
        return "THERE ARE \(objectCount) OBJECT\(objectCount == 1 ? "" : "S") APPROACHING"
    }
    
    init() {
        installLoadingController()
    }
    
    /// Kicks off an initial load task
    func appeared() async {
        await loadingController.load()
    }
    
    /// Performs an asynchronous load
    func refresh() async {
        await loadingController.load()
    }
    
    func rowTapped(_ object: NearEarthObject) {
        navRoute = .objectDetail(object)
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    private let loadingController = LoadingController<[Section]>(minimumEmptyLoadTime: 2) {
        @Injected(\.nearEarthObjectService) var nearEarthObjectService
        
        let starDateFormatter = DateFormatter()
        starDateFormatter.dateFormat = "yyyy.DDD"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        
        let nearEarthObjects = try await nearEarthObjectService.fetch(date: Date())
        // Map the returned objects into our section models
        let nearEarthObjectSections = nearEarthObjects.reduce(
            into: [Date: Section]()
        ) { partialResult, object in
            let date = Calendar.current.startOfDay(for: object.closeApproachDate)
            let existingObjects = partialResult[date]?.objects ?? []
            let starDateText = starDateFormatter.string(from: date)
            let dateText = "STARDATE \(starDateText) (\(dateFormatter.string(from: date)))"
            
            partialResult[date] = Section(
                date: date,
                dateText: dateText,
                objects: existingObjects + [object]
            )
        }.values
        return nearEarthObjectSections.sorted(by: { $0.date < $1.date })
    }
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Helpers
    
    private func installLoadingController() {
        // Assign the loading controller state to our published state
        loadingController.state
            .assign(to: &$state)
        
        loadingController.state
            .sink { state in
                // Observe any loaded UIErrors that come up. These
                // are presented to the UI as banners.
                self.error = state.loadedUIError
            }
            .store(in: &cancellables)
    }
}
