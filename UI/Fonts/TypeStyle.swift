//
//  TypeStyle.swift
//  UI
//
//  Created by Carter Foughty on 2/4/25.
//

import SwiftUI

/// A type that represents a fully defined `Font` instance to be used when presenting text in the UI.
/// This type specifies the custom font to use, and other text attributes like the font size.
@MainActor
public struct TypeStyle {
    
    // MARK: - API
    
    /// The `Font` representation of the `TypeStyle`
    public var font: Font {
        return Font.custom(name, size: size)
    }
    
    /// Creates an instance of a `TypeStyle`
    /// - Parameter font: The custom font to use
    /// - Parameter size: The font size
    init(font: Fonts, size: CGFloat) {
        self.name = font.rawValue
        self.size = size
        font.register()
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    /// The custom font's name
    private let name: String
    /// The font size
    private let size: CGFloat
    
    // MARK: - Helpers
}

public extension TypeStyle {
    
    /// A `Font` with the huge type style.
    static let huge: Font = {
        TypeStyle(font: .josefinSansSemibold, size: 28).font
    }()
    
    /// A `Font` with the title type style.
    static let title: Font = {
        TypeStyle(font: .josefinSansSemibold, size: 20).font
    }()
    
    /// A `Font` with the headline type style.
    static let headline: Font = {
        TypeStyle(font: .josefinSansSemibold, size: 15).font
    }()
    
    /// A `Font` with the body type style.
    static let body: Font = {
        TypeStyle(font: .josefinSansSemibold, size: 17).font
    }()
    
    /// A `Font` with the callout type style.
    static let callout: Font = {
        TypeStyle(font: .josefinSansRegular, size: 13).font
    }()
}
