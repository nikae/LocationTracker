//
//  viewSlider.swift
//  Trail Lab
//
//  Created by Nika on 2/9/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import Foundation
import UIKit

//MARK: -View Slider Methods

struct ViewSlider {
    
func moveViewDownOrUp(view: UIView, moveUp: Bool) {
    
    if moveUp == false {
        
        let xPositionOfView = view.frame.origin.x
        //View will slide Npx down
        let yPositionOfView = view.frame.origin.y + 200
        
        let heightOfView = view.frame.size.height
        let widthOfView = view.frame.size.width

        UIView.animate(withDuration: 2.0, animations: {
            view.frame = CGRect(x: xPositionOfView, y: yPositionOfView, width: widthOfView, height: heightOfView)
        })
        
    } else {
        let xPositionOfView = view.frame.origin.x
        //View will slide Npx up
        let yPositionOfView = view.frame.origin.y - 200
        
        
        let heightOfView = view.frame.size.height
        let widthOfView = view.frame.size.width
        
        UIView.animate(withDuration: 1.0, animations: {
            
            view.frame = CGRect(x: xPositionOfView, y: yPositionOfView, width: widthOfView, height: heightOfView)
            
        })
    }
    
}
}

