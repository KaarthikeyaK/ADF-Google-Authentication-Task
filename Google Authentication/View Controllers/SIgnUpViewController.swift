//
//  SIgnUpViewController.swift
//  Google Authentication
//
//  Created by KAARTHIKEYA K on 28/06/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class SIgnUpViewController: UIViewController {

    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

    func validateFields() -> String?{
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please Fill in all fields"
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is atleast 8 characters, contains a special character and a number"
        }
        
        return nil
    }
    
    func showError(message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    

    @IBAction func signUpButtonTapped(_ sender: Any) {
        let error = validateFields()
        
//        let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if error != nil{
            showError(message: error!)
        } else {
            Auth.auth().createUser(withEmail: email, password: password){ (result, err) in
                if err != nil {
                    self.showError(message: "Error creating the user")
                } else {
                    self.transitionToHome()
                }
            }
        }
    }
    
    func transitionToHome(){
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeViewController
        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
    }

}
