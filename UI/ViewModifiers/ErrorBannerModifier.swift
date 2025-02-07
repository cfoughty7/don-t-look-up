//
//  ErrorBannerModifier.swift
//  UI
//
//  Created by Carter Foughty on 2/6/25.
//

import SwiftUI
import Core

public extension View {
    
    /// Presents a `UIError` modally at the top of the view. This modifier internally manages
    /// state to present the `UIError` for a display interval and subsequently clears the binding.
    /// If the `UIError` is updated before the display interval has completed, the new error will
    /// be displayed and the interval reset.
    ///
    /// This modifier uses a simplified approach to present errors as an overlay. As such, it should
    /// only be used when presenting errors from a view that touches the top safe area. Normally,
    /// I would use an approach that generates true `modal` views that appear over all other content
    /// in the app, but it doesn't seem called for in this case.
    ///
    /// - Parameter uiError: The error to display to the user
    /// - Parameter displayInterval: The display interval for the error
    func error(_ uiError: Binding<UIError?>, displayInterval: Int = 5) -> some View {
        modifier(ErrorBannerModifier(uiError: uiError, displayInterval: displayInterval))
    }
}

fileprivate struct ErrorBannerModifier: ViewModifier {
    
    // MARK: - API
    
    init(uiError: Binding<UIError?>, displayInterval: Int) {
        self._uiError = uiError
        self.displayInterval = displayInterval
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    @Binding private var uiError: UIError?
    @State private var presentedUIError: UIError?
    @State private var presentedErrorID: UUID?
    
    private let displayInterval: Int
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                content
                
                // We construct the view this way rather than just a simple overlay
                // so that the error banner transitions in and out from all the way
                // above that top safe area.
                VStack {
                    if let presentedUIError {
                        ErrorBanner(presentedUIError)
                            .padding(.top, geometry.safeAreaInsets.top)
                            .padding(12)
                            .transition(.move(edge: .top))
                    }
                    
                    Spacer()
                }
                .ignoresSafeArea(edges: .top)
            }
            .animation(.spring(duration: 0.25), value: presentedUIError)
            .onChange(of: uiError) { _, uiError in
                guard let uiError else { return }
                
                self.presentedUIError = uiError
                self.presentedErrorID = uiError.id
                
                Task { @MainActor in
                    // Wait the display interval period
                    try? await Task.sleep(
                        for: .seconds(displayInterval),
                        tolerance: .milliseconds(0.1)
                    )
                    
                    // Only dismiss the error if it matches the stored error ID.
                    // This is to ensure that we don't perform an early dismissal
                    // of an error if it was changed while another error was being
                    // presented.
                    if uiError.id == self.presentedErrorID {
                        self.presentedUIError = nil
                        self.uiError = nil
                    }
                }
            }
            
        }
    }

    // MARK: - Helpers
    
}
