//
//  RadarDivider.swift
//  don't look up
//
//  Created by Carter Foughty on 2/3/25.
//

import SwiftUI
import Service
import UI

/// A divider `View` that displays a visualization of near earth objects and their proximity to Earth
struct RadarDivider: View {
    
    // MARK: - API
    
    /// Creates an instance of a `RadarDivider` with the `NearEarthObject` items as visual elements
    init(nearEarthObjects: [NearEarthObject]?) {
        self.displayLoading = nearEarthObjects == nil
        self.objects = nearEarthObjects?.map { object in
            Object(
                id: object.id,
                risk: object.risk,
                size: object.size,
                missDistance: object.missDistance
            )
        }
    }
    
    // MARK: - Constants
    
    /// A model with the data needed to represent objects on the 'radar' view.
    @MainActor
    private struct Object: Hashable {
        var id: String
        var risk: NearEarthObject.Risk
        var size: NearEarthObject.Size
        var missDistance: Double
        
        /// The diameter that the view representation of the object should use
        var diameter: CGFloat {
            switch size {
            case .large: RadarDivider.objectMaxHeight
            case .med: RadarDivider.objectMaxHeight - 2
            case .small: RadarDivider.objectMaxHeight - 4
            }
        }
        
        /// The `Color` to use for the object
        var color: Color {
            switch risk {
            case .low: .readout
            case .med: .warning
            case .high: .impact
            }
        }
        
        /// The z index to apply to the objects. Those with smaller
        /// diameters will appear above those with larger.
        var zIndex: Double {
            switch size {
            case .large: 1
            case .med: 2
            case .small: 3
            }
        }
    }
    
    /// The amplitude to use for the 'loading' pulse
    private let pulseAmplitude: Double = 11
    /// The width to use for the 'loading' pulse
    private let pulseWidth: Double = 10
    /// The width of the dividing line
    private let lineWidth: Double = 1
    
    /// The width of the Earth pill
    private let earthPillWidth: CGFloat = 50
    /// The maximum height to use for objects
    private static let objectMaxHeight: CGFloat = 8
    /// The edge inset to use from the line to the objects
    private let objectEdgeInset: CGFloat = 30
    
    // MARK: - Variables
    
    /// The current phase of the 'loading' pulse
    @State private var phase: Double = -0.5
    /// The width of the view
    @State private var viewWidth: CGFloat = .zero
    /// The position of objects represented on the divider
    @State private var objectPositions: [String: CGFloat] = [:]
    
    /// Indicates whether the view should show a loading state
    private let displayLoading: Bool
    /// An array of the objects to display on the divider. This value is nil when loading
    private let objects: [Object]?
    
    /// The width of the area that objects can be placed along the divider
    private var objectAreaWidth: CGFloat {
        viewWidth - (objectEdgeInset * 3) - earthPillWidth - (Self.objectMaxHeight / 2)
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if displayLoading {
                // If loading, show the pulse line.
                PulseLine(
                    peakX: phase,
                    amplitude: pulseAmplitude,
                    width: pulseWidth,
                    lineWidth: lineWidth
                )
                .stroke(Color.readout, lineWidth: 1)
                .onAppear {
                    // Repeatedly animate the phase of the pulse.
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                        phase = 1.5
                    }
                }
            } else {
                // Otherwise, show a line with overlays for the objects.
                ZStack {
                    Line()
                        .stroke(Color.readout, lineWidth: 1)
                        .overlay(alignment: .bottomLeading) {
                            ForEach(objects ?? [], id: \.self) { object in
                                Circle()
                                    .fill(object.color)
                                    .frame(width: object.diameter)
                                    .zIndex(object.zIndex)
                                    // Apply an object position offset
                                    .offset(x: objectPosition(id: object.id))
                                    .id(object.id)
                            }
                            .frame(width: Self.objectMaxHeight, height: Self.objectMaxHeight)
                            // An additional y offset to account for the
                            // line being bottom aligned.
                            .offset(x: 0, y: Self.objectMaxHeight / 2)
                        }
                        .overlay(alignment: .bottomTrailing) {
                            // A simple representation of Earth.
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.earth)
                                .frame(width: earthPillWidth, height: Self.objectMaxHeight)
                                .offset(x: -objectEdgeInset, y: Self.objectMaxHeight / 2)
                        }
                }
            }
        }
        // Apply an animation to the object positions so they slide in.
        .animation(.snappy, value: objectPositions)
        .frame(maxWidth: .infinity)
        .onSizeChange { size in
            viewWidth = size.width
        }
        .onChange(of: objects, initial: true) { _, newValue in
            guard let newValue,
                  let minDistance = newValue.min(by: { first, second in
                      first.missDistance <= second.missDistance
                  })?.missDistance,
                  let maxDistance = newValue.max(by: { first, second in
                      first.missDistance <= second.missDistance
                  })?.missDistance else {
                objectPositions.removeAll()
                return
            }
            
            let distanceDifference = maxDistance - minDistance
            
            // When objects are updated, calculate their normalized position on the
            // line relative to all of the other objects. Update their position in
            // the dictionary.
            Task { @MainActor in
                for object in newValue {
                    let normalizedPosition = (object.missDistance - minDistance) / distanceDifference
                    let position = objectAreaWidth - (objectAreaWidth * normalizedPosition)
                    
                    objectPositions[object.id] = position
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    /// Provides the position for an object representation
    private func objectPosition(id: String) -> CGFloat {
        guard let position = objectPositions[id] else {
            // If there is none, set a value that will ensure
            // they begin offscreen and animate in.
            return -(objectEdgeInset + 10)
        }
        return position + objectEdgeInset
    }
}

/// A horizontal line shape
fileprivate struct Line: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}

/// A line shape with a single upward pulse
fileprivate struct PulseLine: Shape {
    
    // MARK: - API
    
    init(peakX: Double, amplitude: Double, width: Double, lineWidth: Double) {
        self.peakX = peakX
        self.amplitude = amplitude
        self.width = width
        self.lineWidth = lineWidth
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    /// The normalized x position of the peak of the pulse (0 to 1)
    var peakX: Double
    /// The height of the peak
    let amplitude: Double
    /// The width of the pulse
    let width: Double
    /// The line width
    let lineWidth: Double
    
    /// Implementing this allows for the `peakX` value to adopt animation contexts and animate smoothly
    var animatableData: Double {
        get { peakX }
        set { peakX = newValue }
    }
    
    // MARK: - Path
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // The baseline
        let bottomY = rect.height - (lineWidth / 2)
        path.move(to: CGPoint(x: 0, y: bottomY))
        // Convert the normalized peakX to the actual position
        let peakXPosition = rect.width * peakX
        
        for x in stride(from: 0.0, through: rect.width, by: 1.0) {
            // An equation which produces a single pulse similar to an EKG
            let invertedY = amplitude * exp(-pow(x - peakXPosition, 2) / (2 * pow(width, 2)))
            // Subtract the calculated value so that the pulse moves upward
            let y = bottomY - invertedY
            
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return path
    }
    
    // MARK: - Helpers
}

#Preview {
    RadarDivider(nearEarthObjects: nil)
    RadarDivider(nearEarthObjects: [])
    RadarDivider(nearEarthObjects: [.mock1, .mock2, .mock3, .mock4])
}
