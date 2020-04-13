//
//  ViewController.swift
//  artest
//
//  Created by Mac on 11.04.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var planes = [Plane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        //sceneView.autoenablesDefaultLighting = true
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.scene.physicsWorld.contactDelegate = self
        setupGestures()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func setupGestures() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(placeVirtualObject(tap:)))
        self.sceneView.addGestureRecognizer(doubleTap)
    }
    
    @objc func placeVirtualObject(tap: UITapGestureRecognizer) {
        self.sceneView.scene.removeAllParticleSystems()
        let sceneView = tap.view as! ARSCNView
        let location = tap.location(in: sceneView)
        let results = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        guard let result = results.first else { return }
        createVirtualObject(hitResult: result)
    }
    
    func createVirtualObject(hitResult: ARHitTestResult) {
        let position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                  hitResult.worldTransform.columns.3.y,
                                  hitResult.worldTransform.columns.3.z)
        guard let virtualObject = VirtualObject.availableObjects.first else { return }
        
        virtualObject.load()
        virtualObject.position = position
        
        sceneView.scene.rootNode.addChildNode(virtualObject)
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        guard anchor is ARPlaneAnchor else { return }
//        let plane = Plane(anchor: anchor as! ARPlaneAnchor)
//        self.planes.append(plane)
//        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        let plane = self.planes.filter { (plane) -> Bool in
            return plane.anchor.identifier == anchor.identifier
        }.first
        guard let plane1 = plane else { return }
        plane1.update(anchor: anchor as! ARPlaneAnchor)
    }
}

extension ViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        if nodeA.physicsBody?.categoryBitMask == BitMaskCategory.box {
            nodeA.geometry?.materials.first?.diffuse.contents = UIColor.red
            return
        }
        nodeB.geometry?.materials.first?.diffuse.contents = UIColor.red
    }
}
