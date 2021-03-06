//
//  Plane.swift
//  artest
//
//  Created by Mac on 11.04.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import SceneKit
import ARKit

class Plane: SCNNode {
    
    var anchor: ARPlaneAnchor!
    var planeGeometry: SCNPlane!
    
    init(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        super.init()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x),
                                      height: CGFloat(anchor.extent.z))
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named:"pinkWeb.png")
        self.planeGeometry.materials = [material]
        self.geometry = planeGeometry
        
        let shape = SCNPhysicsShape(geometry: self.geometry!, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        self.physicsBody?.categoryBitMask = BitMaskCategory.plane
        self.physicsBody?.collisionBitMask = BitMaskCategory.box
        self.physicsBody?.contactTestBitMask = BitMaskCategory.box
        
        self.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        self.transform = SCNMatrix4MakeRotation(Float(-Double.pi/2), 1.0, 0.0, 0.0)
    }
    
    func update(anchor: ARPlaneAnchor) {
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)
        self.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
    }
}
