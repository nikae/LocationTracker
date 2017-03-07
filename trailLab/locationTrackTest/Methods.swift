//
//  Methods.swift
//  Trail Lab
//
//  Created by Nika on 2/7/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import Foundation
import UIKit
import Firebase


struct Trail {
    let userId : String!
    let activityType : String!
    let activityName : String!
    let distance : String
    let locations : AnyObject!
    let time : String!
    let pace : [Int]
    let altitudes : [Double]
    let difficulty : [String]
    let suitability : [String]
    let whatToSee : [String]
    let description : String!
    let pictureURL : String!
}


func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
    
    let newHeight = newWidth
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let imageView: UIImageView = UIImageView(image: newImage)
    // imageView.contentMode = .scaleAspectFill
    var layer: CALayer = CALayer()
    layer = imageView.layer
    layer.borderWidth = 0.9
    layer.borderColor = UIColor.gray.cgColor
    layer.masksToBounds = true
    layer.cornerRadius = CGFloat(newHeight/2)
    
    UIGraphicsBeginImageContext(imageView.bounds.size)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return roundedImage!
}


func getItemImage(item: UITabBarItem) {
    if let savedImgData = profilePictureDefoults.object(forKey: "image") as? NSData
    {
        if let image = UIImage(data: savedImgData as Data)
        {
            item.selectedImage  = resizeImage(image: image, newWidth: 30).withRenderingMode(.alwaysOriginal)
            item.image  = resizeImage(image: image, newWidth: 30).withRenderingMode(.alwaysOriginal)
            
            
        } else {
            item.selectedImage = resizeImage(image: (UIImage(named:"img-default"))!, newWidth: 30).withRenderingMode(.alwaysOriginal)
            item.image  = resizeImage(image: (UIImage(named:"img-default"))!, newWidth: 30).withRenderingMode(.alwaysOriginal)
        }
        
    }
}


func getImage(_ url:String, imageView: UIImageView) {
    var image = UIImage()
    FIRStorage.storage().reference(forURL: url).data(withMaxSize: 10 * 1024 * 1024, completion: { (data, error) in
        if error != nil {
            print(error?.localizedDescription ?? "ERROR")
            image = UIImage(named:"img-default")!
        } else {
            //Dispatch the main thread here
            DispatchQueue.main.async {
                image = UIImage(data: data!)!
                imageView.image = image
            }
        }
    })
}


