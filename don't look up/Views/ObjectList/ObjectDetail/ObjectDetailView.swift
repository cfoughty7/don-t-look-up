//
//  ObjectDetailView.swift
//  don't look up
//
//  Created by Carter Foughty on 2/5/25.
//

import SwiftUI
import Service
import UI

struct ObjectDetailView: View {
    
    // MARK: - API
    
    init(object: NearEarthObject, namespace: Namespace.ID) {
        self._viewModel = StateObject(wrappedValue: ObjectDetailViewModel(object: object))
        self.object = object
        self.namespace = namespace
    }
    
    // MARK: - Constants
    
    /// The padding along the edges of the view
    private let viewPadding: CGFloat = 20
    /// The corner radius to use for the navigation bar
    private let navBarCornerRadius: CGFloat = 16
    /// The horizontal spacing between data in the metric boxes
    private let horizontalMetricSpacing: CGFloat = 16
    /// The vertical spacing between data in the metric boxes
    private let verticalMetricSpacing: CGFloat = 8
    /// The corner radius of the detail card view
    private let cardCornerRadius: CGFloat = 16
    /// The padding to use between metric cards
    private let interMetricSpacing: CGFloat = 20
    /// The max width to use for attribute indicator views
    private let attributeIndicatorMaxWidth: CGFloat  = 200
    
    // MARK: - Variables
    
    @StateObject private var viewModel: ObjectDetailViewModel
    @State private var isNavBarBackgroundVisible: Bool = false
    
    private let object: NearEarthObject
    private let namespace: Namespace.ID
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Create a grid view background
            StrokedGrid(
                stroke: Color.mineral.opacity(0.4),
                rectSize: 22,
                lineWidth: 0.5
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                SceneKitView(model: viewModel.diameterCategory.model)
                    .frame(height: 200)
                    .padding(.vertical, 25)
                
                GeometryReader { geometry in
                    NavigationScrollView(
                        navBarCornerRadius: navBarCornerRadius
                    ) { isBackgroundVisible in
                        HStack(spacing: 0) {
                            BackButton()
                            Spacer(minLength: 10)
                            if isBackgroundVisible {
                                TitleText(object.name)
                            }
                            Spacer(minLength: 10)
                            BackButton()
                                .disabled(true)
                                .hidden()
                        }
                        .frame(maxWidth: .infinity)
                        .padding([.horizontal, .top], viewPadding)
                        .padding(.bottom, 16)
                    } content: {
                        // In cases where the screen's width is greater than it's height,
                        // use a wide layout.
                        if geometry.size.width > geometry.size.height {
                            wideDetailView
                        } else {
                            detailView
                        }
                    }
                    .foregroundStyle(Color.readout)
                    .background {
                        UnevenRoundedRectangle(
                            topLeadingRadius: navBarCornerRadius,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: navBarCornerRadius,
                            style: .continuous
                        )
                        .fill(Color.mineral)
                        .ignoresSafeArea(edges: .bottom)
                    }
                    .navigationTransition(.zoom(sourceID: object.id, in: namespace))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background {
            Color.cosmos.ignoresSafeArea()
        }
        .navigationBarBackButtonHidden()
    }

    // MARK: - Helpers
    
    private var detailView: some View {
        LazyVStack(alignment: .leading, spacing: interMetricSpacing) {
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 14) {
                    HugeText(object.name)
                    BodyText("\(object.riskText) DOOMSDAY RISK")
                        .foregroundStyle(object.riskColor)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    CalloutText("ORBITAL CLASS: APO")
                    BodyText("Near-Earth asteroid orbits which cross the Earth’s orbit similar to that of 1862 Apollo.")
                }
            }
            
            closeApproachView
            diameterView
            velocityView
            missDistanceView
        }
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
        .padding([.horizontal, .bottom], viewPadding)
    }
    
    private var wideDetailView: some View {
        // Not much benefit to lazy views here.
        HStack(alignment: .top, spacing: 80) {
            VStack(alignment: .leading, spacing: interMetricSpacing) {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 14) {
                        HugeText(object.name)
                        BodyText(object.riskText + " DOOMSDAY RISK")
                            .foregroundStyle(object.riskColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HeadlineText("ORBITAL CLASS: APO")
                        BodyText("Near-Earth asteroid orbits which cross the Earth’s orbit similar to that of 1862 Apollo.")
                    }
                }
                
                closeApproachView
                diameterView
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .leading, spacing: interMetricSpacing) {
                velocityView
                missDistanceView
            }
            .frame(maxWidth: .infinity)
        }
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
        .padding([.horizontal, .bottom], viewPadding)
    }
    
    private var closeApproachView: some View {
        borderedItem {
            DynamicHStack(spacing: horizontalMetricSpacing) { _ in
                HeadlineText("CLOSE APPROACH")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Group {
                    switch viewModel.approachTimeText {
                    case let .future(text):
                        Text(text)
                            .fontWeight(.semibold)
                            .monospaced()
                            .padding(.bottom, 2)
                    case let .past(text):
                        BodyText(text)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(viewModel.approachTimeColor)
            }
        }
    }
    
    private var diameterView: some View {
        borderedItem {
            DynamicHStack(spacing: horizontalMetricSpacing) { isVertical in
                VStack(alignment: .leading, spacing: verticalMetricSpacing) {
                    HeadlineText("DIAMETER")
                    HStack(spacing: 12) {
                        TitleText(viewModel.diameterText)
                        CalloutText("METERS")
                            .foregroundStyle(Color.mineral)
                            .padding([.top, .horizontal], 4)
                            .padding(.bottom, 2)
                            .background(Color.readout)
                            .padding(.bottom, 2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .trailing, spacing: verticalMetricSpacing) {
                    ObjectAttributeIndicator(
                        value: viewModel.normalizedDiameter,
                        style: .large
                    )
                    .frame(maxWidth: isVertical ? nil : attributeIndicatorMaxWidth)
                    
                    CalloutText(viewModel.diameterCategory.text)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(
                            Color.risk(value: viewModel.normalizedDiameter)
                        )
                }
            }
        }
    }
    
    private var velocityView: some View {
        borderedItem {
            DynamicHStack(spacing: horizontalMetricSpacing) { isVertical in
                VStack(alignment: .leading, spacing: verticalMetricSpacing) {
                    HeadlineText("RELATIVE VELOCITY")
                    HStack(spacing: 12) {
                        TitleText(viewModel.relativeVelocityText)
                        CalloutText("KM/SEC")
                            .foregroundStyle(Color.mineral)
                            .padding([.top, .horizontal], 4)
                            .padding(.bottom, 2)
                            .background(Color.readout)
                            .padding(.bottom, 2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .trailing, spacing: verticalMetricSpacing) {
                    ObjectAttributeIndicator(
                        value: viewModel.normalizedRelativeVelocity,
                        style: .small
                    )
                    .frame(maxWidth: isVertical ? nil : attributeIndicatorMaxWidth)
                    
                    CalloutText(viewModel.relativeVelocityCategory.text)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(
                            Color.risk(value: viewModel.normalizedRelativeVelocity)
                        )
                }
            }
        }
    }
    
    private var missDistanceView: some View {
        borderedItem {
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: verticalMetricSpacing) {
                    HeadlineText("MISS DISTANCE")
                    HStack(spacing: 12) {
                        TitleText(viewModel.missDistanceText)
                        CalloutText(viewModel.missDistanceLabelText)
                            .foregroundStyle(Color.mineral)
                            .padding([.top, .horizontal], 4)
                            .padding(.bottom, 2)
                            .background(Color.readout)
                            .padding(.bottom, 2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                StrokedGrid(
                    stroke: Color.readout.opacity(0.2),
                    rectSize: 12,
                    lineWidth: 0.5
                )
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .background(Color.readout.opacity(0.05))
                .overlay {
                    TrajectoryView()
                }
                .clipShape(RoundedRectangle(cornerRadius: 2))
                .padding(.bottom, 2)
            }
        }
    }
    
    /// Creates a consistent bordered view for our various metrics
    @ViewBuilder
    private func borderedItem(_ content: @escaping () -> some View) -> some View {
        content()
            .padding([.top, .horizontal], 14)
            .padding(.bottom, 12)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.readout, lineWidth: 1)
            }
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    ObjectDetailView(object: .mock1, namespace: namespace)
}
