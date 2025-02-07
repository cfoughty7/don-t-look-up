//
//  WelcomeView.swift
//  don't look up
//
//  Created by Carter Foughty on 2/7/25.
//

import SwiftUI
import UI

struct WelcomeView: View {
    
    // MARK: - API
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    @AppStorage(hasOnboardedKey) private var hasOnboarded = false
    /// The state for a rotation and opacity transition when the asteroid image appears
    @State private var effectFactor: CGFloat = 0.7
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 54) {
                VStack(spacing: 30) {
                    HugeText("DON'T LOOK UP")
                        .accessibilityHidden(true)
                    
                    Image.asteroid
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                        .scaleEffect(effectFactor)
                        .opacity(effectFactor)
                }
                .padding(.bottom, 44)
                
                HeadlineText("Keep a watchful eye on the space rocks that almost hit Earth. NASA calls them ‘Near-Earth Objects.’ We call them ‘Close-Enough-for-Concern-Objects’.")
                
                HeadlineText("Are you in danger? Probably not.\nShould you stay informed? Absolutely.\nRemember...it’s only a problem if it lands.")
                
                Spacer(minLength: 0)
            }
            .lineSpacing(12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(30)
            // Set a max width constraint for iPad layouts
            .frame(maxWidth: 550)
            .animation(.spring(), value: effectFactor)
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(Color.readout)
        .multilineTextAlignment(.center)
        .scrollBounceBehavior(.basedOnSize)
        .background {
            Color.cosmos.ignoresSafeArea()
        }
        .safeAreaInset(edge: .bottom) {
            PrimaryButton("PROCEED") {
                hasOnboarded = true
            }
            .accessibilityHint("Continues into the app.")
            .padding(.bottom, 20)
        }
        .onAppear {
            // On appear, apply the animated state change.
            effectFactor = 1
        }
    }
    
    // MARK: - Helpers
}
