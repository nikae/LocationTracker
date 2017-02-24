//
//  SignUpVC.swift
//  Trail Lab
//
//  Created by Nika on 2/17/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseAuth

class SignUpVC: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        emailTF.delegate = self
        passwordTF.delegate = self
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
        signUp()
    }
    
    func keyboardDismiss() {
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    
    @IBAction func viewTaped(_ sender: UITapGestureRecognizer) {
        keyboardDismiss()
    }

    @IBAction func signUpHit(_ sender: UIButton) {
        signUp()
    }
    
    
    func signUp() {
        
        if emailTF.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        } else {
            
            
            FIRAuth.auth()?.createUser(withEmail: emailTF.text!, password: passwordTF.text!) {(user, error) in
                if error == nil {
                    print("You have Successfully signed up")
                    
                    
                    let userID = FIRAuth.auth()?.currentUser?.uid
                    if userID != nil {
                   // self.saveUser(fname: "", lname: "", url: "", userId: userID!)
                        let databaseRef = FIRDatabase.database().reference()

                        databaseRef.child("users/\(userID!)/email").setValue(self.emailTF.text!)
                    }
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfile")
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
        }

    }
    
    func saveUser(fname: String, lname: String, url: String, userId: String) {
        let user = userId
        let firstName = fname
        let lastname = lname
        let imageURL = url
        
        let users : [String: [String:AnyObject]] = [user : ["firstName" : firstName as AnyObject,
                                                            "lastName": lastname as AnyObject,
                                                            "imageURL": imageURL as AnyObject]]
        
       
        let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("users").childByAutoId().setValue(users)
        
    }

}












