//
//  LoadingController.swift
//  don't look up
//
//  Created by Carter Foughty on 2/6/25.
//

import Core
import Combine

/// A state machine for asynchronous tasks with an empty, loading, and loaded state.
public final actor LoadingController<Value: Hashable & Sendable> {
    
    // MARK: - API
    
    /// The task states
    public enum State {
        /// No `Value` exists, either because loading resulted in an `Error` or the `load` function hasn't been called.
        case empty(Error?)
        /// A new `Value` is being loaded, and any existing `Value` is supplied.
        case loading(Value?)
        /// A `Value` has been loaded, and any subsequent load `Error`s are supplied.
        case loaded(Value, Error?)
    }
    
    /// Publishes the current loading `State`
    @MainActor
    public private(set) lazy var state: AnyPublisher<State, Never> = stateSubject.eraseToAnyPublisher()
    
    /// Creates an instance of a `LoadingController` with a single load function.
    /// - Parameter minimumEmptyLoadTime: The minimum amount of time that a load operation should
    /// take when the `State` is empty.
    /// - Parameter loadFunction: The asynchronous throwing function that produces a `Value`.
    public init(
        minimumEmptyLoadTime: TimeInterval = 0,
        loadFunction: @MainActor @escaping () async throws -> Value
    ) {
        self.minimumEmptyLoadTime = minimumEmptyLoadTime
        self.loadFunction = loadFunction
    }
    
    /// Calls the provided load function to produce a new `Value`,
    /// and updates the `State` based on the result.
    @MainActor
    public func load() async {
        do {
            let currentState = stateSubject.value
            // Return early if we're already loading.
            switch currentState {
            case .loading: return
            default: break
            }
            // Before calling the load function, set the state to loading with the current value.
            stateSubject.send(.loading(currentState.value))
            // Only consider the load time when the state is empty.
            let minimumEmptyLoadTime = currentState.isEmpty ? minimumEmptyLoadTime : nil
            
            // Call the load function, and call to hold for the waiting period.
            async let valueLoad = try await loadFunction()
            async let waitPeriod: Void = await wait(interval: minimumEmptyLoadTime)
            
            // Wait for both tasks to finish.
            let (value, _) = try await (valueLoad, waitPeriod)
            // Update the state machine.
            set(result: .success(value))
        } catch {
            set(result: .failure(error))
        }
    }
    
    // MARK: - Constants
    
    /// The result of a load operation
    private typealias LoadResult = Result<Value, Error>
    
    // MARK: - Variables
    
    /// The minimum amount of time that a load operation should
    /// take when the `State` is empty.
    private let minimumEmptyLoadTime: TimeInterval?
    /// The asynchronous throwing function that produces a `Value`.
    private let loadFunction: @MainActor () async throws -> Value
    
    /// A subject which holds the current loading state.
    @MainActor
    private var stateSubject = CurrentValueSubject<State, Never>(.empty(nil))
    
    // MARK: - Helpers
    
    /// Updates the loading state based on the `LoadResult`.
    @MainActor
    private func set(result: LoadResult) {
        let currentState = stateSubject.value
        
        switch result {
        case let .success(value):
            // If the load succeeded, set to loaded.
            stateSubject.send(.loaded(value, nil))
        case let .failure(error):
            switch currentState {
            case let .loading(value):
                // On failure, set the loading state back to loaded
                // if a value already exists. Otherwise, set back to empty.
                if let value {
                    stateSubject.send(.loaded(value, error))
                } else {
                    stateSubject.send(.empty(error))
                }
            case let .loaded(value, _):
                // If a value already exists, set the new error.
                stateSubject.send(.loaded(value, error))
            case .empty:
                // If the state was empty, just update the error.
                stateSubject.send(.empty(error))
            }
        }
    }
    
    /// Asynchronously waits for the provided time interval, if any
    private func wait(interval: TimeInterval?) async {
        guard let interval else { return }
        
        await withCheckedContinuation { continuation in
            DispatchQueue.global().asyncAfter(deadline: .now() + interval) {
                continuation.resume()
            }
        }
    }
}

public extension LoadingController.State {
    
    /// Indicates whether the current state is `empty`
    var isEmpty: Bool {
        switch self {
        case .empty: true
        default: false
        }
    }
    
    /// Indicates whether the current state is `loading`
    var isLoading: Bool {
        switch self {
        case .loading: true
        default: false
        }
    }
    
    /// Produces any existing `Value`, regardless of the state
    var value: Value? {
        switch self {
        case let .loading(value): value
        case let .loaded(value, _): value
        case .empty: nil
        }
    }
    
    /// Produces any errors from the `empty` state
    var isError: Bool {
        switch self {
        case let .empty(error): error != nil
        default: false
        }
    }
    
    /// Provides a `UIError` associated with an `empty` state error, if any
    var uiError: UIError? {
        switch self {
        case let .empty(error): (error as? AppError)?.uiError
        default: nil
        }
    }
    
    /// Provides a `UIError` if the current state is `loaded` with an error
    var loadedUIError: UIError? {
        switch self {
        case let .loaded(_, error): (error as? AppError)?.uiError
        default: nil
        }
    }
}

extension LoadingController.State: Equatable where Value: Equatable {
    
    // Unfortunately Error doesn't conform to equatable, so we have to do this manually.
    public static func == (
        lhs: LoadingController<Value>.State,
        rhs: LoadingController<Value>.State
    ) -> Bool {
        switch (lhs, rhs) {
        case let (.loading(lhs), .loading(rhs)):
            return lhs == rhs
        case let (.loaded(lDataType, lError), .loaded(rDataType, rError)):
            return lDataType == rDataType && (lError as NSError?) == (rError as NSError?)
        case let (.empty(lError), .empty(rError)):
            return (lError as NSError?) == (rError as NSError?)
        default: return false
        }
    }
}
