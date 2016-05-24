//
//  AchievementsViewController.swift
//  catcat
//
//  Created by Zach Larsen on 5/22/16.
//  Copyright © 2016 Zach Larsen. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class AchievementsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var achievementNames: [String] = ["Achievements", "Shaken Not Stirred", "Don't shake me"]
    var achievementValues: [String] = ["", "shake 1", "shake 10"]
    
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
        parseAchievementValues()
        
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
        if (indexPath.row == 0) {
            let item = achievementNames[indexPath.row]
            cell.textLabel?.text = item
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            cell.backgroundColor = UIColor.whiteColor()
            cell.textLabel?.textColor = UIColor(netHex:0x22A5D3)
            cell.textLabel?.font = UIFont.boldSystemFontOfSize(20.0)
        } else {
            let item = "?"
            cell.textLabel?.text = item
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            cell.backgroundColor = UIColor.grayColor()
            cell.textLabel?.textColor = UIColor.whiteColor()
//            print("row: \(indexPath.row), title: \(cell.textLabel!.text!)")
        }
        if(cell.respondsToSelector(Selector("setLayoutMargins:"))){
            cell.layoutMargins = UIEdgeInsetsZero
        }
        return cell
    }
    
    func parseAchievementValues() {
        for value in achievementValues {
            if (value == "") {
                continue
            }
            let valueArr = value.characters.split{$0 == " "}.map(String.init)
            print("\(valueArr[0])")
            print("\(valueArr[1])")
        }
    }
}