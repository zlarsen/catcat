//
//  ViewController.swift
//  catcat
//
//  Created by Zach Larsen on 5/20/16.
//  Copyright © 2016 Zach Larsen. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

enum PetDirection : Int {
    case Up = 1
    case Down = 2
    case Right = 3
    case Left = 4
    
}

var catSounds: [String: String] = ["mad": "CatScream.wav", "pet": "catpurr.wav", "feed": "milk.m4a", "bathroom": "litterbox.wav", "feed2": " ", "pet2": "Cat-meow-short"]

class ViewController: UIViewController {

    var shakenSoundEffect = AVAudioPlayer()
    
    var doneAchievements: [Int] = []
    var achievementNames: [String] = ["Achievements", "Shaken Not Stirred", "Don't Shake Me", "Internal Slushie", "Dead Cat", "Fed Cat", "Over Fed Cat", "Fat Cat", "Garfield", "Stinky", "Smelly", "Rotten Eggs", "Outhouse", "Purrfect", "Kitten Be Better", "Sleep Kitty", "WOW 1000?!!" ]
    var achievementValues: [String] = ["", "shake 1", "shake 10", "shake 100", "shake 1000", "feed 1", "feed 10", "feed 100", "feed 1000", "bathroom 1",  "bathroom 10",  "bathroom 100",  "bathroom 1000", "pet 1", "pet 10", "pet 100", "pet 1000" ]
    
    var shakenCount : Int = 0
    var petCount : Int = 0
    var feedCount : Int = 0
    var bathroomCount : Int = 0
    let counters = NSUserDefaults.standardUserDefaults()
    
    var furUp = false
    
    
    @IBOutlet var catSkin: UIImageView!
    
    
    @IBAction func petUp(sender: UISwipeGestureRecognizer) {
        petCat(String(PetDirection.Up))
    }
    
    @IBAction func petDown(sender: UISwipeGestureRecognizer) {
        petCat(String(PetDirection.Down))
    }
    
    @IBAction func oneTap(sender: AnyObject) {
        tapRecognizer(1)
    }
    
    @IBAction func twoTap(sender: AnyObject) {
        tapRecognizer(2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let aSelector : Selector = #selector(ViewController.oneTap(_:))
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        let bSelector : Selector = #selector(ViewController.twoTap(_:))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: bSelector)
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
        
        tapGesture.requireGestureRecognizerToFail(doubleTapGesture)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
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
        
        parseAchievementValues()
    }
    
    override func viewDidAppear(animated: Bool) {
//        displayAlertView(1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            print("shaken")
            playSound(catSounds["mad"]!)
            
            shakenCount += 1
            counters.setValue(shakenCount, forKey: "shakenCount")
            parseAchievementValues()
        }
    }
    
    func tapRecognizer(taps: Int){
        if (taps == 1) {
            // feed
            print("one hop")
            playSound(catSounds["feed"]!)
            feedCount += 1
            counters.setValue(feedCount, forKey: "feedCount")
            parseAchievementValues()
    
        }   else if (taps == 2) {
            // bathroom
            print("two hops this time")
            playSound(catSounds["bathroom"]!)
            bathroomCount += 1
            counters.setValue(bathroomCount, forKey: "bathroomCount")
            parseAchievementValues()
        }
    }
    
    func petCat(direction: String) {
        if (direction == "Up" && !furUp) {
            print(PetDirection.Up)
            furUp = true
            let toImage = UIImage(named:"goodfurRev.png")
            UIView.transitionWithView(self.catSkin,
                                      duration:0.5,
                                      options: .TransitionCrossDissolve,
                                      animations: { self.catSkin.image = toImage },
                                      completion: nil)
        } else if (direction == "Down" && furUp) {
            print(PetDirection.Down)
            furUp = false
            let toImage = UIImage(named:"goodfur.png")
            UIView.transitionWithView(self.catSkin,
                                      duration:0.5,
                                      options: .TransitionCrossDissolve,
                                      animations: { self.catSkin.image = toImage },
                                      completion: nil)        }
        playSound(catSounds["pet"]!)
        petCount += 1
        counters.setValue(petCount, forKey: "petCount")
        parseAchievementValues()
    }

    func playSound(soundName: String){
        let path = NSBundle.mainBundle().pathForResource(soundName, ofType:nil)!
        let url = NSURL(fileURLWithPath: path)
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            shakenSoundEffect = sound
            sound.play()
        } catch {
            print("Couldn't load \(soundName)")
        }
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Right:
                
                print("Swiped right")
                
                //change view controllers
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let resultViewController = storyBoard.instantiateViewControllerWithIdentifier("achievements")
                resultViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                self.presentViewController(resultViewController, animated:true, completion:nil)
                
                
                
            default:
                break
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
    
    func parseAchievementValues() {
        var count = 0
        for value in achievementValues {
            var valid = false
            count += 1
            if (value == "") {
                continue
            }
            let valueArr = value.characters.split{$0 == " "}.map(String.init)
            let action = valueArr[0]
            let req = Int(valueArr[1])
            if (action == "shake") {
                if (req <= shakenCount) {
                    valid = true
                }
            } else if (action == "pet") {
                if (req <= petCount) {
                    valid = true
                }
            } else if (action == "feed") {
                if (req <= feedCount) {
                    valid = true
                }
            } else if (action == "bathroom") {
                if (req <= bathroomCount) {
                    valid = true
                }
            }
            if (valid == true) {
                if (!doneAchievements.contains(count-1)) {
                    doneAchievements.append(count-1)
                    counters.setObject(doneAchievements, forKey: "doneAchievements")
                    displayAlertView(count-1)
                }
                valid = false
            }
        }
        
    }
    
    func displayAlertView(index: Int) {
        let value = achievementValues[index]
        let valueArr = value.characters.split{$0 == " "}.map(String.init)
        let message = valueArr[0].uppercaseFirst + " x " + valueArr[1]
        let alertController = UIAlertController(title: achievementNames[index], message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

