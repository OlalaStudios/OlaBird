//
//  ShareScore.swift
//  Hitme
//
//  Created by Olala on 9/15/16.
//  Copyright © 2016 Olala. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Social {
    
    func shareScore(scene: SKScene) {
        let postText: String = "This's funny game.Check out my score and let try it!"
        let downloadlink:String = "https://itunes.apple.com/vn/app/ola-bird/id1150735486?l=en&mt=8#"
        
        let postImage: UIImage = getScreenshot(scene)
        let activityItems = [postText, postImage,downloadlink]
        
        
        let activityController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        
        activityController.popoverPresentationController?.sourceView = scene.view
        
        let controller: UIViewController = scene.view!.window!.rootViewController!
        
        controller.presentViewController(
            activityController,
            animated: true,
            completion: nil
        )
    }

    func getScreenshot(scene: SKScene) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions((scene.view?.bounds.size)!, false, 1)
        
        scene.view?.drawViewHierarchyInRect((scene.view?.bounds)!, afterScreenUpdates: true)
        
        let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshotImage;
    }
}
