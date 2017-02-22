//
//  EditProfileVC.swift
//  Trail Lab
//
//  Created by Nika on 2/21/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Firebase

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameTF: UITextField!

    @IBOutlet weak var lastNameTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstName = firstNameDefoults.object(forKey: firstNameDefoults_Key)
        let lastName = lastNameDefoults.object(forKey: lastNameDefoults_Key)
        if firstName != nil && lastName != nil {
            nameTF.text = (firstName as! String).capitalized
            lastNameTF.text = (lastName as! String).capitalized
        }
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.layer.borderWidth = 0.5
        profileImageView.clipsToBounds = true
        
          if let savedImgData = profilePictureDefoults.object(forKey: "image") as? NSData
        {
            if let image = UIImage(data: savedImgData as Data)
            {
                profileImageView.image = image
            } else {
                profileImageView.image = UIImage(named:"img-default")
            }
        }

    }
    
    
    
    //MARK: -Camera / Add Picture
    func addPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        let alertController = UIAlertController(title: "Edit Photo", message: "", preferredStyle: .actionSheet)
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) {
            (action: UIAlertAction) in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        let camera = UIAlertAction(title: "Camera", style: .default)
        {
            (action: UIAlertAction) in
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) {
            (action: UIAlertAction) in
            print("User Action Has Canceld")
        }
        
        let delete = UIAlertAction(title: "Delete Image", style: .default) {
            (action: UIAlertAction) in
            let alertController = UIAlertController(title: "Delete?", message: "do you want to delete profile picture", preferredStyle: .alert)

            let delete = UIAlertAction(title: "Delete", style: .default) {
                (action: UIAlertAction) in
                profilePictureDefoults.set(nil, forKey: "image")
                profilePictureDefoults.synchronize()
                self.profileImageView.image = UIImage(named:"img-default")
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .default) {
                (action: UIAlertAction) in
                print("User Action Has Canceld")
            }
            
            alertController.addAction(cancel)
            alertController.addAction(delete)
            self.present(alertController, animated: true, completion: nil)
        }
        
        alertController.addAction(camera)
        alertController.addAction(photoLibrary)
        alertController.addAction(delete)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //print(info.debugDescription)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let imageData = UIImageJPEGRepresentation(image, 1)
            profilePictureDefoults.set(imageData, forKey: "image")
            profilePictureDefoults.synchronize()
            
            profileImageView.image = image
            
        } else {
            print("Somthing went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
    

    

    @IBAction func editProfilePictureHit(_ sender: UIButton) {
        addPhoto()
    }
    
    @IBAction func signOutHit(_ sender: UIButton) {
        
        keepMeLogedInDefoultsDefoults.set(false, forKey: keepMeLogedInDefoults_key)
        keepMeLogedInDefoultsDefoults.synchronize()
        
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }

    }
    
    
    @IBAction func doneHit(_ sender: UIButton) {
        if nameTF.text != "" && lastNameTF.text != "" {
            
            firstNameDefoults.set(nameTF.text, forKey: firstNameDefoults_Key)
            firstNameDefoults.synchronize()
            lastNameDefoults.set(lastNameTF.text, forKey: lastNameDefoults_Key)
            lastNameDefoults.synchronize()
            
        let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        present(profileView, animated: false, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Please provide Full Name", message: "", preferredStyle: .actionSheet)
            
            let ok = UIAlertAction(title: "OK", style: .default) {
                (action: UIAlertAction) in
                print("User Pressed OK")
            }
            
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

