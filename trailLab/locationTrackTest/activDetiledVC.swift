//
//  activDetiledVC.swift
//  Trail Lab
//
//  Created by Nika on 3/15/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

class activDetiledVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
    }

    @IBAction func doneHit(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }

}
