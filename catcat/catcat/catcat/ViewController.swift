//
//  ViewController.swift
//  catcat
//
//  Created by Zach Larsen on 5/20/16.
//  Copyright © 2016 Zach Larsen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var shakeLabel: UILabel!
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
            self.shakeLabel.text = "Shaken, not stirred"
        }
    }

}

