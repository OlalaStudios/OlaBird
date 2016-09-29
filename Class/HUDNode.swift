//
//  HUDNode.swift
//  Hitme
//
//  Created by Olala on 8/18/16.
//  Copyright © 2016 Olala. All rights reserved.
//

import Foundation
import SpriteKit

let TIME:Double  = 30

class HUDNode: SKNode {

    var scoreNode:SKLabelNode!
    var timeNode:SKLabelNode!
    
    var score:Int = 0
    var highScore:Int = 0
    var timer:Double = TIME
    var size:CGSize = CGSizeZero
    
    override init() {
        super.init()
    }
    
    init(size:CGSize){
        super.init()
        
        highScore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        
        self.size = size
        createHUD()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createHUD(){
        
        scoreNode = SKLabelNode.init(text: "\(score)")
        scoreNode.name = "score"
        scoreNode.fontSize = 32
        scoreNode.fontName = "ChalkboardSE-Bold"
        scoreNode.fontColor = UIColor.tealColor()
        scoreNode.position = CGPoint(x: scoreNode.frame.size.width/2 + 10, y:size.height - scoreNode.frame.size.height - 10)
        
        self.addChild(scoreNode)
        
        timeNode = SKLabelNode.init(text: "\(30)")
        timeNode.name = "score"
        timeNode.fontSize = 42
        timeNode.fontName = "ChalkboardSE-Bold"
        timeNode.fontColor = UIColor.tealColor()
        timeNode.position = CGPoint(x: size.width/2, y:size.height - timeNode.frame.size.height - 10)
        
        self.addChild(timeNode)
    }
    
    func updateScore(sco:Int){

        score = score + sco
        
        scoreNode.text = "\(score)"
        scoreNode.position = CGPoint(x: scoreNode.frame.size.width/2 + 10, y:size.height - scoreNode.frame.size.height - 10)
    }
    
    func CountTimer(time:Int) -> Void {
        timer = timer + Double(time)
        
        if timer > TIME {
            timer = TIME
        }
        
        timeNode.text = NSString(format: "%d", Int(timer)) as String
        timeNode.position = CGPoint(x: size.width/2, y:size.height - timeNode.frame.size.height - 10)
    }
    
    func updateTimer(t:NSTimeInterval){
        timer = timer - t
        
        if timer <= 0 {
            timer = 0
        }
        
        timeNode.text = NSString(format: "%d", Int(timer)) as String
        timeNode.position = CGPoint(x: size.width/2, y:size.height - timeNode.frame.size.height - 10)
    }
    
    func gameOver() -> Void {

        //show score view
        if highScore < score {
            highScore = score
            NSUserDefaults.standardUserDefaults().setInteger(highScore, forKey: "highscore")
        }
        
        scoreNode.text = "\(score)"
        scoreNode.position = CGPoint(x: scoreNode.frame.size.width/2 + 10, y:size.height - scoreNode.frame.size.height - 10)
        
        timeNode.text = NSString(format: "%d", Int(timer)) as String
        timeNode.position = CGPoint(x: size.width/2, y:size.height - timeNode.frame.size.height - 10)
    }
    
    func replay() -> Void {
        score = 0
        timer = TIME
        
        updateScore(0)
    }
}
