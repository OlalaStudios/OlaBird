//
//  GameScene.swift
//  Hitme
//
//  Created by Olala on 8/16/16.
//  Copyright (c) 2016 Olala. All rights reserved.
//

import AVFoundation
import SpriteKit
import GoogleMobileAds

class GameScene: SKScene,ButtonClickDelegate ,SKPhysicsContactDelegate{
    
    var interstitial:GADInterstitial!
    
    var readyNode:SKNode!
    var gameOverNode:SKNode!
    var handNode:HandNode!
    
    var jumpNode:GameButtonNode!
    var moveLeft:GameButtonNode!
    var moveRight:GameButtonNode!
    
    var BackgroundNode:SKNode!
    var TreegroundNode:SKNode!
    var HudgroundNode:HUDNode!
    
    var pos:CGPoint = CGPointZero
    
    var gamestate:GameState = GameState.Unknow
    var movestate:MoveState = MoveState.None
    
    var yPos1:CGFloat = 0
    var yPos2:CGFloat = 0
    var yPos3:CGFloat = 0
    var yPos4:CGFloat = 80
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = UIColor(red: 109.0/255.0, green: 208.0/255.0, blue: 247.0/255.0, alpha: 0.5)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        self.physicsWorld.speed = 0.65
        
        yPos3 = yPos4 + 40
        yPos2 = yPos3 + 32
        yPos1 = yPos2 + 48
        
        //Google Ads
        createAndLoadInterstitial()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        
        jumpNode = GameButtonNode(image: "hit", type: ButtonType.Up, delegate: self)
        jumpNode.size = CGSizeMake(jumpNode.size.width*1.1, jumpNode.size.height*1.1)
    
        self.addChild(jumpNode)
        
        moveRight = GameButtonNode(image: "MoveRight", type: ButtonType.Right, delegate: self)
        self.addChild(moveRight)
        
        moveLeft = GameButtonNode(image: "MoveLeft", type: ButtonType.Left, delegate: self)
        self.addChild(moveLeft)
        
        createFist()
        createWall()
        
        BackgroundNode = createBackground()
        BackgroundNode.zPosition = GroundLayer.Background.rawValue
        self.addChild(BackgroundNode)
        
        readyNode = createReadyNode()
        readyNode.zPosition = GroundLayer.Topground.rawValue
        self.addChild(readyNode)
        
        TreegroundNode = createTreeground1()
        TreegroundNode.zPosition = GroundLayer.Treeground1.rawValue
        self.addChild(TreegroundNode)
        
        TreegroundNode = createTreeground2()
        TreegroundNode.zPosition = GroundLayer.Treeground2.rawValue
        self.addChild(TreegroundNode)
        
        TreegroundNode = createTreeground3()
        TreegroundNode.zPosition = GroundLayer.Treeground3.rawValue
        self.addChild(TreegroundNode)
        
        HudgroundNode = HUDNode.init(size: self.size)
        HudgroundNode.zPosition = GroundLayer.Topground.rawValue
        self.addChild(HudgroundNode)
        
        jumpNode.position = CGPointMake(self.size.width - jumpNode.size.width/2 - 5, jumpNode.size.height/2 + 5)
        jumpNode.zPosition = GroundLayer.Topground.rawValue
        
        moveLeft.position = CGPointMake(moveLeft.size.width/2, moveLeft.size.height/2)
        moveLeft.zPosition = GroundLayer.Topground.rawValue
        
        moveRight.position = CGPointMake(moveLeft.position.x + moveLeft.size.width/2 + 5 + moveRight.size.width/2, moveRight.size.height/2)
        moveRight.zPosition = GroundLayer.Topground.rawValue
        
        gamestate = GameState.Ready
        self.runAction(SKAction.repeatActionForever(SKAction.playSoundFileNamed("background", waitForCompletion: true)), withKey: "background_music")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
   
    var countdown:NSTimeInterval = 0
    var spawTime1:NSTimeInterval = 0
    var spawTime3:NSTimeInterval = 0
    var spawTimeEnd:NSTimeInterval = 0
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

        if gamestate == GameState.Playing {
            
            if countdown > 0 {
                HudgroundNode.updateTimer(currentTime - countdown)
            }

            countdown = currentTime
            
            if HudgroundNode.timer == 0 {
                gameOver()
            }
            
            if currentTime > spawTime1 {
                
                let bird1time = NSTimeInterval(Float.random(min: 0.8, max: 1.3))
                
                spawTime1 = currentTime + bird1time
                createBird(BirdType.Bird_1_Second)
                
                let waitTime = Double.random(min: 0.5, max: 1)
                spawTime1 = spawTime1 + waitTime
                
                let choosenext = Int.random(min: 1, max: 7)
                switch choosenext {
                case 1:
                    self.performSelector(#selector(GameScene.createBird_1), withObject: nil, afterDelay: waitTime)
                    break
                case 2:
                    self.performSelector(#selector(GameScene.createBird_end), withObject: nil, afterDelay: waitTime)
                    break
                case 3:
                    self.performSelector(#selector(GameScene.createBird_3), withObject: nil, afterDelay: waitTime)
                    break
                case 4:
                    self.performSelector(#selector(GameScene.createBird_end), withObject: nil, afterDelay: waitTime)
                    break
                case 5:
                    self.performSelector(#selector(GameScene.createBird_3), withObject: nil, afterDelay: waitTime)
                    self.performSelector(#selector(GameScene.createBird_end), withObject: nil, afterDelay: waitTime + 0.2)
                    break
                default:
                    self.performSelector(#selector(GameScene.createBird_1), withObject: nil, afterDelay: waitTime)
                    self.performSelector(#selector(GameScene.createBird_end), withObject: nil, afterDelay: waitTime + 0.2)
                    break
                }
            }
        }
        
        let step:CGFloat = (self.size.width)/(74)
        
        if handNode.state != HandState.jumping {
            if movestate == MoveState.Left {
                if handNode.position.x > handNode.size.width/2 {
                    handNode.position.x -= step
                }
            }
            else if movestate == MoveState.Right{
                if handNode.position.x < self.size.width - handNode.size.width/2 {
                    handNode.position.x += step
                }
            }
        }
        
        for child in self.children {
            if child.name == "Bird" {
                if child.position.y < 0 {
                    child.removeFromParent()
                }
            }
        }
    }

//MARK: Create UI
    func createReadyNode() -> SKNode {
        let ready = SKNode()
        
        let readylabel = SKLabelNode(text: "Get Ready!")
        readylabel.color = UIColor.greenColor()
        readylabel.fontName = "ChalkboardSE-Bold"
        readylabel.fontSize = 48
        ready.addChild(readylabel)
        
        readylabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        //score guide
        let plus3 = SKSpriteNode(imageNamed: BIRD_3)
        plus3.position = CGPointMake(plus3.size.width/2, CGRectGetMidY(self.frame))
        
        let plus3label = SKLabelNode(text: "+3s")
        plus3label.fontName = "ChalkboardSE-Regular"
        plus3label.fontSize = 24
        plus3label.position = CGPointMake(plus3.position.x + plus3.size.width/2 + 5 + plus3label.frame.size.width/2, plus3.position.y)
        
        let plus1 = SKSpriteNode(imageNamed: BIRD_1)
        plus1.position = CGPointMake(plus1.size.width/2, plus3.position.y + plus3.size.height + 10)
        
        let plus1label = SKLabelNode(text: "+1s")
        plus1label.fontName = "ChalkboardSE-Regular"
        plus1label.fontSize = 24
        plus1label.position = CGPointMake(plus1.position.x + plus1.size.width/2 + 5 + plus1label.frame.size.width/2, plus1.position.y)
        
        let end = SKSpriteNode(imageNamed: BIRD_END)
        end.position = CGPointMake(end.size.width/2, plus3.position.y - plus3.size.height - 10)
        
        let endlabel = SKLabelNode(text: "game over")
        endlabel.fontName = "ChalkboardSE-Regular"
        endlabel.fontSize = 24
        endlabel.position = CGPointMake(end.position.x + end.size.width/2 + 5 + endlabel.frame.size.width/2, end.position.y)
        
        let playbuttom = GameButtonNode(image: "replay", type: ButtonType.Play, delegate: self)
        playbuttom.position = CGPointMake(self.size.width/2, readylabel.position.y - 20 - playbuttom.size.height/2)
        
        ready.addChild(plus1)
        ready.addChild(plus1label)
        ready.addChild(plus3)
        ready.addChild(plus3label)
        ready.addChild(end)
        ready.addChild(endlabel)
        ready.addChild(playbuttom)
        
        return ready
    }
    
    func createGameOverNode() -> SKNode {
        let over = SKNode()
        
        //label
        let overlabel = SKLabelNode(text: "Game Over!")
        overlabel.color = UIColor.greenColor()
        overlabel.fontName = "ChalkboardSE-Bold"
        overlabel.fontSize = 60
        
        overlabel.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - self.size.height/4)
        over.addChild(overlabel)
        
        //score
        let score = CGPointMake(CGRectGetMidX(self.frame), self.size.height/2)
        
        let scorelabel = SKLabelNode(text: "Your score : \(HudgroundNode.score)")
        scorelabel.color = UIColor.whiteColor()
        scorelabel.fontName = "ChalkboardSE-Bold"
        scorelabel.fontSize = 32
        scorelabel.position = CGPointMake(score.x, score.y)
        scorelabel.zPosition = GroundLayer.Topground.rawValue + 1
        over.addChild(scorelabel)
        
        let highscorelabel = SKLabelNode(text: "High score : \(HudgroundNode.highScore)")
        highscorelabel.color = UIColor.whiteColor()
        highscorelabel.fontName = "ChalkboardSE-Bold"
        highscorelabel.fontSize = 32
        highscorelabel.position = CGPointMake(score.x, score.y - scorelabel.frame.size.height - 5)
        highscorelabel.zPosition = GroundLayer.Topground.rawValue + 1
        over.addChild(highscorelabel)
        
        //replay buttom
       let replay = GameButtonNode(image: "replay", type: ButtonType.Replay, delegate: self)
        replay.position = CGPointMake(score.x - replay.size.width/2 - 10, score.y - highscorelabel.frame.size.height - 10 - replay.size.height/2)
        over.addChild(replay)
        
        //share buttom
        let shareFB = GameButtonNode(image: "Share", type: ButtonType.Share, delegate: self)
        shareFB.position = CGPointMake(score.x + shareFB.size.width/2 + 10, replay.position.y)
        over.addChild(shareFB)
        
        return over
    }
    
    func createWall(){
        
        let ground1 = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(self.size.width*4, 5))
        ground1.position = CGPointMake(self.size.width/2, yPos1 - 30)
        ground1.zPosition = GroundLayer.Background.rawValue
        ground1.physicsBody = SKPhysicsBody(rectangleOfSize: ground1.size)
        ground1.physicsBody?.categoryBitMask = CategoryBitMask.Ground1.rawValue
        ground1.physicsBody?.contactTestBitMask = CategoryBitMask.Bird.rawValue
        ground1.physicsBody?.collisionBitMask = CategoryBitMask.Unknow.rawValue
        ground1.physicsBody?.dynamic = false
        
        let ground2 = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(self.size.width*4, 5))
        ground2.position = CGPointMake(self.size.width/2, yPos2 - 20)
        ground2.zPosition = GroundLayer.Background.rawValue
        ground2.physicsBody = SKPhysicsBody(rectangleOfSize: ground2.size)
        ground2.physicsBody?.categoryBitMask = CategoryBitMask.Ground2.rawValue
        ground2.physicsBody?.contactTestBitMask = CategoryBitMask.Bird.rawValue
        ground2.physicsBody?.collisionBitMask = CategoryBitMask.Unknow.rawValue
        ground2.physicsBody?.dynamic = false
        
        let ground3 = SKSpriteNode(color: UIColor.whiteColor(), size: CGSizeMake(self.size.width*4, 5))
        ground3.position = CGPointMake(self.size.width/2, yPos3)
        ground3.zPosition = GroundLayer.Background.rawValue
        ground3.physicsBody = SKPhysicsBody(rectangleOfSize: ground3.size)
        ground3.physicsBody?.categoryBitMask = CategoryBitMask.Ground3.rawValue
        ground3.physicsBody?.contactTestBitMask = CategoryBitMask.Bird.rawValue
        ground3.physicsBody?.collisionBitMask = CategoryBitMask.Unknow.rawValue
        ground3.physicsBody?.dynamic = false
        
        self.addChild(ground1)
        self.addChild(ground2)
        self.addChild(ground3)
    }
    
    func createBackground()->SKNode{
        let ground = SKNode()
        
        let sky = SKSpriteNode(imageNamed: "sky")
        sky.position = CGPointMake(0, self.size.height - sky.size.height/2)
        sky.zPosition = GroundLayer.Background.rawValue
        ground.addChild(sky)
        
        let grass = SKSpriteNode(imageNamed: "grass")
        grass.position = CGPointMake(self.size.width/2, grass.size.height/2)
        grass.zPosition = sky.zPosition + 1
        ground.addChild(grass)
        
        return ground
    }
    
    func createTreeground1() -> SKNode {
        let ground = SKNode()
        
        let count = Int(self.size.width/64) + 2
        
        for index in 0...count {
            let tree = SKSpriteNode(imageNamed: "Tre128")
            tree.position = CGPoint(x: CGFloat(index)*tree.size.width/2, y: yPos1 - tree.size.height/2)
            
            
            ground.addChild(tree)
        }
        
        return ground
    }
    
    func createTreeground2() -> SKNode {
        let ground = SKNode()
        
        let count = Int(self.size.width/64) + 2
        
        for index in 0...count {
            let tree = SKSpriteNode(imageNamed: "Tre128")
            tree.position = CGPoint(x: CGFloat(index)*tree.size.width/2, y: yPos2 - tree.size.height/2)
            
            ground.addChild(tree)
        }
        
        return ground
    }
    
    func createTreeground3() -> SKNode {
        let ground = SKNode()
        
        let count = Int(self.size.width/64) + 2
        
        for index in 0...count {
            let tree = SKSpriteNode(imageNamed: "Tre128")
            tree.position = CGPoint(x: CGFloat(index)*tree.size.width/2, y: yPos3 - tree.size.height/2)
            
            ground.addChild(tree)
        }
        
        return ground
    }
    
    func createBird_1(){
        createBird(BirdType.Bird_1_Second)
    }
    
    func createBird_3(){
        createBird(BirdType.Bird_3_Second)
    }
    
    func createBird_end(){
        createBird(BirdType.Bird_End)
    }
    
    func createBird(type:BirdType) -> BirdNode {
        
        var texture:String = ""
        var sound:String = ""
        var birdtype:BirdType = BirdType.Unknow
        
        if type == BirdType.Bird_1_Second {
            texture = "bird_1"
            sound = "bird1.wav"
            birdtype = BirdType.Bird_1_Second
        }else if type == BirdType.Bird_3_Second{
            texture = "bird_3"
            sound = "bird3.wav"
            birdtype = BirdType.Bird_3_Second
        }else if type == BirdType.Bird_End{
            texture = "bird_end"
            sound = "birdend.wav"
            birdtype = BirdType.Bird_End
        }
        
        let bird :BirdNode = BirdNode(image: texture, type: birdtype)
        
        bird.name = "Bird"
        bird.size = CGSizeMake(36, 36)
        bird.zPosition = GroundLayer.Topground.rawValue
        
        var x = 0
        var y = 0
        
        //random start line
        var line = Int.random(min: 1, max: 3)
        
        switch line {
        case 1:
            bird.position.y = yPos1 + bird.size.height/2
            
            x = Int.random(min: 18, max: 25)
            y = Int.random(min: 22, max: 28)
            
            break
        case 2:
            bird.position.y = yPos2 + bird.size.height/2
            
            x = Int.random(min: 18, max: 25)
            y = Int.random(min: 30, max: 36)
            
            break
        case 3:
            bird.position.y = yPos3 + bird.size.height/2
            
            x = Int.random(min: 18, max: 25)
            y = Int.random(min: 32, max: 40)
            
            break
        default:
            bird.position.y = yPos1 + bird.size.height/2
            
            x = Int.random(min: 16, max: 20)
            y = Int.random(min: 20, max: 30)
            
            break
        }
        
        if handNode.position.x > 0 && handNode.position.x < self.size.width/4 {
            //1
            bird.position.x = CGFloat(Float.random(min: Float(self.size.width/4), max: Float(self.size.width)))
        }
        else if handNode.position.x > self.size.width/4 && handNode.position.x < self.size.width/2{
            //2
            let side = Int.random(min: 1, max: 3)
            if side == 1 {
                x = -x
                bird.xScale = -1.0
                bird.position.x = CGFloat(Float.random(min: Float(0), max: Float(self.size.width/4)))
            }
            else if side == 2{
                bird.position.x = CGFloat(Float.random(min: Float(self.size.width/2), max: Float(3*self.size.width/4)))
                let direction = Int.random(min: 1, max: 2)
                if direction == 1 {
                    x = -x
                    bird.xScale = -1.0
                }
            }
            else{
                bird.position.x = CGFloat(Float.random(min: Float(3*self.size.width/4), max: Float(self.size.width)))
            }
        }
        else if handNode.position.x > self.size.width/2 && handNode.position.x < 3*self.size.width/4{
            //3
            let side = Int.random(min: 1, max: 3)
            if side == 1 {
                x = -x
                bird.xScale = -1.0
                bird.position.x = CGFloat(Float.random(min: Float(0), max: Float(self.size.width/4)))
            }
            else if side == 2{
                bird.position.x = CGFloat(Float.random(min: Float(self.size.width/2), max: Float(3*self.size.width/4)))
                let direction = Int.random(min: 1, max: 2)
                if direction == 1 {
                    x = -x
                    bird.xScale = -1.0
                }
            }
            else{
                bird.position.x = CGFloat(Float.random(min: Float(3*self.size.width/4), max: Float(self.size.width)))
            }
        }
        else{
            //4
             bird.position.x = CGFloat(Float.random(min: Float(0), max: Float(3*self.size.width/4)))
            x = -x
            bird.xScale = -1.0
        }
        
        bird.physicsBody = SKPhysicsBody(rectangleOfSize: bird.size)
        bird.physicsBody?.categoryBitMask = CategoryBitMask.Bird.rawValue
        bird.physicsBody?.collisionBitMask = CategoryBitMask.Unknow.rawValue
        bird.physicsBody?.dynamic = true
        
        //random end line
        line = Int.random(min: 1, max: 3)
        
        switch line {
        case 1:
            bird.physicsBody?.contactTestBitMask = CategoryBitMask.Ground1.rawValue
            break
        case 2:
            bird.physicsBody?.contactTestBitMask = CategoryBitMask.Ground2.rawValue
            break
        case 3:
            bird.physicsBody?.contactTestBitMask = CategoryBitMask.Ground3.rawValue
            break
        default:
            bird.physicsBody?.contactTestBitMask = CategoryBitMask.Ground2.rawValue
            break
        }
        
        self.addChild(bird)
        bird.runAction(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
        jumpAction(bird,x: CGFloat(-x),y: CGFloat(y))
        
        return bird
    }
    
    func createFist(){
        handNode = HandNode(imageNamed: "boxglove")
        self.addChild(handNode)
        
        handNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        handNode.size = CGSizeMake(handNode.size.width*0.9, handNode.size.height)
        handNode.position = CGPointMake(CGRectGetMidX(self.frame), yPos4 - handNode.size.height/2)
        handNode.zPosition = GroundLayer.Handground.rawValue
        handNode.physicsBody = SKPhysicsBody(rectangleOfSize: handNode.size)
        handNode.physicsBody?.dynamic = false
        handNode.physicsBody?.affectedByGravity = false
        handNode.physicsBody?.categoryBitMask = CategoryBitMask.Hand.rawValue
        handNode.physicsBody?.contactTestBitMask = CategoryBitMask.Bird.rawValue
        handNode.physicsBody?.collisionBitMask = CategoryBitMask.Unknow.rawValue
    }
    
//MARK: Action
    func jumpAction(node:BirdNode ,x:CGFloat ,y:CGFloat){
        
        let jump:SKAction!
        
        jump = SKAction.runBlock {
            node.physicsBody?.applyImpulse(CGVectorMake(x, y))
        }
        
        let sequence = SKAction.sequence([jump])
        
        if node.actionForKey("jump") == nil {
            node.runAction(sequence, withKey: "jump")
        }
    }
    
    func handDown(){
        
        handNode.removeAllActions()
        
        let moveDown = SKAction.moveToY(yPos4 - handNode.size.height/2, duration: 0.3)
        let done = SKAction.runBlock({
            self.handNode.state = HandState.Unknow
            self.handNode.velocity = CGVector(dx: 0, dy: 0)
        })
        
        let sequence = SKAction.sequence([moveDown,done])
        
        if (handNode.actionForKey("beat") == nil) {
            handNode.runAction(sequence, withKey: "beat")
        }
    }
    
    func showScore(score:Int, position:CGPoint){
        let label = SKLabelNode(text: "+\(score)")
        label.fontName = "AppleSDGothicNeo-Bold"
        label.fontSize = 28
        label.fontColor = UIColor.darkSlateGray()
        label.position = position
        label.zPosition = GroundLayer.Topground.rawValue
        self.addChild(label)
        
        let show = SKAction.moveToY(position.y + 40, duration: 0.2)
        let hiden = SKAction.runBlock({
            label.removeFromParent()
        })
        let sequence = SKAction.sequence([show,hiden])
        label.runAction(sequence)
    }
    
    func gameOver(){
        print("GameOver")
        HudgroundNode.gameOver()
        gamestate = GameState.GameOver
        
        gameOverNode = createGameOverNode()
        gameOverNode.name = "gameOver"
        gameOverNode.zPosition = GroundLayer.Topground.rawValue
        self.addChild(gameOverNode)
        
        //Google Ads
        showGoogleAds()
    }
    
    func replay(){
        
        gameOverNode.removeAllActions()
        gameOverNode.removeFromParent()

        for child in self.children {
            if child.name == "gameOver"{
               child.removeFromParent()
            }
        }

        countdown = 0
        
        HudgroundNode.replay()
        gamestate = GameState.Playing
        
        self.createAndLoadInterstitial()
    }
    
    func share() -> Void {
        
        let socialHandler = Social()
        socialHandler.shareScore(self)
        
    }
    
//MARK: delegate
    func didBeginContact(contact: SKPhysicsContact) {
        let mask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        var birdNode:BirdNode!
        
        if contact.bodyA.node?.name == "Bird" {
            birdNode = contact.bodyA.node as! BirdNode
        }else if contact.bodyB.node?.name == "Bird"{
            birdNode = contact.bodyB.node as! BirdNode
        }
        
        switch mask {
        case CategoryBitMask.Hand.rawValue | CategoryBitMask.Bird.rawValue:
            
            let contactPos = convertPoint(contact.contactPoint, toNode: self.scene!)

            if (handNode.position.y < contactPos.y - handNode.size.height/2 + 7)
            {
                
                if birdNode.birdType == BirdType.Bird_1_Second{
                    print("1 second")
                    HudgroundNode.updateScore(1)
                    HudgroundNode.CountTimer(1)
                    showScore(1,position: birdNode.position)
                }else if birdNode.birdType == BirdType.Bird_3_Second{
                    print("3 second")
                    HudgroundNode.updateScore(1)
                    HudgroundNode.CountTimer(3)
                    showScore(3,position: birdNode.position)
                }else if birdNode.birdType == BirdType.Bird_End{
                    gameOver()
                }
                
                birdNode.physicsBody?.velocity = CGVector(dx: 0.0, dy: 150)
                birdNode.physicsBody?.categoryBitMask = CategoryBitMask.BirdDead.rawValue
                
                birdNode.color = UIColor.redColor()
                birdNode.colorBlendFactor = 0.8
                
                let hitaction = SKAction.playSoundFileNamed("beat.wav", waitForCompletion: false)
                let die = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 0.8, duration: 0.5)
                let contactaction = SKAction.sequence([hitaction,die])
                birdNode.runAction(contactaction)
                
                //hand move down
                handDown()
            }

            break
        case CategoryBitMask.Bird.rawValue | CategoryBitMask.Ground1.rawValue:
            
            if birdNode.physicsBody?.contactTestBitMask == CategoryBitMask.Ground1.rawValue {
                if birdNode.physicsBody?.velocity.dy < 0 {
                    birdNode.removeFromParent()
                }
            }
            
            break
        case CategoryBitMask.Bird.rawValue | CategoryBitMask.Ground2.rawValue:
            
            if birdNode.physicsBody?.contactTestBitMask == CategoryBitMask.Ground2.rawValue {
                if birdNode.physicsBody?.velocity.dy < 0 {
                    birdNode.removeFromParent()
                }
            }
            
            break
        case CategoryBitMask.Bird.rawValue | CategoryBitMask.Ground3.rawValue:
            
            if birdNode.physicsBody?.contactTestBitMask == CategoryBitMask.Ground3.rawValue {
                if birdNode.physicsBody?.velocity.dy < 0 {
                    birdNode.removeFromParent()
                }
            }
            
            break
        case CategoryBitMask.Bird.rawValue | CategoryBitMask.Ground4.rawValue:
            
            if birdNode.physicsBody?.contactTestBitMask == CategoryBitMask.Ground4.rawValue {
                if birdNode.physicsBody?.velocity.dy < 0 {
                    birdNode.removeFromParent()
                }
            }
            
            break
        default:
            break
        }
    }
    
//MARK : Buttom Delegate
    func didClickButton(type: ButtonType) {
        
        if type == ButtonType.Left {
            movestate = MoveState.Left
        }else if type == ButtonType.Right{
            movestate = MoveState.Right
        }else if type == ButtonType.Up{
            
            if handNode.state == HandState.Unknow {
                
                handNode.state = HandState.jumping
                
                let addvelocity = SKAction.runBlock({
                    self.handNode.velocity = CGVector(dx: 0, dy: 1.0)
                })
                
                let moveUp = SKAction.moveToY(yPos1 + 100 - handNode.size.height/2, duration: 0.38)
                let moveUpsound = SKAction.playSoundFileNamed("up.wav", waitForCompletion: false)
                
                let removevelocity = SKAction.runBlock({
                    self.handNode.velocity = CGVector(dx: 0, dy: -1.0)
                })
                
                let moveDown = SKAction.moveToY(yPos4 - handNode.size.height/2, duration: 0.3)
                let moveDownsound = SKAction.playSoundFileNamed("down.wav", waitForCompletion: false)
                
                let done = SKAction.runBlock({ 
                    self.handNode.state = HandState.Unknow
                    self.handNode.velocity = CGVector(dx: 0, dy: 0)
                })
                
                let sequence = SKAction.sequence([addvelocity,moveUpsound,moveUp,removevelocity,moveDownsound,moveDown,done])
                
                if (handNode.actionForKey("beat") == nil) {
                    handNode.runAction(sequence, withKey: "beat")
                }
            }
        }
        else if type == ButtonType.Play{
            print("play")
            if gamestate == GameState.Ready {
                gamestate = GameState.Playing

                readyNode.removeFromParent()
            }
        }
        else if type == ButtonType.Replay{
            print("replay")
            replay()
        }
        else if type == ButtonType.Share{
            print("Share")
            share()
        }
    }
    
    func didEndClickButton(type: ButtonType) {
        if type == ButtonType.Left {
            movestate = MoveState.None
        }
        else if type == ButtonType.Right{
            movestate = MoveState.None
        }
    }
    
//MARK : Goole Ads
    //ca-app-pub-4039533744360639/1607553707
    private func createAndLoadInterstitial(){
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-4039533744360639/1607553707")
        let request = GADRequest()

        interstitial.loadRequest(request)
    }
    
    func showGoogleAds(){
        if interstitial.isReady {
            interstitial.presentFromRootViewController((self.view?.window?.rootViewController)!)
        }else{
            print("Ads wasn't ready")
        }
    }
}
