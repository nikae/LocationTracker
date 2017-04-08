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
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var progressView: UIProgressView!
    
     var storageRef: FIRStorageReference!
     var databaseRef: FIRDatabaseReference!
     fileprivate var _refHandle: FIRDatabaseHandle!
     var users: [FIRDataSnapshot] = []
     var picURL = ""
     let userID = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.isHidden = true
        
        nameTF.delegate = self
        lastNameTF.delegate = self
        emailTF.delegate = self
        
        profileImageViewFormat()
        
        databaseRef = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference(forURL: "gs://trail-lab.appspot.com")
      
        if let savedImgData = profilePictureDefoults.object(forKey: "image") as? NSData
            {
                if let image = UIImage(data: savedImgData as Data)
                {
                    profileImageView.image = image
                } else {
                    profileImageView.image = UIImage(named:"BGT")
        }
    }
        
        let firstName = firstNameDefoults.value(forKey: firstNameDefoults_Key) as? String ?? ""
        let lastName = lastNameDefoults.value(forKey: lastNameDefoults_Key) as? String ?? ""
        let email = emailDefoults.value(forKey: emailDefoults_Key) as? String ?? ""
        
        nameTF.text = firstName.capitalized
        lastNameTF.text = lastName.capitalized
        emailTF.placeholder = email.lowercased()
    }
    
    deinit {
        databaseRef.child("users").removeObserver(withHandle: _refHandle)
    }
    
    func profileImageViewFormat() {
    profileImageView.contentMode = .scaleAspectFill
    profileImageView.clipsToBounds = true
    profileImageView.isUserInteractionEnabled = true
    profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    profileImageView.layer.borderWidth = 0.5
    profileImageView.clipsToBounds = true
    }
    
//MARK -Figour out KeyBoard
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
        emailTF.resignFirstResponder()
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
                print(self.picURL)
                let url = profilePictureURLDefoults.value(forKey: profilePictureURLDefoults_key) as? String ?? ""
                if url != "" {
                delataImage(url: url)
                }
                self.picURL = ""
                profilePictureDefoults.set(nil, forKey: "image")
                profilePictureDefoults.synchronize()
                self.profileImageView.image = UIImage(named:"BGT")
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
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let url = profilePictureURLDefoults.value(forKey: profilePictureURLDefoults_key) as? String ?? ""
            if url != "" {
                delataImage(url: url)
                self.picURL = ""
                profilePictureDefoults.set(nil, forKey: "image")
                profilePictureDefoults.synchronize()
            }
                     
            profileImageView.image = image
            let imageData = UIImageJPEGRepresentation(image, 1)
            profilePictureDefoults.set(imageData, forKey: "image")
            profilePictureDefoults.synchronize()
            
            saveImage(image)
        
        } else {
            print("Somthing went wrong")
        }
        dismiss(animated: true, completion: nil)
    }
   
    func saveImage(_ image:UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        //(Int(Date.timeIntervalSinceReferenceDate * 1000))
        let imagePath = "\(Date.timeIntervalSinceReferenceDate * 1000).jpg"
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        let uploasTask = self.storageRef.child(imagePath)
            .put(imageData!, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error uploading: \(error)")
                    return
                }
                
                self.picURL = self.storageRef.child((metadata?.path)!).description
                self.databaseRef.child("users/\(self.userID!)/imageURL").setValue(self.picURL)
                profilePictureURLDefoults.set(self.picURL, forKey: profilePictureURLDefoults_key)
                profilePictureURLDefoults.synchronize()
                
        }
        
            uploasTask.observe(.progress, handler: { [weak self] (snapshot) in
       
            guard let strongSelf = self else {return}
            guard let progress = snapshot.progress else {return}
            strongSelf.progressView.progress = Float(progress.fractionCompleted)
            strongSelf.progressView.isHidden = false
            
            if strongSelf.progressView.progress == 1.0 {
               strongSelf.progressView.isHidden = true
            }
            
            
        } )
        
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
                
                firstNameDefoults.set(nil, forKey: firstNameDefoults_Key)
                firstNameDefoults.synchronize()
                lastNameDefoults.set(nil, forKey: lastNameDefoults_Key)
                lastNameDefoults.synchronize()
                profilePictureDefoults.set(nil, forKey: "image")
                profilePictureDefoults.synchronize()
                emailDefoults.set(nil, forKey: emailDefoults_Key)
                emailDefoults.synchronize()
                
                clearGoalsDefoultsFunc()
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func presentProfileView() {
        let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        present(profileView, animated: false, completion: nil)
    }
    
    func presentAlert(title: String, message: String ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func doneHit(_ sender: UIButton) {
        if nameTF.text != "" && lastNameTF.text != "" {
            
            let firstName = self.nameTF.text
            let lastName = self.lastNameTF.text
            let email = self.emailTF.text
            
            firstNameDefoults.set(firstName, forKey: firstNameDefoults_Key)
            firstNameDefoults.synchronize()
            lastNameDefoults.set(lastName, forKey: lastNameDefoults_Key)
            lastNameDefoults.synchronize()
    
            if email != "" {
            FIRAuth.auth()?.currentUser?.updateEmail(email!) { (error) in
                if error == nil {
                    self.databaseRef.child("users/\(self.userID!)/email").setValue(email)
                    emailDefoults.set(email, forKey: emailDefoults_Key)
                    emailDefoults.synchronize()
                    
                    self.presentProfileView()

                } else {
                    self.presentAlert(title: "Error", message: (error?.localizedDescription)!)
                   
                }
            }
            } else {
                presentProfileView()
               
            }
            
//MARK -Edit user values at firebase
            self.databaseRef.child("users/\(userID!)/firstName").setValue(firstName)
            self.databaseRef.child("users/\(userID!)/lastName").setValue(lastName)
      
        } else {
            presentAlert(title: "Please provide Full Name", message: "")
        }
    }
    
}

