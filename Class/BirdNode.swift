//
//  BirdNode.swift
//  Hitme
//
//  Created by Olala on 8/17/16.
//  Copyright © 2016 Olala. All rights reserved.
//

import SpriteKit

enum BirdType:Int {
    case Unknow = 0
    case Bird_1_Second
    case Bird_3_Second
    case Bird_End
}

class BirdNode: SKSpriteNode {
    
    var birdType:BirdType = BirdType.Unknow
    
    init(image:String , type:BirdType){
        
        let texture:SKTexture = SKTexture(imageNamed: image)
        
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        
        self.birdType = type
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
    }
    
}
