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

    var achievementNames: [String] = ["Achievements", "Shaken Not Stirred", "Don't shake me", "Internal Slushie", "Dead Cat", "Fed Cat", "Over Fed Cat", "Fat Cat", "Garfield", "Stinky", "Smelly", "Rotten Eggs", "Outhouse", "Purrfect", "Kitten Be Better", "Sleep Kitty", "WOW 1000?!!" ]
    var achievementValues: [String] = ["", "shake 1", "shake 10", "shake 100", "shake 1000", "feed 1", "feed 10", "feed 100", "feed 1000", "bathroom 1",  "bathroom 10",  "bathroom 100",  "bathroom 1000", "pet 1", "pet 10", "pet 100", "pet 1000" ]
    var doneAchievements: [Int] = []
    
    let counters = NSUserDefaults.standardUserDefaults()
    var shakenCount : Int = 0
    var petCount : Int = 0
    var feedCount : Int = 0
    var bathroomCount : Int = 0

    
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
        
        
        shakenCount = initializeCounters("shakenCount")
        petCount = initializeCounters("petCount")
        bathroomCount = initializeCounters("bathroomCount")
        feedCount = initializeCounters("feedCount")
        
        parseAchievementValues()
        achievementsTable.reloadData()
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
    
    func setupAchievementsTable(row: Int) {
        achievementsTable.beginUpdates()
//        tableView(achievementsTable, cellForRowAtIndexPath: NSIndexPath)
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
    
    func parseAchievementValues() {
        var count = 0
        for value in achievementValues {
            count += 1
            if (value == "") {
                continue
            }
            let valueArr = value.characters.split{$0 == " "}.map(String.init)
            let action = valueArr[0]
            let req = Int(valueArr[1])
            if (action == "shake") {
                if (req <= shakenCount) {
                    doneAchievements.append(count-1)
                }
            } else if (action == "pet") {
                if (req <= petCount) {
                    doneAchievements.append(count-1)
                }
            } else if (action == "feed") {
                if (req <= feedCount) {
                    doneAchievements.append(count-1)
                }
            } else if (action == "bathroom") {
                if (req <= bathroomCount) {
                    doneAchievements.append(count-1)
                }
            }
        }
        
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
}
