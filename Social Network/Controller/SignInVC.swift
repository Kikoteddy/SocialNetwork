//
//  SignInVC.swift
//  Social Network
//
//  Created by Teddy on 3/14/19.
//  Copyright © 2019 a. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let fbLogin = FBSDKLoginManager()
        
        fbLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            guard error == nil else {
                print(print("TEDDY: Unable to authenticate with Facebook - \(error!)"))
                return
            }
            
            
//            if error != nil {
//                print("TEDDY: Unable to authenticate with Facebook - \(error.debugDescription)")
//            } else
            if result?.isCancelled == true {
                print("TEDDY: User canceled Facebook authentication")
            } else {
                print("TEDDY: Authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: (FBSDKAccessToken.current().tokenString))
                self.firebaseAuthWith(credential)   
            }
        }
        
    }
    
    func firebaseAuthWith(_ credential: AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if error != nil {
                print("TEDDY: Unable to authenticate with Firebase - \(error.debugDescription)")
            } else {
                print("TEDDY: Successfully authenticated with Firebase")
            }
        }
        
    }
    
}

