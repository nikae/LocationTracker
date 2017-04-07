//
//  CountDownVC.swift
//  Trail Lab
//
//  Created by Nika on 1/20/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

class CountDownVC: UIViewController {

    var timerCount = 3
    var timerRunning = false
      
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        timerLabel.text = ""
        if timerCount == 0 {
            timerRunning = false
        }
       
        startCountDown()
    }
    
//MARK: -Figure out Count method
    func Counting() {
        if timerCount > 0 {
            timerLabel.text = "\(timerCount)"
            timerCount -= 1
        } else {
            timerLabel.text = "GO!"
        }
    }
    
 func startCountDown() {
    if timerRunning == false {
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CountDownVC.Counting), userInfo: nil, repeats: true)
        timerRunning = true
    }
}
    
}
