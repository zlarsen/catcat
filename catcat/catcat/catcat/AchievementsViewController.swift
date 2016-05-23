//
//  AchievementsViewController.swift
//  catcat
//
//  Created by Zach Larsen on 5/22/16.
//  Copyright © 2016 Zach Larsen. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController {

    var achievements: [String: String] = ["shake 1":"Shaken Not Stirred"]
    var newAchievements: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(AchievementsViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(AchievementsViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Left:
                changeToMainViewController()
            case UISwipeGestureRecognizerDirection.Right:
                changeToMainViewController()
            default:
                break
            }
        }
    }
    
    func changeToMainViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let resultViewController = storyBoard.instantiateViewControllerWithIdentifier("cat")
        resultViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.presentViewController(resultViewController, animated:true, completion:nil)
    }
}