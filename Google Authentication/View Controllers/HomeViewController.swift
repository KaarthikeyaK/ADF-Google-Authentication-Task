//
//  HomeViewController.swift
//  Google Authentication
//
//  Created by KAARTHIKEYA K on 28/06/22.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class HomeViewController: UIViewController {

    @IBOutlet var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        GIDSignIn.sharedInstance.signOut()
        do {
            try Auth.auth().signOut()
            transitionToRoot()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func transitionToRoot(){
        let rootVC = storyboard?.instantiateViewController(withIdentifier: "signInVC")
        view.window?.rootViewController = rootVC
        view.window?.makeKeyAndVisible()
    }
    
}
