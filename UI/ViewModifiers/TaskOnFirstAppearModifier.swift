//
//  TaskOnFirstAppearModifier.swift
//  UI
//
//  Created by Carter Foughty on 2/6/25.
//

import SwiftUI

public extension View {
    
    /// Performs an action on the first appearance of a view. This differs from the `onAppear` modifier,
    /// which will be called every time a view appears. For instance, the `onAppear` modifier will repeat
    /// the action if a view in a nav stack returns to the top of the stack.
    func onFirstAppear(_ action: @MainActor @escaping () -> Void) -> some View {
        modifier(OnFirstAppearModifier(action: action))
    }
    
    /// Performs an asynchronous task on the first appearance of a view. This differs from
    /// the `task` modifier, which will be called every time a view appears. For instance,
    /// the `task` modifier will repeat the task if a view in a nav stack returns to the top of the stack.
    func taskOnFirstAppear(_ task: @MainActor @escaping () async -> Void) -> some View {
        modifier(TaskOnFirstAppearModifier(task: task))
    }
}

fileprivate struct OnFirstAppearModifier: ViewModifier {
    
    // MARK: - API
    
    init(action: @MainActor @escaping () -> Void) {
        self.action = action
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    /// Remembers whether a view has appeared
    @State private var hasAppeared = false
    
    /// The task to perform
    private let action: @MainActor () -> Void
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasAppeared else { return }
                
                action()
                hasAppeared = true
            }
    }

    // MARK: - Helpers
    
}

fileprivate struct TaskOnFirstAppearModifier: ViewModifier {
    
    // MARK: - API
    
    init(task: @MainActor @escaping () async -> Void) {
        self.task = task
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    /// Remembers whether a view has appeared
    @State private var hasAppeared = false
    
    /// The task to perform
    private let task: @MainActor () async -> Void
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        content
            .task {
                guard !hasAppeared else { return }
                
                await task()
                hasAppeared = true
            }
    }

    // MARK: - Helpers
    
}
