//
//  ObjectRow.swift
//  don't look up
//
//  Created by Carter Foughty on 2/4/25.
//

import SwiftUI
import Service
import UI

struct ObjectRow: View {
    
    // MARK: - API
    
    init(nearEarthObject: NearEarthObject, onTap: @escaping () -> Void) {
        self.nearEarthObject = nearEarthObject
        self.onTap = onTap
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    private let nearEarthObject: NearEarthObject
    private let onTap: () -> Void
    
    // MARK: - Body
    
    /// I prefer to make these kinds of components using buttons rather than using a tap gesture
    /// so that I get access to their native press states and other configuration APIs.
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 14) {
                VStack(alignment: .leading, spacing: 12) {
                    BodyText(nearEarthObject.name)
                    CalloutText("\(nearEarthObject.riskText) DOOMSDAY RISK")
                        .foregroundStyle(nearEarthObject.riskColor)
                }
                .accessibilityElement(children: .combine)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.readout)
                .padding(.top, 14)
                .padding(.bottom, 12)
                
                VStack(spacing: 4) {
                    Circle()
                        .fill(nearEarthObject.riskColor)
                        .frame(width: 14, height: 14)
                        .overlay {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 9, weight: .heavy))
                                .foregroundStyle(Color.mineral)
                        }
                    
                    RoundedRectangle(cornerRadius: 7)
                        .fill(Color.earth)
                        .frame(width: 14)
                }
                .padding(.vertical, 5.5)
            }
            .multilineTextAlignment(.leading)
            .padding(.leading, 14)
            .padding(.trailing, 6)
        }
        .buttonStyle(ObjectRowButtonStyle())
    }
    
    // MARK: - Helpers
}

fileprivate struct ObjectRowButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                RoundedRectangle(cornerRadius: 10)
                    // On press, mix the color 20% with black.
                    .fill(Color.mineral.mix(with: .black, by: configuration.isPressed ? 0.2 : 0))
            }
    }
}

#Preview {
    ObjectRow(nearEarthObject: .mock1) {}
    ObjectRow(nearEarthObject: .mock2) {}
    ObjectRow(nearEarthObject: .mock3) {}
}
