//
//  SceneKitView.swift
//  don't look up
//
//  Created by Carter Foughty on 2/6/25.
//

import SwiftUI
import UIKit
import SceneKit

/// A `SceneKit` view that displays a user-interactive 3D model.
struct SceneKitView: UIViewRepresentable {
    
    // MARK: - API
    
    /// Creates an instance of a `SceneKitView`
    ///
    /// - Parameter model: The model to display in the view.
    init(model: Model) {
        self.model = model
    }
    
    // MARK: - Constants
    
    // MARK: - Variables
    
    private let model: Model
    
    // MARK: - View
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        let scene = SCNScene(named: model.name)
        
        sceneView.scene = scene
        sceneView.defaultCameraController.interactionMode = .orbitTurntable
        // Disable user interaction
        sceneView.allowsCameraControl = false
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = .clear
        
        if model.autorotate {
            /// Add a slow rotation about the y axis
            let rotation = SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 30)
            let repeatForever = SCNAction.repeatForever(rotation)
            scene?.rootNode.runAction(repeatForever)
        }
        
        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
    
    // MARK: - Helpers
}
