//
//  FilterVC.swift
//  Trail Lab
//
//  Created by Nika on 3/22/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import AVFoundation


class FilterVC: UIViewController {
    
    var viewID = ""
    
    //Distance:
    @IBOutlet weak var btn_50: UIButton!
    @IBOutlet weak var btn_100: UIButton!
    @IBOutlet weak var btn_200: UIButton!
    //Activity Type:
    @IBOutlet weak var walkBtn: UIButton!
    @IBOutlet weak var runBtn: UIButton!
    @IBOutlet weak var hikeBtn: UIButton!
    @IBOutlet weak var bikeBtn: UIButton!
    //Difficulty:
    @IBOutlet weak var easyBtn: UIButton!
    @IBOutlet weak var mediumBtn: UIButton!
    @IBOutlet weak var hardBtn: UIButton!
    //Suitability:
    @IBOutlet weak var kidFriendlyBtn: UIButton!
    @IBOutlet weak var dogFriendlyBtn: UIButton!
    @IBOutlet weak var weelchairFriendlyBtn: UIButton!
    //What to see:
    @IBOutlet weak var ViewsButt: UIButton!
    @IBOutlet weak var beachButton: UIButton!
    @IBOutlet weak var riverButton: UIButton!
    @IBOutlet weak var caveButton: UIButton!
    @IBOutlet weak var lakeButton: UIButton!
    @IBOutlet weak var waterFallButton: UIButton!
    @IBOutlet weak var hotSpringsButton: UIButton!
    //Done:
    @IBOutlet weak var doneBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttShape(but: btn_50, color: walkColor())
        buttShape(but: btn_100, color: bikeColor())
        buttShape(but: btn_200, color: runColor())

        buttShape(but: walkBtn, color: walkColor())
        buttShape(but: runBtn, color: runColor())
        buttShape(but: hikeBtn, color: hikeColor())
        buttShape(but: bikeBtn, color: bikeColor())
        
        buttShape(but: easyBtn, color: runColor())
        buttShape(but: mediumBtn, color: walkColor())
        buttShape(but: hardBtn, color: hikeColor())
        
        buttShape(but: kidFriendlyBtn, color: bikeColor())
        buttShape(but: dogFriendlyBtn, color: hikeColor())
        buttShape(but: weelchairFriendlyBtn, color: runColor())
        
        buttShape(but: ViewsButt, color: runColor())
        buttShape(but: beachButton, color: bikeColor())
        buttShape(but: riverButton, color: walkColor())
        buttShape(but: caveButton, color: hikeColor())
        buttShape(but: lakeButton, color: bikeColor())
        buttShape(but: waterFallButton, color: runColor())
        buttShape(but: hotSpringsButton, color: walkColor())
        
        buttShape(but: doneBtn, color: bikeColor())
        
        
    }
    
      
    var filteArayOfDifficulty: [String] = []
    var filterArrayOfSuitability: [String] = []
    var filterArrayOfWhatToSee: [String] = []
    var filterArrayOfctivityTypes: [String] = []
    var distanceToShoveTrails: [String] = []

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
            } else if sender.tag == 21 || sender.tag == 22 || sender.tag == 23 {
                distanceToShoveTrails.append(num)
                print(distanceToShoveTrails)
                filterDistance()
            } else {
                filterArrayOfWhatToSee.append(num)
                print(filterArrayOfWhatToSee)
            }
            
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
                
            } else if sender.tag == 21 || sender.tag == 22 || sender.tag == 23 {
                if let index = distanceToShoveTrails.index(of: num) {
                distanceToShoveTrails.remove(at: index)
                print(distanceToShoveTrails)
                    filterDistance()
                }
            }
            else {
                if let index = filterArrayOfWhatToSee.index(of: num) {
                    filterArrayOfWhatToSee.remove(at: index)
                    print(filterArrayOfWhatToSee)
                }
            }
            
            
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
    

    var launch50: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launch50, button: btn_50, array: distanceToShoveTrails)
        }
    }
    var launch100: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launch100, button: btn_100, array: distanceToShoveTrails)
        }
    }
    var launch200: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launch200, button: btn_200, array: distanceToShoveTrails)
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
    var launchViews: Bool = false {
        didSet{
            makeBoolForLaunch(bool: launchViews, button: ViewsButt, array: arrayOfWhatToSee)
        }
    }
    var launchBeach: Bool = false {
        didSet{
            makeBoolForLaunch(bool: launchBeach, button: beachButton, array: arrayOfWhatToSee)
        }
    }
    var launchRiver: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchRiver, button: riverButton, array: arrayOfWhatToSee)
        }
    }
    var launchCave: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchCave, button: caveButton, array: arrayOfWhatToSee)
        }
    }
    var launchLake: Bool = false {
        didSet{
            makeBoolForLaunch(bool: launchLake, button: lakeButton, array: arrayOfWhatToSee)
        }
    }
    var launchWaterFall: Bool = false {
        didSet {
            makeBoolForLaunch(bool:launchWaterFall, button: waterFallButton, array: arrayOfWhatToSee)
        }
    }
    var launchHotSprings: Bool = false {
        didSet {
            makeBoolForLaunch(bool: launchHotSprings, button: hotSpringsButton, array: arrayOfWhatToSee)
        }
    }
    
    
    
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
        } else if sender.tag == 31 {
            launchViews = !launchViews
        } else if sender.tag == 32 {
            launchBeach = !launchBeach
        } else if sender.tag == 33 {
            launchRiver = !launchRiver
        } else if sender.tag == 34 {
            launchCave = !launchCave
        } else if sender.tag == 35 {
            launchLake = !launchLake
        } else if sender.tag == 36 {
            launchWaterFall = !launchWaterFall
        } else if sender.tag == 37 {
            launchHotSprings = !launchHotSprings
        } else if sender.tag == 21 {
            launch50 = !launch50
        } else if sender.tag == 22 {
            launch100 = !launch100
        } else if sender.tag == 23 {
            launch200 = !launch200
    }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func filterDistance() {
        let radius: Double!
        if distanceToShoveTrails != [] {
            var distanceIntArr: [Double] = []
            for i in distanceToShoveTrails {
                distanceIntArr.append(Double(i)!)
            }
            radius = distanceIntArr.max()
        } else {
            radius = 0.5
        }
        if coordinate₁ != nil {
            if trails.count > 0 {
                trails.removeAll()
            }
            preloadTrails(loc: coordinate₁!, radius: radius!)
        }

    }
    
    
    @IBAction func doneHit(_ sender: UIButton) {
        if viewID == "TracksMapVC" {
        self.performSegue(withIdentifier: "backToMapFromFilter", sender: self)
        } else if viewID == "TracksVC" {
            self.performSegue(withIdentifier: "backToTrailsFromFilter", sender: self)
        }
        
        for i in filterArrayOfctivityTypes {
                    for cnt in (0...trails.count - 1)  {
                        if trails[cnt].activityType != i {
                       // trails.remove(at: cnt)
                        print(trails[cnt].activityType)
                        
                }
            }
        }
        
       
        
    }
       

}
