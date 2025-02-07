//
//  TrajectoryView.swift
//  don't look up
//
//  Created by Carter Foughty on 2/7/25.
//

import SwiftUI

/// A view that shows a consistent trajectory arc combined with a representation
/// of the object on the trajectory and Earth. This is not made to be an accurate
/// representation of the position of the object.
struct TrajectoryView: View {
    
    // MARK: - API
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    @State private var isPulsing = false
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            let start = CGPoint(x: 0, y: 0)
            let end = CGPoint(x: width, y: height)
            let control = CGPoint(x: width / 1.3, y: height / 6)
            
            ZStack {
                Path { path in
                    path.move(to: start)
                    path.addQuadCurve(to: end, control: control)
                }
                .stroke(Color.readout, lineWidth: 0.5)
                
                // Calculate the highlighted point on the curve
                let highlightedPoint = quadraticBezier(
                    t: 0.5,
                    start: start,
                    control: control,
                    end: end
                )
                
                // A representation of Earth
                ZStack {
                    Circle()
                        .fill(Color.earth)
                        .frame(width: 34, height: 34)
                    
                    Circle()
                        .stroke(Color.earth, lineWidth: 2)
                        .frame(width: 46, height: 46)
                }
                .position(x: width / 3, y: height / 1.5)
                
                // The highlighted point on the trajectory arc
                ZStack {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.warning)
                        .frame(width: 10, height: 10)
                        .rotationEffect(.degrees(45))
                    
                    Circle()
                        .stroke(Color.warning, lineWidth: 1)
                        .frame(width: 20, height: 20)
                        // These few modifiers combine to create a
                        // repeating grow and fade pulsing animation.
                        .scaleEffect(isPulsing ? 1.5 : 1.0)
                        .opacity(isPulsing ? 0.5 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1.2)
                                .repeatForever(autoreverses: true),
                            value: isPulsing
                        )
                        .onAppear {
                            isPulsing = true
                        }
                }
                .position(highlightedPoint)
            }
        }
    }
    
    /// Computes a point on a quadratic Bezier curve at a given t value.
    /// I was aided in figuring this out by this StackOverflow post...
    /// https://stackoverflow.com/questions/5634460/quadratic-b%C3%A9zier-curve-calculate-points
    private func quadraticBezier(
        t: CGFloat,
        start: CGPoint,
        control: CGPoint,
        end: CGPoint
    ) -> CGPoint {
        let x = (1 - t) * (1 - t) * start.x + 2 * (1 - t) * t * control.x + t * t * end.x
        let y = (1 - t) * (1 - t) * start.y + 2 * (1 - t) * t * control.y + t * t * end.y
        return CGPoint(x: x, y: y)
    }
}

#Preview {
    TrajectoryView()
}
