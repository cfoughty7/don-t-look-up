//
//  StrokedGrid.swift
//  UI
//
//  Created by Carter Foughty on 2/6/25.
//

import SwiftUI

/// Creates a stroked grid pattern view
public struct StrokedGrid<Stroke: ShapeStyle>: View {
    
    // MARK: - API
    
    /// Creates an instance of a `StrokedGrid`
    ///
    /// - Parameter stroke: The stroke style to use
    /// - Parameter rectSize: The size of the grid rects
    /// - Parameter lineWidth: The line width to use for strokes
    public init(stroke: Stroke, rectSize: CGFloat, lineWidth: CGFloat) {
        self.stroke = stroke
        self.rectSize = rectSize
        self.lineWidth = lineWidth
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    private let stroke: Stroke
    private let rectSize: CGFloat
    private let lineWidth: CGFloat
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            let width: CGFloat = geometry.size.width
            let height: CGFloat = geometry.size.height
            // Calculate the number of rows and columns needed to fill the space, rounding up
            let columns: CGFloat = ceil(width / rectSize)
            let rows: CGFloat = ceil(height / rectSize)
            
            // Based on the number of rows and columns, calculate offsets
            // such that the grid is centered in both directions.
            let horizontalOffset: CGFloat = ((columns * rectSize) - width) / CGFloat(2)
            let verticalOffset: CGFloat = ((rows * rectSize) - height) / CGFloat(2)
            
            Path { path in
                for x in stride(from: -horizontalOffset, to: width, by: rectSize) {
                    path.move(to: CGPoint(x: x, y: -verticalOffset))
                    path.addLine(to: CGPoint(x: x, y: height))
                }
                for y in stride(from: -verticalOffset, to: height, by: rectSize) {
                    path.move(to: CGPoint(x: -horizontalOffset, y: y))
                    path.addLine(to: CGPoint(x: width, y: y))
                }
            }
            .stroke(stroke, lineWidth: lineWidth)
        }
    }
    
    // MARK: - Helpers
}
