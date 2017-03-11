//
//  CellOutletFromProfileVC.swift
//  Trail Lab
//
//  Created by Nika on 3/10/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit

class CellOutletFromProfileVC: UIViewController {
    
    var arr: [Trail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(arr)
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
    @IBAction func removeNoNeedData(_ sender: UIButton) {
        arr.removeAll()
        print("Arr IS EMPTY NOW \(arr)")
    }

  
}
