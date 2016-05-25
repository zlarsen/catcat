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
        }
    }
    
    func tapRecognizer(taps: Int){
        if (taps == 1) {
            // feed
            print("one hop")
            playSound(catSounds["feed"]!)
            feedCount += 1
            counters.setValue(feedCount, forKey: "feedCount")
    
        }   else if (taps == 2) {
            // bathroom
            print("two hops this time")
            playSound(catSounds["bathroom"]!)
            bathroomCount += 1
            counters.setValue(bathroomCount, forKey: "bathroomCount")
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
}

