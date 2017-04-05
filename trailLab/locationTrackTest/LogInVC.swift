//
//  LogInVC.swift
//  Trail Lab
//
//  Created by Nika on 2/17/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseAuth


class LogInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
 
    @IBOutlet weak var keepMeLoggedIn: UIButton!
    
    var storageRef: FIRStorageReference!
    var databaseRef: FIRDatabaseReference!
    fileprivate var _refHandle: FIRDatabaseHandle!
    var users: [FIRDataSnapshot] = []
    var picURL = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = FIRDatabase.database().reference()
        
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
        
        switch (keepMeLogedInDefoultsDefoults.bool(forKey: keepMeLogedInDefoults_key)) {
        case true:
            let image = UIImage(named: "Checked Checkbox 2_000000_25") as UIImage?
            keepMeLoggedIn.setImage(image, for: .normal)
           // print("true")
            
        case false:
            let image = UIImage(named: "Unchecked Checkbox_000000_25") as UIImage?
            keepMeLoggedIn.setImage(image, for: .normal)
            //print("False")
        }
       
    }
   
    //Mark -Figour out KeyBoard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else {
        textField.resignFirstResponder()
        performAction()
        }
       
        return true
    }

    func performAction() {
         logIn()
    }
    
    func keyboardDismiss() {
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    
    @IBAction func viewTaped(_ sender: UITapGestureRecognizer) {
        keyboardDismiss()
    }
    
    @IBAction func logInHit(_ sender: Any) {
        logIn()
        
    }
    
    func logIn(){
        if emailTF.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.signIn(withEmail: self.emailTF.text!, password: self.passwordTF.text!) { (user, error) in
                if error == nil {
                   // print("You have successfully logged in")
                    if (user?.isEmailVerified)! {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
                    self.present(vc!, animated: true, completion: nil)
                    
                    let userID = FIRAuth.auth()?.currentUser?.uid
                    self.databaseRef.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let value = snapshot.value as? NSDictionary
                        let url = value?["imageURL"] as? String ?? ""
                        let firstname = value?["firstName"] as? String ?? ""
                        let lastname = value?["lastName"] as? String ?? ""
                        let email = value?["email"] as? String ?? ""
                        if url != "" {
                            
                            self.getImage(url)
                            
                        }
                        
                        firstNameDefoults.set(firstname, forKey: firstNameDefoults_Key)
                        firstNameDefoults.synchronize()
                        lastNameDefoults.set(lastname, forKey: lastNameDefoults_Key)
                        lastNameDefoults.synchronize()
                        emailDefoults.set(email, forKey: emailDefoults_Key)
                        emailDefoults.synchronize()
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                    getResults(UID: userID!)
                    } else {
                        let alert = UIAlertController(title: "Please verify your email address", message: "We have sent you an email with verification link", preferredStyle: .alert)
                        let okHit = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        let resendHit = UIAlertAction(title: "Resend", style: .default)
                        { (action: UIAlertAction) in
                        user?.sendEmailVerification()
                            
                            let alert = UIAlertController(title: "Verification email sent", message: "Please check your email to verify", preferredStyle: .alert)
                            let oKAction = UIAlertAction(title: "OK", style: .cancel)
                            
                            alert.addAction(oKAction)
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        alert.addAction(okHit)
                        alert.addAction(resendHit)
                        self.present(alert, animated: true, completion: nil)

                    }
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }

    }
    
    func getImage(_ url:String) {
        var image = UIImage()
        FIRStorage.storage().reference(forURL: url).data(withMaxSize: 10 * 1024 * 1024, completion: { (data, error) in
            if error != nil {
                print(error?.localizedDescription ?? "ERROR")
                image = UIImage(named:"img-default")!
            } else {
            //Dispatch the main thread here
            DispatchQueue.main.async {
                image = UIImage(data: data!)!
                
                //**************
                let imageData = UIImageJPEGRepresentation(image, 1)
                profilePictureDefoults.set(imageData, forKey: "image")
                profilePictureDefoults.synchronize()
                                
            }
        }   
    })
}
    
    var launchBool: Bool = false {
        didSet {
            if launchBool == true {
                let image = UIImage(named: "Checked Checkbox 2_000000_25") as UIImage?
                keepMeLoggedIn.setImage(image, for: .normal)
                keepMeLogedInDefoultsDefoults.set(true, forKey: keepMeLogedInDefoults_key)
                keepMeLogedInDefoultsDefoults.synchronize()
//                let a = keepMeLogedInDefoultsDefoults.bool(forKey: keepMeLogedInDefoults_key)
//                print(a)
            } else {
                let image = UIImage(named: "Unchecked Checkbox_000000_25") as UIImage?
                keepMeLoggedIn.setImage(image, for: .normal)
                keepMeLogedInDefoultsDefoults.set(false, forKey: keepMeLogedInDefoults_key)
                keepMeLogedInDefoultsDefoults.synchronize()
               // let a = keepMeLogedInDefoultsDefoults.bool(forKey: keepMeLogedInDefoults_key)
                //print(a)
            }

    }
}
    
    @IBAction func keepMeLoggedInHit(_ sender: UIButton) {
        launchBool = !launchBool
    }
    
}
