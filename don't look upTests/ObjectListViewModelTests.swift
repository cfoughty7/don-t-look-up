//
//  ObjectListViewModelTests.swift
//  don't look upTests
//
//  Created by Carter Foughty on 1/31/25.
//

import Testing
import Combine
import Factory
import UI
@testable import Core
@testable import Service
@testable import don_t_look_up

@MainActor
class ObjectListViewModelTests {
    
    /// Tests the state machine with a fetch request expected to produce multiple sections
    /// of different dates, each with multiple `NearEarthObject` children.
    @Test private func testMultipleSectionFetch() async throws {
        let mockDates = mockDates
        let mocksDict = mockDates.reduce(into: [DateData: [NearEarthObject]]()) { partialResult, mockDate in
            partialResult[mockDate.data] = [
                NearEarthObject.mock(forDate: mockDate.date),
                NearEarthObject.mock(forDate: mockDate.date),
            ]
        }
        let allMocks = mocksDict.values.flatMap { $0 }
        // Register a mock service with delayed values.
        Container.shared.nearEarthObjectService.register {
            MockNearEarthObjectService(
                delayedValues: DelayedValues<[NearEarthObject]>(values: [
                    .error(MockError.error, delay: 0.1),
                    .value(allMocks, delay: 0.1),
                    .error(MockError.error2, delay: 0.1),
                    .value(allMocks, delay: 0.1),
                ])
            )
        }
        
        let viewModel = ObjectListViewModel()
        // Observe the outputted states
        var observedStates = [LoadingController<[ObjectListViewModel.Section]>.State]()
        var observedErrors = [UIError]()
        viewModel.$state
            .sink { state in
                observedStates.append(state)
            }
            .store(in: &cancellables)
        viewModel.$error
            .sink { error in
                if let error {
                    observedErrors.append(error)
                }
            }
            .store(in: &cancellables)
        
        // Call our load function
        await viewModel.appeared()
        await viewModel.refresh()
        await viewModel.refresh()
        await viewModel.refresh()
        
        let expectedSections = mockDates.map {
            return ObjectListViewModel.Section(
                date: Calendar.current.startOfDay(for: $0.date),
                dateText: $0.data.text,
                objects: mocksDict[$0.data] ?? []
            )
        }
        
        #expect(observedStates == [
            .empty(nil),
            .loading(nil),
            .empty(MockError.error),
            .loading(nil),
            .loaded(expectedSections, nil),
            .loading(expectedSections),
            .loaded(expectedSections, MockError.error2),
            .loading(expectedSections),
            .loaded(expectedSections, nil),
        ])
        #expect(!observedErrors.isEmpty)
    }
    
    // MARK: - Constants
    
    struct DateData: Hashable {
        var formattedString: String
        var text: String
    }
    
    private let mockDateData: [DateData] = [
        DateData(formattedString: "01/01/2025", text: "STARDATE 2025.001 (Jan 01)"),
        DateData(formattedString: "01/02/2025", text: "STARDATE 2025.002 (Jan 02)"),
        DateData(formattedString: "01/03/2025", text: "STARDATE 2025.003 (Jan 03)"),
    ]
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
    
    // MARK: - Variables
    
    private var mockDates: [(data: DateData, date: Date)] {
        mockDateData.map { ($0, dateFormatter.date(from: $0.formattedString)!) }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Helpers
}
