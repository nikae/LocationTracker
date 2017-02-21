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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTF.delegate = self
        self.passwordTF.delegate = self
        
        switch (keepMeLogedInDefoultsDefoults.bool(forKey: keepMeLogedInDefoults_key)) {
        case true:
            let image = UIImage(named: "Checked Checkbox 2_000000_25") as UIImage?
            keepMeLoggedIn.setImage(image, for: .normal)
            print("true")
            
        case false:
            let image = UIImage(named: "Unchecked Checkbox_000000_25") as UIImage?
            keepMeLoggedIn.setImage(image, for: .normal)
            print("False")
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
                    print("You have successfully logged in")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
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
    
    var launchBool: Bool = false {
        didSet {
            if launchBool == true {
                let image = UIImage(named: "Checked Checkbox 2_000000_25") as UIImage?
                keepMeLoggedIn.setImage(image, for: .normal)
                keepMeLogedInDefoultsDefoults.set(true, forKey: keepMeLogedInDefoults_key)
                keepMeLogedInDefoultsDefoults.synchronize()
                let a = keepMeLogedInDefoultsDefoults.bool(forKey: keepMeLogedInDefoults_key)
                print(a)
            } else {
                let image = UIImage(named: "Unchecked Checkbox_000000_25") as UIImage?
                keepMeLoggedIn.setImage(image, for: .normal)
                keepMeLogedInDefoultsDefoults.set(false, forKey: keepMeLogedInDefoults_key)
                keepMeLogedInDefoultsDefoults.synchronize()
                let a = keepMeLogedInDefoultsDefoults.bool(forKey: keepMeLogedInDefoults_key)
                print(a)
            }

    }
}
    
    @IBAction func keepMeLoggedInHit(_ sender: UIButton) {
        launchBool = !launchBool
    }
    
}
