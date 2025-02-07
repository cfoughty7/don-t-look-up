//
//  ObjectDetailViewModel.swift
//  don't look up
//
//  Created by Carter Foughty on 2/5/25.
//

import Combine
import SwiftUI
import Service

@MainActor
class ObjectDetailViewModel: ObservableObject {
    
    // MARK: - API
    
    /// Models the approach of an object, whether the close approach
    /// is upcoming or in the past.
    enum Approach {
        case future(String)
        case past(String)
        
        /// The text associated with the approach
        var text: String {
            switch self {
            case let .future(string): string
            case let .past(string): string
            }
        }
    }
    
    /// The time text for the object approach
    @Published private(set) var approachTimeText: Approach = .future("")
    /// The text for the object approach time accessibility label
    @Published private(set) var approachTimeAccessibilityLabel: String = ""
    /// The color to use for the time text of the approach
    @Published private(set) var approachTimeColor: Color = .readout
    
    /// The object diameter text
    let diameterText: String
    /// The object diameter normalized against all other objects
    let normalizedDiameter: Double
    /// The size category of the diameter
    let diameterCategory: DiameterCategory
    /// The text for the diameter accessibility label
    let diameterAccessibilityLabel: String
    
    /// The object velocity text
    let relativeVelocityText: String
    /// The object velocity normalized against all other objects
    let normalizedRelativeVelocity: Double
    /// The velocity category of the velocity
    let relativeVelocityCategory: VelocityCategory
    /// The text for the velocity accessibility label
    let relativeVelocityAccessibilityLabel: String
    
    /// The miss distance text
    let missDistanceText: String
    /// The miss distance unit text
    let missDistanceLabelText: String
    /// The object miss distance normalized against all other objects
    let normalizedMissDistance: Double
    /// The text for the miss distance accessibility label
    let missDistanceAccessibilityLabel: String
    
    init(object: NearEarthObject) {
        self.object = object
        self.diameterText = object.estimatedDiameter.formatted(.number.precision(.fractionLength(2)))
        self.normalizedDiameter = object.normalizedDiameter
        let diameterCategory = DiameterCategory(normalizedValue: object.normalizedDiameter)
        self.diameterCategory = diameterCategory
        self.diameterAccessibilityLabel = "The object is \(diameterCategory.text.lowercased()) at an estimated diameter of \(diameterText) meters."
        self.relativeVelocityText = object.relativeVelocity.formatted(.number.precision(.fractionLength(2)))
        self.normalizedRelativeVelocity = object.normalizedRelativeVelocity
        let relativeVelocityCategory = VelocityCategory(normalizedValue: object.normalizedRelativeVelocity)
        self.relativeVelocityCategory = relativeVelocityCategory
        self.relativeVelocityAccessibilityLabel = "The object is moving at a relatively \(relativeVelocityCategory.text.lowercased()) speed at \(relativeVelocityText) kilometers per second."
        self.normalizedMissDistance = object.normalizedMissDistance
        
        // Rather than recalculate this in a computed property, just capture
        // these values now. Because miss distances are large, we want to
        // represent them in thousands/millions of kilometers.
        let thousand = 1_000.0
        let million = 1_000_000.0
        let missDistance = object.missDistance / 1000
        
        let missDistanceText: String
        let missDistanceUnit: String
        if missDistance >= million {
            missDistanceText = String(format: "%.1f", missDistance / million)
            missDistanceUnit = "MILLION KILOMETERS"
        } else if missDistance >= thousand {
            missDistanceText = String(format: "%.1f", missDistance / thousand)
            missDistanceUnit = "THOUSAND KILOMETERS"
        } else {
            missDistanceText = String(format: "%.1f", missDistance / thousand)
            missDistanceUnit = "KILOMETERS"
        }
        
        self.missDistanceAccessibilityLabel = "The object will miss the Earth by \(missDistanceText) \(missDistanceUnit)"
        self.missDistanceText = missDistanceText
        self.missDistanceLabelText = missDistanceUnit
        
        calculateTimeRemaining()
        installTimer()
    }
    
    // MARK: - Constants
    
    /// The size category of an asteroid
    enum DiameterCategory {
        case small
        case medium
        case large
        
        init(normalizedValue: Double) {
            if normalizedValue < 0.33 {
                self = .small
            } else if normalizedValue < 0.66 {
                self = .medium
            } else {
                self = .large
            }
        }
        
        /// The text representation of the size category
        var text: String {
            switch self {
            case .small: "SMALL"
            case .medium: "MEDIUM"
            case .large: "LARGE"
            }
        }
        
        /// The SceneKit model to use
        var model: Model {
            switch self {
            case .small: .asteroidSmall
            case .medium: .asteroidMedium
            case .large: .asteroidLarge
            }
        }
    }
    
    /// The speed category of an asteroid
    enum VelocityCategory {
        case slow
        case medium
        case fast
        
        init(normalizedValue: Double) {
            if normalizedValue < 0.33 {
                self = .slow
            } else if normalizedValue < 0.66 {
                self = .medium
            } else {
                self = .fast
            }
        }
        
        /// The text representation of the speed category
        var text: String {
            switch self {
            case .slow: "SLOW"
            case .medium: "MODERATE"
            case .fast: "FAST"
            }
        }
    }
    
    // MARK: - Variables
    
    private let object: NearEarthObject
    private var timer: Timer?
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Helpers
    
    /// Installs a timer which publishes every second to calculate the time remaining until close approach
    private func installTimer() {
        Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in
                self?.calculateTimeRemaining()
            }
            .store(in: &cancellables)
    }
    
    /// Calculates the time remaining text
    private func calculateTimeRemaining() {
        let timeRemaining = max(object.closeApproachDate.timeIntervalSinceNow, 0)
        if timeRemaining <= 0 {
            timer?.invalidate()
            approachTimeText = .past(timeAgoString(from: object.closeApproachDate))
            approachTimeColor = .readout
            approachTimeAccessibilityLabel = "The object passed Earth \(approachTimeText)"
        } else {
            approachTimeText = .future(formattedTime(from: timeRemaining))
            approachTimeAccessibilityLabel = "The object will pass Earth in \(approachTimeText.text)"
            approachTimeColor = {
                if timeRemaining < 60 * 60 {
                    // If less than an hour remaining, use the impact color
                    .impact
                } else if timeRemaining < 24 * 60 * 60 {
                    // If less than a day remaining, use the warning color
                    .warning
                } else {
                    .readout
                }
            }()
        }
    }
    
    /// Provides the time remaining formatted in this way: `12:30:02`
    private func formattedTime(from timeInterval: TimeInterval) -> String {
        let totalSeconds = Int(timeInterval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    /// Provides the time passed since close approach rounded to large units.
    /// Ex. `NOW`, `1 MIN`, `1 DAY`, `3 MONTHS`
    private func timeAgoString(from date: Date) -> String {
        let now = Date()
        let diff = Calendar.current.dateComponents(
            [.minute, .hour, .day, .month, .year],
            from: date,
            to: now
        )
        
        let units: [(Int?, String)] = [
            (diff.year, "YEAR"),
            (diff.month, "MONTH"),
            (diff.day, "DAY"),
            (diff.hour, "HOUR"),
            (diff.minute, "MIN")
        ]
        
        for (value, unit) in units {
            if let value = value, value > 0 {
                return "\(value) \(unit)\(value == 1 ? "" : "S") AGO"
            }
        }
        
        return "NOW"
    }
}
