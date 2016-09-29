//
//  CommonDefine.swift
//  Hitme
//
//  Created by Olala on 8/17/16.
//  Copyright © 2016 Olala. All rights reserved.
//

import Foundation
import SpriteKit

let BIRD_1       = "bird_1"
let BIRD_3       = "bird_3"
let BIRD_END     = "bird_end"

enum GameState:Int {
    case Unknow = 0
    case Ready
    case Playing
    case GameOver
}

enum CategoryBitMask:UInt32 {
    case Unknow     = 0
    case Bird       = 1
    case Ground1    = 2
    case Ground2    = 4
    case Ground3    = 8
    case Ground4    = 16
    case Hand       = 32
    case BirdDead   = 64
}

enum GroundLayer:CGFloat {
    case Unknow = 0
    case Background
    case Birdground1
    case Treeground1
    case Birdground2
    case Treeground2
    case Birdground3
    case Treeground3
    case Handground
    case Topground
}

public func arc4random <T: IntegerLiteralConvertible> (type: T.Type) -> T{
    
    var r: T = 0
    arc4random_buf(&r, Int(sizeof(T)))
    
    return r
}

public extension Int{
    public static func random(min min: Int , max: Int) -> Int{
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
}

public extension Float{
    public static func random(min min: Float, max: Float) -> Float{
        let r32 = Float(arc4random(UInt32)) / Float(UInt32.max)
        return (r32 * (max - min)) + min
    }
}

public extension Double{
    public static func random(min min: Double, max: Double) -> Double{
        let r64 = Double(arc4random(UInt64)) / Double(UInt64.max)
        return (r64 * (max - min)) + min
    }
}

let UIColorList:[UIColor] = [
    UIColor.blackColor(),
    UIColor.whiteColor(),
    UIColor.redColor(),
    UIColor.limeColor(),
    UIColor.blueColor(),
    UIColor.yellowColor(),
    UIColor.cyanColor(),
    UIColor.silverColor(),
    UIColor.grayColor(),
    UIColor.maroonColor(),
    UIColor.oliveColor(),
    UIColor.brownColor(),
    UIColor.greenColor(),
    UIColor.lightGrayColor(),
    UIColor.magentaColor(),
    UIColor.orangeColor(),
    UIColor.purpleColor(),
    UIColor.tealColor()
]

public extension UIColor {
    
    public static func random() -> UIColor {
        let maxValue = UIColorList.count
        let rand = Int(arc4random_uniform(UInt32(maxValue)))
        return UIColorList[rand]
    }
    
    public static func limeColor() -> UIColor {
        return UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
    }
    
    public static func silverColor() -> UIColor {
        return UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1.0)
    }
    
    public static func maroonColor() -> UIColor {
        return UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    
    public static func oliveColor() -> UIColor {
        return UIColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 1.0)
    }
    
    public static func tealColor() -> UIColor {
        return UIColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 1.0)
    }
    
    public static func navyColor() -> UIColor {
        return UIColor(red: 0.0, green: 0.0, blue: 128, alpha: 1.0)
    }
    
    public static func darkSlateGray() -> UIColor{
        return UIColor(red: 82/255, green: 139/255, blue: 139/255, alpha: 1.0)
    }
}
