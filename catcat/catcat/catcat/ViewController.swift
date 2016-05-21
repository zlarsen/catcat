//
//  ViewController.swift
//  catcat
//
//  Created by Zach Larsen on 5/20/16.
//  Copyright © 2016 Zach Larsen. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var shakenSoundEffect = AVAudioPlayer()
    
    @IBOutlet var catSkin: UIImageView!
    
    
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
            } catch {
                // couldn't load file :(
            }
//            if shakenSoundEffect != nil {
//                shakenSoundEffect.stop()
//                shakenSoundEffect = nil
//            }
        }
    }

}

