//
//  AchievementsViewController.swift
//  catcat
//
//  Created by Zach Larsen on 5/22/16.
//  Copyright © 2016 Zach Larsen. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var achievementNames: [String] = ["Shaken Not Stirred", "Don't shake me"]
    var achievementValues: [String] = ["shake 1", "shake 10"]
    
    @IBOutlet var achievementsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(AchievementsViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(AchievementsViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        self.achievementsTable.tableFooterView = UIView()
        
//        setupAchievementsTable()
        
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
    
    func setupAchievementsTable() {
        achievementsTable.beginUpdates()
        print("*******************2")
        achievementsTable.insertRowsAtIndexPaths([
            NSIndexPath(forRow: achievementNames.count-1, inSection: 0)
            ], withRowAnimation: .Automatic)
        print("*******************3")
        achievementsTable.endUpdates()
        print("hello")
    }
    
    func numberOfSectionsInTableView(achievementsTable: UITableView) -> Int {
        return 1
    }
    
    func tableView(achievementsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievementNames.count
    }
    
    func tableView(achievementsTable: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = achievementsTable.dequeueReusableCellWithIdentifier("cell",
        forIndexPath: indexPath)
        let item = achievementNames[indexPath.row]
        cell.textLabel?.text = item
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        cell.textLabel?.textColor = UIColor.whiteColor()
        print("row: \(indexPath.row), title: \(cell.textLabel!.text!)")
        return cell
    }
}