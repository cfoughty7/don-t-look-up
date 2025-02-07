//
//  ObjectAttributeIndicator.swift
//  don't look up
//
//  Created by Carter Foughty on 2/5/25.
//

import SwiftUI

/// A progress-style indicator view comprised of horizontal bars, which fill to indicate a position on a scale.
/// The color of filled bars ramps from `Color.readout` to `Color.warning` at 50% and `Color.impact` at 100%.
struct ObjectAttributeIndicator: View {
    
    // MARK: - API
    
    /// The style of the indicator
    enum Style {
        /// Bars prefer to be 2 points wide
        case small
        /// Bars prefer to be 20 points wide
        case large
        
        /// The preferred width of the bars
        var preferredBarWidth: CGFloat {
            switch self {
            case .small: 2
            case .large: 20
            }
        }
        
        /// The spacing between bars
        var spacing: CGFloat {
            switch self {
            case .small: 1
            case .large: 4
            }
        }
    }
    
    /// Creates an instance of an `ObjectAttributeIndicator`
    /// - Parameter value: The 'progress' to present, on a scale of 0 to 1
    /// - Parameter style: The `Style` which defines attributes of the view
    init(value: Double, style: Style) {
        self.value = value
        self.style = style
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    /// The calculated number of bars that should be displayed, based on the available space
    @State private var totalBars: Int = 10
    /// The calculated width of the bars, based on the available space
    @State private var actualBarWidth: CGFloat = .zero
    
    /// The progress to present, on a scale of 0 to 1. This property drives which bars are filled in.
    private let value: Double
    /// The `Style` to use when configuring the view.
    private let style: Style
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: style.spacing) {
            ForEach(Array(0...(totalBars - 1)), id: \.self) { index in
                RoundedRectangle(cornerRadius: 6)
                    // If there is no fill color, fallback to a toned down white.
                    .fill(fillColor(forBarWithIndex: index) ?? Color.white.opacity(0.1))
                    .frame(width: actualBarWidth)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 26)
        .onSizeChange { size in
            let spacing = style.spacing
            // First, calculate an estimation of the number of bars to display
            // based on the preferred width of the bars
            let estimatedPillCount = size.width / (style.preferredBarWidth + spacing)
            // The actual number of bars to display, with a minimum of 5
            let barCount = max(5, Int(floor(estimatedPillCount)))
            // The actual bar width to use, calculated from the
            // actual number of bars that will be displayed.
            let barWidth = (size.width - (CGFloat(barCount - 1) * spacing)) / CGFloat(barCount)
            
            actualBarWidth = barWidth
            totalBars = barCount
        }
    }
    
    // MARK: - Helpers
    
    /// The color to use for a bar with the given index, if it should be filled
    private func fillColor(forBarWithIndex index: Int) -> Color? {
        // The last index of a filled bar, rounding to the nearest.
        let filledBars = Int((value * Double(totalBars)).rounded(.toNearestOrAwayFromZero)) - 1
        let isFilledIn = index <= filledBars
        guard isFilledIn else { return nil }
        
        // The normalized position (0 to 1) of the bar.
        let position = Double(index + 1) / Double(totalBars)
        return Color.risk(value: position)
    }
}

#Preview {
    VStack(spacing: 50) {
        ForEach([ObjectAttributeIndicator.Style.small, .large], id: \.self) { style in
            VStack(spacing: 10) {
                ForEach([0, 0.25, 0.5, 0.75, 1], id: \.self) { value in
                    ObjectAttributeIndicator(value: value, style: style)
                }
            }
        }
    }
    .padding(50)
    .background {
        Color.mineral.ignoresSafeArea()
    }
}
