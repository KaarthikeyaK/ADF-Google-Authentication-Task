//
//  SignInViewController.swift
//  Google Authentication
//
//  Created by KAARTHIKEYA K on 28/06/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class SignInViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signInWithGoogleButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    

    
//    let signInConfig = GIDConfiguration(clientID: "917212064732")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

    func validateFields() -> String?{
        
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
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

    
    @IBAction func signInButtonTapped(_ sender: Any) {
        let error = validateFields()
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if error != nil{
            showError(message: error!)
        } else {
            Auth.auth().signIn(withEmail: email, password: password){ [self] (result, error) in
                if error != nil {
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                } else {
                    transitionToHome()
                }
            }
            
        }
    }
    
    @IBAction func signInWithGoogleTapped(_ sender: Any) {
        
//        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

          if let error = error {
              showError(message: error.localizedDescription)
            return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

          //FireBase Auth
            
            Auth.auth().signIn(with: credential){(result, err) in
                if let error = err {
                    self.showError(message: error.localizedDescription)
                  return
                } else {
                    self.transitionToHome()
                }
            }
            
        }
        
    }
    
    func transitionToHome(){
        let homeVC = storyboard?.instantiateViewController(identifier: "homeVC") as? HomeViewController
        view.window?.rootViewController = homeVC
        view.window?.makeKeyAndVisible()
    }
    
}
