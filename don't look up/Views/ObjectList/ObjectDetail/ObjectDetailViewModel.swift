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
    /// The color to use for the time text of the approach
    @Published private(set) var approachTimeColor: Color = .readout
    
    /// The object diameter text
    let diameterText: String
    /// The object diameter normalized against all other objects
    let normalizedDiameter: Double
    /// The size category of the diameter
    let diameterCategory: Category
    
    /// The object velocity text
    let relativeVelocityText: String
    /// The object velocity normalized against all other objects
    let normalizedRelativeVelocity: Double
    /// The velocity category of the velocity
    let relativeVelocityCategory: Category
    
    /// The miss distance text
    let missDistanceText: String
    /// The miss distance unit text
    let missDistanceLabelText: String
    /// The object miss distance normalized against all other objects
    let normalizedMissDistance: Double
    
    init(object: NearEarthObject) {
        self.object = object
        self.diameterText = object.estimatedDiameter.formatted(.number.precision(.fractionLength(2)))
        self.normalizedDiameter = object.normalizedDiameter
        self.diameterCategory = Category(normalizedValue: object.normalizedDiameter)
        self.relativeVelocityText = object.relativeVelocity.formatted(.number.precision(.fractionLength(2)))
        self.normalizedRelativeVelocity = object.normalizedRelativeVelocity
        self.relativeVelocityCategory = Category(normalizedValue: object.normalizedRelativeVelocity)
        self.normalizedMissDistance = object.normalizedMissDistance
        
        // Rather than recalculate this in a computed property, just capture
        // these values now. Because miss distances are large, we want to
        // represent them in thousands/millions of kilometers.
        let thousand = 1_000.0
        let million = 1_000_000.0
        let missDistance = object.missDistance / 1000
        
        if missDistance >= million {
            self.missDistanceText = String(format: "%.1f", missDistance / million)
            self.missDistanceLabelText = "MILLION KILOMETERS"
        } else if missDistance >= thousand {
            self.missDistanceText = String(format: "%.1f", missDistance / thousand)
            self.missDistanceLabelText = "THOUSAND KILOMETERS"
        } else {
            self.missDistanceText = String(format: "%.1f", missDistance / thousand)
            self.missDistanceLabelText = "KILOMETERS"
        }
        
        calculateTimeRemaining()
        installTimer()
    }
    
    // MARK: - Constants
    
    /// The size category of an asteroid
    enum Category {
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
        } else {
            approachTimeText = .future(formattedTime(from: timeRemaining))
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
