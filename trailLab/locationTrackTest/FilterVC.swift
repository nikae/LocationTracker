//
//  FilterVC.swift
//  Trail Lab
//
//  Created by Nika on 3/22/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import AVFoundation


class FilterVC: UIViewController, UITextFieldDelegate {
    
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
        
        distanceTF.delegate = self
        
    }
    
    //MARK -textFiled only takes Int
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Dismiss keyboard Tap
    func keyboardDismiss() {
        distanceTF.resignFirstResponder()
    }

    @IBAction func keyDisTap(_ sender: UITapGestureRecognizer) {
        keyboardDismiss()
    }
    
    var filteArayOfDifficulty: [String] = []
    var filterArrayOfSuitability: [String] = []
    var filterArrayOfWhatToSee: [String] = []
    var filterArrayOfctivityTypes: [String] = []

    func launchBool(sender: UIButton, bool: Bool) {
        
        if bool == true {
            let num = sender.title(for: UIControlState())!
            
            if sender.tag == 11 || sender.tag == 12 || sender.tag == 13 || sender.tag == 14 {
                filterArrayOfctivityTypes.append(num)
                print(filterArrayOfctivityTypes)
                
            } else if sender.tag == 1 || sender.tag == 2 || sender.tag == 3 {
                filteArayOfDifficulty.append(num)
                print(filteArayOfDifficulty)
                
            } else if sender.tag == 4 || sender.tag == 5 || sender.tag == 6 {
                filterArrayOfSuitability.append(num)
                print(filterArrayOfSuitability)
            }
//            else {
//                filterArrayOfWhatToSee.append(num)
//                print(filterArrayOfWhatToSee)
//            }
            
            sender.backgroundColor = sender.backgroundColor?.withAlphaComponent(0.5)
            
            
        } else {
            let num = sender.title(for: UIControlState())!
            
            if sender.tag == 11 || sender.tag == 12 || sender.tag == 13 || sender.tag == 14 {
                if let index = filterArrayOfctivityTypes.index(of: num) {
                    filterArrayOfctivityTypes.remove(at: index)
                    print(filterArrayOfctivityTypes)
                }
                
            } else if sender.tag == 1 || sender.tag == 2 || sender.tag == 3 {
                
                if let index = filteArayOfDifficulty.index(of: num) {
                    filteArayOfDifficulty.remove(at: index)
                    print(filteArayOfDifficulty)
                }
                
            } else if sender.tag == 4 || sender.tag == 5 || sender.tag == 6 {
                if let index = filterArrayOfSuitability.index(of: num) {
                    filterArrayOfSuitability.remove(at: index)
                    print(filterArrayOfSuitability)
                }
                
            }
//            else {
//                if let index = arrayOfWhatToSee.index(of: num) {
//                    arrayOfWhatToSee.remove(at: index)
//                    print(arrayOfWhatToSee)
//                }
//            }
            
            
            sender.backgroundColor = sender.backgroundColor?.withAlphaComponent(1)
            
        }
    }

    
    func makeBoolForLaunch(bool: Bool, button: UIButton, array: [String]){
        if bool == true {
            launchBool(sender: button, bool: true)
            
        } else {
            launchBool(sender: button, bool: false)
        }
    }
    
    var launchWalk: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchWalk, button: walkBtn, array: filterArrayOfctivityTypes)
        }
    }
    var launchRun: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchRun, button: runBtn, array: filterArrayOfctivityTypes)
        }
    }
    var launchHike: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchHike, button: hikeBtn, array: filterArrayOfctivityTypes)
        }
    }
    var launchBike: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchBike, button: bikeBtn, array: filterArrayOfctivityTypes)
        }
    }
    
    var launchEasy: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchEasy, button: easyBtn, array: arrayOfDifficulty)
        }
    }
    var launchMedium: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchMedium, button: mediumBtn, array: arrayOfDifficulty)
        }
    }
    var launchHard: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchHard, button: hardBtn, array: arrayOfDifficulty)
        }
    }
    var launchkidFriendly: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchkidFriendly, button: kidFriendlyBtn, array: arrayOfSuitability)
        }
    }
    var launchDogFriendly: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchDogFriendly, button: dogFriendlyBtn, array: arrayOfSuitability)
        }
    }
    var launchWeelchairFriendly: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchWeelchairFriendly, button: weelchairFriendlyBtn, array: arrayOfSuitability)
        }
    }
//    var launchViews: Bool = false {
//        didSet{
//            makeBoolForLaunch(bool: launchViews, button: ViewsButt, array: arrayOfWhatToSee)
//        }
//    }
//    var launchBeach: Bool = false {
//        didSet{
//            makeBoolForLaunch(bool: launchBeach, button: beachButton, array: arrayOfWhatToSee)
//        }
//    }
//    var launchRiver: Bool = false {
//        didSet {
//            makeBoolForLaunch(bool: launchRiver, button: riverButton, array: arrayOfWhatToSee)
//        }
//    }
//    var launchCave: Bool = false {
//        didSet {
//            makeBoolForLaunch(bool: launchCave, button: caveButton, array: arrayOfWhatToSee)
//        }
//    }
//    var launchLake: Bool = false {
//        didSet{
//            makeBoolForLaunch(bool: launchLake, button: lakeButton, array: arrayOfWhatToSee)
//        }
//    }
//    var launchWaterFall: Bool = false {
//        didSet {
//            makeBoolForLaunch(bool:launchWaterFall, button: waterFallButton, array: arrayOfWhatToSee)
//        }
//    }
//    var launchHotSprings: Bool = false {
//        didSet {
//            makeBoolForLaunch(bool: launchHotSprings, button: hotSpringsButton, array: arrayOfWhatToSee)
//        }
//    }
    
    
    
  @IBAction func whatToSeeHit(_ sender: UIButton) {
    AudioServicesPlaySystemSound (systemSoundID)
    
        if sender.tag == 11 {
        launchWalk = !launchWalk
        } else if sender.tag == 12 {
        launchRun = !launchRun
        } else if sender.tag == 13 {
             launchHike = !launchHike
        } else if sender.tag == 14 {
            launchBike = !launchBike
        }else if sender.tag == 1 {
            launchEasy = !launchEasy
        } else if sender.tag == 2 {
            launchMedium = !launchMedium
        } else if sender.tag == 3 {
            launchHard = !launchHard
        } else if sender.tag == 4 {
            launchkidFriendly = !launchkidFriendly
        } else if sender.tag == 5 {
            launchDogFriendly = !launchDogFriendly
        } else if sender.tag == 6 {
            launchWeelchairFriendly = !launchWeelchairFriendly
        }
//        else if sender.tag == 7 {
//            launchViews = !launchViews
//        }else if sender.tag == 8 {
//            launchBeach = !launchBeach
//        } else if sender.tag == 9 {
//            launchRiver = !launchRiver
//        } else if sender.tag == 10 {
//            launchCave = !launchCave
//        } else if sender.tag == 11 {
//            launchLake = !launchLake
//        } else if sender.tag == 12 {
//            launchWaterFall = !launchWaterFall
//        } else if sender.tag == 13 {
//            launchHotSprings = !launchHotSprings
//        }
    
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
    
    let distanceToLoad = Int(distanceTF.text)
    @IBAction func NEEDSTOBECHANGED(_ sender: UIButton) {
//        if coordinate₁ != nil {
//            if trails.count > 0 {
//                trails.removeAll()
//            }
//            preloadTrails(loc: coordinate₁!, radius: 1000)
//               }
//
    }
    
    
    @IBAction func doneHit(_ sender: UIButton) {
        if viewID == "TracksMapVC" {
        self.performSegue(withIdentifier: "backToMapFromFilter", sender: self)
        } else if viewID == "TracksVC" {
            self.performSegue(withIdentifier: "backToTrailsFromFilter", sender: self)
        }
    }

    

}
