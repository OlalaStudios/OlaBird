//
//  HandNode.swift
//  Hitme
//
//  Created by Olala on 8/17/16.
//  Copyright © 2016 Olala. All rights reserved.
//

import SpriteKit

enum HandState:Int {
    case Unknow = 0
    case jumping
}

class HandNode: SKSpriteNode {
    
    var state:HandState = HandState.Unknow
    var velocity:CGVector = CGVector(dx: 0, dy: 0)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
    }
}
