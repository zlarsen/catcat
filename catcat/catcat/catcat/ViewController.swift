//
//  ViewController.swift
//  catcat
//
//  Created by Zach Larsen on 5/20/16.
//  Copyright © 2016 Zach Larsen. All rights reserved.
//

import UIKit
import AVFoundation

enum PetDirection : Int {
    case Up = 1
    case Down = 2
    case Right = 3
    case Left = 4
    
}

class ViewController: UIViewController {

    var shakenSoundEffect = AVAudioPlayer()
    var shakenCount = 0
    
    @IBOutlet var catSkin: UIImageView!
    
    
    @IBAction func petUp(sender: UISwipeGestureRecognizer) {
        petCat(String(PetDirection.Up))
    }
    @IBAction func petDown(sender: UISwipeGestureRecognizer) {
        petCat(String(PetDirection.Down))
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
            let path = NSBundle.mainBundle().pathForResource("Cat-hissing-sound-2.mp3", ofType:nil)!
            let url = NSURL(fileURLWithPath: path)
            do {
                let sound = try AVAudioPlayer(contentsOfURL: url)
                shakenSoundEffect = sound
                sound.play()
                shakenCount += 1
            } catch {
                // couldn't load file :(
            }
//            if shakenSoundEffect != nil {
//                shakenSoundEffect.stop()
//                shakenSoundEffect = nil
//            }
        }
    }
    
    func petCat(direction: String) {
        if (direction == "Up") {
            print(PetDirection.Up)
        } else if (direction == "Down") {
            print(PetDirection.Down)
        }
        let path = NSBundle.mainBundle().pathForResource("Cat-meow-sound-2.mp3", ofType:nil)!
        let url = NSURL(fileURLWithPath: path)
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            shakenSoundEffect = sound
            sound.play()
            shakenCount += 1
        } catch {
            // couldn't load file :(
        }
    }

}

