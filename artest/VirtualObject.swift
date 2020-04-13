//
//  VirtualObject.swift
//  artest
//
//  Created by Mac on 11.04.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import SceneKit

class VirtualObject: SCNReferenceNode {
    
    static let availableObjects: [SCNReferenceNode] = {
        guard let modelsURLs = Bundle.main.url(forResource: "art.scnassets", withExtension: nil) else { return [] }
        let fileEnumerator = FileManager().enumerator(at: modelsURLs, includingPropertiesForKeys: nil)
        return fileEnumerator!.compactMap({ (element) -> SCNReferenceNode? in
            let url = element as! URL
            guard url.pathExtension == "scn" else { return nil }
            return VirtualObject(url: url)
        })
        
    }()
    
}
