//
//  EditProfileVC.swift
//  Trail Lab
//
//  Created by Nika on 2/21/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Firebase
import Photos


class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    
     var storageRef: FIRStorageReference!
     var databaseRef: FIRDatabaseReference!
     fileprivate var _refHandle: FIRDatabaseHandle!
     var users: [FIRDataSnapshot] = []
     var picURL = ""
     let userID = FIRAuth.auth()?.currentUser?.uid
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTF.delegate = self
        lastNameTF.delegate = self
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.layer.borderWidth = 0.5
        profileImageView.clipsToBounds = true
        databaseRef = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference(forURL: "gs://trail-lab.appspot.com")

        databaseRef.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let url = value?["imageURL"] as? String ?? ""
            let firstname = value?["firstName"] as? String ?? ""
            let lastname = value?["lastName"] as? String ?? ""
            if url != "" {
           self.getImage(url, iv: self.profileImageView)
            }
            self.nameTF.text = firstname.capitalized
            self.lastNameTF.text = lastname.capitalized
            
        }) { (error) in
            print(error.localizedDescription)
        }
     
    }
    
    deinit {
        databaseRef.child("users").removeObserver(withHandle: _refHandle)
    }
    
    //use to get immage
    func getImage(_ url:String, iv:UIImageView) {
        
        FIRStorage.storage().reference(forURL: url).data(withMaxSize: 10 * 1024 * 1024, completion: { (data, error) in
            //Dispatch the main thread here
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                iv.image = image
            }
            
        })
    }

    //Mark -Figour out KeyBoard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTF {
            lastNameTF.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
   
    func keyboardDismiss() {
        nameTF.resignFirstResponder()
        lastNameTF.resignFirstResponder()
    }

    @IBAction func dismissKeyBoard(_ sender: UITapGestureRecognizer) {
        keyboardDismiss()
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
            
                profileImageView.image = image
                saveImage(image)
    
        } else {
            print("Somthing went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func saveImage(_ image:UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        let imagePath = "\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        self.storageRef.child(imagePath)
            .put(imageData!, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    return
                }
                self.picURL = self.storageRef.child((metadata?.path)!).description
                print(self.picURL)
                
                self.databaseRef.child("users/\(self.userID!)/imageURL").setValue(self.picURL)
        }
        
        
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
            
            
            let firstName = self.nameTF.text
            let lastName = self.lastNameTF.text
            
            firstNameDefoults.set(firstName, forKey: firstNameDefoults_Key)
            firstNameDefoults.synchronize()
            lastNameDefoults.set(lastName, forKey: lastNameDefoults_Key)
            lastNameDefoults.synchronize()
            
            self.databaseRef.child("users/\(userID!)/firstName").setValue(firstName)
            self.databaseRef.child("users/\(userID!)/lastName").setValue(lastName)
            
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

