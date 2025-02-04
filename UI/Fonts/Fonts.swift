//
//  Fonts.swift
//  UI
//
//  Created by Carter Foughty on 2/3/25.
//

import SwiftUI
import UIKit

/// A type that enumerates the custom fonts that can be registered and used.
@MainActor
public enum Fonts: String {
    
    case josefinSansRegular = "JosefinSansRoman-Regular"
    case josefinSansSemibold = "JosefinSansRoman-Semibold"
    
    // MARK: - API
    
    /// Registers the custom font with the system if it hasn't already been registered.
    public func register() {
        // If the font has already been registered, return.
        guard !Self.registeredFonts.contains(fileName) else { return }
        guard let fontURL = BundleToken.bundle.url(
            forResource: fileName,
            withExtension: Self.fileExtension
        ),
              CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil) else {
            // If the font can't be found, crash the app. This is a
            // bundle issue and should be maximally visible.
            fatalError("Failed to register font: \(rawValue)")
        }
        
        // Register the font
        Self.registeredFonts.insert(fileName)
    }
    
    // MARK: - Constants
    
    private static let fileExtension = ".ttf"
    
    // MARK: - Variables
    
    /// A cache of fonts that have been registered. This should be used to
    /// ensure that the same font doesn't get registered more than once.
    private static var registeredFonts = Set<String>()
    
    private var fileName: String {
        switch self {
        case .josefinSansRegular, .josefinSansSemibold: "JosefinSans"
        }
    }
    
    // MARK: - Helpers
}
