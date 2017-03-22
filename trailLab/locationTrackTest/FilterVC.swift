//
//  FilterVC.swift
//  Trail Lab
//
//  Created by Nika on 3/22/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {
    
    var viewID = ""
    
    //Distance:
    @IBOutlet weak var distanceTF: UITextField!
    
    //Activity Type:
    @IBOutlet weak var allActivityTypeBtn: UIButton!
    @IBOutlet weak var walkBtn: UIButton!
    @IBOutlet weak var runBtn: UIButton!
    @IBOutlet weak var hikeBtn: UIButton!
    @IBOutlet weak var bikeBtn: UIButton!
    //Difficulty:
    @IBOutlet weak var allDifficultyBtn: UIButton!
    @IBOutlet weak var easyBtn: UIButton!
    @IBOutlet weak var mediumBtn: UIButton!
    @IBOutlet weak var hardBtn: UIButton!
    //Suitability:
    @IBOutlet weak var allSuitabilityBtn: UIButton!
    @IBOutlet weak var kidFriendlyBtn: UIButton!
    @IBOutlet weak var dogFriendlyBtn: UIButton!
    @IBOutlet weak var weelchairFriendlyBtn: UIButton!
    //What to see:
    @IBOutlet weak var whatToSeeTF: UITextField!
    //Done:
    @IBOutlet weak var doneBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
buttShape(but: allActivityTypeBtn, color: .gray)
        buttShape(but: walkBtn, color: walkColor())
        buttShape(but: runBtn, color: runColor())
        buttShape(but: hikeBtn, color: hikeColor())
        buttShape(but: bikeBtn, color: bikeColor())
        
        buttShape(but: allDifficultyBtn, color: .gray)
        buttShape(but: easyBtn, color: runColor())
        buttShape(but: mediumBtn, color: runColor())
        buttShape(but: hardBtn, color: runColor())
        
        buttShape(but: allSuitabilityBtn, color: .gray)
        buttShape(but: kidFriendlyBtn, color: hikeColor())
        buttShape(but: dogFriendlyBtn, color: hikeColor())
        buttShape(but: weelchairFriendlyBtn, color: hikeColor())
        
        buttShape(but: doneBtn, color: bikeColor())
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func doneHit(_ sender: UIButton) {
        if viewID == "TracksMapVC" {
        self.performSegue(withIdentifier: "backToMapFromFilter", sender: self)
        } else if viewID == "TracksVC" {
            self.performSegue(withIdentifier: "backToTrailsFromFilter", sender: self)
        }
    }

    

}
