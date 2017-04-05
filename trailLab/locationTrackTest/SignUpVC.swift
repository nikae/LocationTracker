//
//  SignUpVC.swift
//  Trail Lab
//
//  Created by Nika on 2/17/17.
//  Copyright © 2017 Nika. All rights reserved.
//

import UIKit
import Firebase


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
                    
                    user?.sendEmailVerification(completion: {(error) in
                        if error != nil {
                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(action)
                            self.present(alertController, animated: true, completion: nil)
                        } else {
                            
                            let alert = UIAlertController(title: "Verification email sent", message: "Please check your email to verify", preferredStyle: .alert)
                            
                            let oKAction = UIAlertAction(title: "OK", style: .default )
                            { (action: UIAlertAction) in
                                
                                print("You have successfully signed up")
                                
                                    firstNameDefoults.set(nil, forKey: firstNameDefoults_Key)
                                    firstNameDefoults.synchronize()
                                    lastNameDefoults.set(nil, forKey: lastNameDefoults_Key)
                                    lastNameDefoults.synchronize()
                                    profilePictureDefoults.set(nil, forKey: "image")
                                    profilePictureDefoults.synchronize()
                                    
                                    let userID = FIRAuth.auth()?.currentUser?.uid
                                    if userID != nil {
                                    let databaseRef = FIRDatabase.database().reference()
                                        
                                    databaseRef.child("users/\(userID!)/email").setValue(self.emailTF.text!)
                                        
                                    saveTotalResults()
                                        
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfile")
                                    self.present(vc!, animated: true, completion: nil)
                                    
                                    
                                }
                            
                            }

                            alert.addAction(oKAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
            }
        }

    }
    
}












