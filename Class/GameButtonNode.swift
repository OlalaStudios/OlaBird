//
//  GameButtonNode.swift
//  Hitme
//
//  Created by Olala on 8/17/16.
//  Copyright © 2016 Olala. All rights reserved.
//

import SpriteKit

enum MoveState:Int {
    case None = 0
    case Right
    case Left
}

enum ButtonType:Int {
    case Unknow = 0
    case Left
    case Right
    case Up
    case Play
    case Replay
    case Share
}

protocol ButtonClickDelegate {
    func didClickButton(type:ButtonType)
    func didEndClickButton(type:ButtonType)
}

class GameButtonNode: SKSpriteNode {
    
    var type:ButtonType = ButtonType.Unknow
    
    var delegate:ButtonClickDelegate! = nil
    
    init(image:String ,type:ButtonType ,delegate:ButtonClickDelegate){
        
        let texture:SKTexture = SKTexture(imageNamed: image)
        
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        
        self.type = type
        self.delegate = delegate
        self.userInteractionEnabled = true
        self.alpha = 1
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (delegate != nil) {
            delegate.didClickButton(type)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if delegate != nil {
            delegate.didClickButton(type)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if delegate != nil {
            delegate.didEndClickButton(type)
        }
    }
    
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        print("motion began")
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        print("motion end")
    }
    
    override func updateUserActivityState(activity: NSUserActivity) {
        
    }
}
