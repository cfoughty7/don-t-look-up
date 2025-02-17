//
//  LoadingControllerTests.swift
//  UITests
//
//  Created by Carter Foughty on 2/7/25.
//

import Testing
import Combine
import Factory
@testable import Core
@testable import UI

class LoadingControllerTests {
    
    @Test func testInitialStateIsEmpty() async throws {
        let controller = LoadingController { 1 }
        let state = try await controller.state.firstValue()

        #expect(state == .empty(nil))
    }
    
    @Test func testSuccessfulLoad() async throws {
        let controller = LoadingController { 1 }
        
        var observedStates: [LoadingController<Int>.State] = []
        await controller.state
            .sink { state in
                observedStates.append(state)
            }
            .store(in: &cancellables)
        
        await controller.load()
        #expect(observedStates == [
            .empty(nil),
            .loading(nil),
            .loaded(1, nil)
        ])
    }
    
    @Test func testLoadFailsWithError() async {
        let controller = LoadingController<Int> { throw MockError.error }
        
        var observedStates: [LoadingController<Int>.State] = []
        await controller.state
            .sink { state in
                observedStates.append(state)
            }
            .store(in: &cancellables)
        await controller.load()
        
        #expect(observedStates == [
            .empty(nil),
            .loading(nil),
            .empty(MockError.error)
        ])
    }
    
    @Test func testMinimumEmptyLoadTimeIsRespected() async {
        let controller = LoadingController<Int>(minimumEmptyLoadTime: 0.5) { 1 }
        
        let start = Date()
        await controller.load()
        let elapsedTime = Date().timeIntervalSince(start)
        #expect(elapsedTime >= 0.5)
        
        let secondStart = Date()
        await controller.load()
        let secondElapsedTime = Date().timeIntervalSince(secondStart)
        #expect(secondElapsedTime < 0.1)
    }
    
    @MainActor
    @Test func testRandomSequence() async throws {
        var returnValues: [Result<Int, MockError>] = [
            .success(1), .success(2), .failure(.error), .failure(.error2), .success(1),
            .failure(.error2), .success(4), .success(5), .success(10), .failure(.error)
        ]
        let controller = LoadingController {
            let next = returnValues.removeFirst()
            switch next {
            case let .success(success): return success
            case let .failure(failure): throw failure
            }
        }
    
        var observedStates: [LoadingController<Int>.State] = []
        controller.state
            .sink { state in
                observedStates.append(state)
            }
            .store(in: &cancellables)
        
        for _ in 0...9 {
            await controller.load()
        }
        
        #expect(observedStates == [
            .empty(nil),
            .loading(nil),
            .loaded(1, nil),
            .loading(1),
            .loaded(2, nil),
            .loading(2),
            .loaded(2, MockError.error),
            .loading(2),
            .loaded(2, MockError.error2),
            .loading(2),
            .loaded(1, nil),
            .loading(1),
            .loaded(1, MockError.error2),
            .loading(1),
            .loaded(4, nil),
            .loading(4),
            .loaded(5, nil),
            .loading(5),
            .loaded(10, nil),
            .loading(10),
            .loaded(10, MockError.error)
        ])
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Helpers
}

