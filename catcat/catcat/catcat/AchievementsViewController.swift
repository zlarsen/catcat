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

extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var last: String {
        return String(characters.suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercaseString + String(characters.dropFirst())
    }
}

class AchievementsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var achievementNames: [String] = []
    var achievementValues: [String] = []
    var doneAchievements: [Int] = []
    
    let counters = NSUserDefaults.standardUserDefaults()
    var shakenCount : Int = 0
    var petCount : Int = 0
    var feedCount : Int = 0
    var bathroomCount : Int = 0

    
    @IBOutlet var achievementsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(AchievementsViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(AchievementsViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        self.achievementsTable.tableFooterView = UIView()
        
        shakenCount = initializeCounters("shakenCount")
        petCount = initializeCounters("petCount")
        bathroomCount = initializeCounters("bathroomCount")
        feedCount = initializeCounters("feedCount")
        
        let dA = initializeStoredArrays("doneAchievements") as! [Int]
        if (dA.count >= doneAchievements.count) {
            doneAchievements = dA
        }
        let aV = initializeStoredArrays("achievementValues") as! [String]
        if (aV.count >= achievementValues.count) {
            achievementValues = aV
        }
        let aN = initializeStoredArrays("achievementNames") as! [String]
        if (aN.count >= achievementNames.count) {
            achievementNames = aN
        }
    
        achievementsTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            cell.textLabel?.font = UIFont.boldSystemFontOfSize(22.0)
        } else {
            if (doneAchievements.contains(indexPath.row)) {
                let item = achievementNames[indexPath.row]
                cell.textLabel?.text = item
                cell.textLabel?.textAlignment = NSTextAlignment.Center
                cell.backgroundColor = UIColor(netHex:0x22A5D3)
                cell.textLabel?.textColor = UIColor.whiteColor()
                cell.textLabel?.font = UIFont.boldSystemFontOfSize(20.0)
            } else {
                let item = "?"
                cell.textLabel?.text = item
                cell.textLabel?.textAlignment = NSTextAlignment.Center
                cell.backgroundColor = UIColor.grayColor()
                cell.textLabel?.textColor = UIColor.whiteColor()
//              print("row: \(indexPath.row), title: \(cell.textLabel!.text!)")
            }
        }
        if(cell.respondsToSelector(Selector("setLayoutMargins:"))){
            cell.layoutMargins = UIEdgeInsetsZero
        }
        return cell
    }

    func initializeCounters(name: String) -> Int {
        let countVal = counters.integerForKey(name)
        if (countVal == 0){
            counters.setInteger(0, forKey: name)
            print("\(name): \(countVal)")
        } else {
            print("\(name): \(countVal)")
        }
        return countVal
    }
    
    func initializeStoredArrays(name: String) -> Array <AnyObject> {
        var val: [AnyObject] = []
        if counters.arrayForKey(name) != nil {
            val = counters.arrayForKey(name)!
            print("\(name) count: \(val.count)")
        } else {
            if (name == "achievementValues") {
                counters.setObject(achievementValues, forKey: name)
            } else if (name == "achievementNames") {
                counters.setObject(achievementNames, forKey: name)
            } else if (name == "doneAchievements") {
                counters.setObject(doneAchievements, forKey: name)
            }
            print("The array never assigned")
        }
        return val
    }
}
