//
//  Box.swift
//  artest
//
//  Created by Mac on 11.04.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import SceneKit
import ARKit

class Box: SCNNode {
    init(position: SCNVector3) {
        super.init()
        let geometry = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        geometry.materials = [material]
        self.geometry = geometry
        
        let shape = SCNPhysicsShape(geometry: geometry, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.categoryBitMask = BitMaskCategory.box
        self.physicsBody?.collisionBitMask = BitMaskCategory.plane | BitMaskCategory.box
        self.physicsBody?.contactTestBitMask = BitMaskCategory.plane
        self.position = position
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
