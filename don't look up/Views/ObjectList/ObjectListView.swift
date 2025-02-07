//
//  ObjectListView.swift
//  don't look up
//
//  Created by Carter Foughty on 1/31/25.
//

import SwiftUI
import UI
import AVFoundation

struct ObjectListView: View {
    
    // MARK: - API
    
    // MARK: - Constants
    
    /// A maximum column width, which works as a simple but
    /// effective constraint for larger devices like iPads.
    private let maxColumnWidth: CGFloat = 550
    
    // MARK: - Variables
    
    @StateObject private var viewModel = ObjectListViewModel()
    @Namespace private var namespace
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Navigation bar
                NavigationScrollView { _ in
                    VStack(alignment: .leading, spacing: 10) {
                        TitleText("PLANET EARTH")
                        HeadlineText(viewModel.objectCountText ?? " ")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.horizontal, .top], 20)
                    .padding(.bottom, 16)
                } content: {
                    scrollContent
                }
                // Allow pull to refresh
                .refreshable(action: viewModel.refresh)
            }
            .multilineTextAlignment(.leading)
            .foregroundStyle(Color.readout)
            .background {
                Color.cosmos
                    .ignoresSafeArea()
            }
            // A snappy animation for state changes.
            .animation(.snappy, value: viewModel.state)
            .taskOnFirstAppear {
                // Notify the view model when the view has appeared.
                await viewModel.appeared()
            }
            .navigationDestination(item: $viewModel.navRoute) { route in
                switch route {
                case let .objectDetail(object):
                    ObjectDetailView(object: object, namespace: namespace)
                }
            }
        }
        // Error banners are used when data is loaded
        .error($viewModel.error)
    }

    // MARK: - Helpers
    
    private var scrollContent: some View {
        LazyVStack(spacing: 5) {
            SceneKitView(model: .earth)
                .accessibilityLabel("Spinning model of Earth")
                .frame(height: 220)
            
            LazyVStack(spacing: 50) {
                if !viewModel.state.isError {
                    RadarDivider(nearEarthObjects: viewModel.state.value?.first?.objects)
                        .accessibilityLabel("Representation of today's approaching Near Earth Objects")
                        .padding(.horizontal, 14)
                        // Apply a max width for larger devices
                        .frame(maxWidth: maxColumnWidth)
                }
                
                if let sections = viewModel.state.value {
                    // If a value is loaded, present the sections.
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(sections, id: \.self) { section in
                            HeadlineText(section.dateText.uppercased())
                                .padding(.horizontal, 2)
                                // Additional padding for sections. We can't put this
                                // on the ForEach, so we need to put it here.
                                .padding(.top, sections.first == section ? 0 : 23)
                                .padding(.bottom, 4)
                            
                            ForEach(section.objects, id: \.self) { object in
                                ObjectRow(nearEarthObject: object) {
                                    viewModel.rowTapped(object)
                                }
                                .accessibilityHint("Shows details about object \(object.name)")
                                // A matched transition source, paired with the
                                // ObjectDetailView for a card-like nav transition.
                                .matchedTransitionSource(id: object.id, in: namespace)
                            }
                        }
                    }
                    // Apply a max width for larger devices
                    .frame(maxWidth: maxColumnWidth)
                    
                    Spacer()
                } else if viewModel.state.isLoading {
                    // If a value isn't loaded but the state is loading, show a loading view.
                    // Because of the stylistic nature of the app, a loading state is always
                    // expected for a minimum period of time.
                    Spacer()
                    HeadlineText("SEARCHING THE COSMOS")
                    Spacer()
                } else if let error = viewModel.state.uiError {
                    // If a value isn't loaded and we got an error, show
                    // a full screen error with a retry button.
                    Spacer()
                    ErrorView(error) {
                        Task { @MainActor in
                            await viewModel.refresh()
                        }
                    }
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 20)
    }
}

#Preview {
    ObjectListView()
}
