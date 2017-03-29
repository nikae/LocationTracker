//
//  FullImageVC.swift
//  Trail Lab
//
//  Created by Nika on 3/21/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

class FullImageVC: UIViewController {
    
    var arrADVC: [Trail] = []
    var vcId: String!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var butt: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if arrADVC.count > 0 {
        let url = arrADVC[0].pictureURL
        getImage(url!, imageView: imageView)
        }
        
        buttShape(but: butt, color: bikeColor())
        buttonShedow(but: butt)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        let dest = segue.destination as! CellOutletFromProfileVC
        dest.arr = arrADVC
        dest.vcId = vcId
    }
    
    @IBAction func doneHit(_ sender: Any) {
        self.performSegue(withIdentifier: "backFromImage", sender: self)
        arrADVC.removeAll()
    }

}
