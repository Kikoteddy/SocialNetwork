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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyTextField!
    @IBOutlet weak var passwordField: FancyTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfUserExists()
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let fbLogin = FBSDKLoginManager()
        
        fbLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            
            guard error == nil else {
                print("TEDDY: Unable to authenticate with Facebook - \(error!)")
                return
            }

            if result?.isCancelled == true {
                print("TEDDY: User canceled Facebook authentication")
            } else {
                print("TEDDY: Authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: (FBSDKAccessToken.current().tokenString))
                self.firebaseAuthWith(credential)   
            }
        }
        
    }
    
    func checkIfUserExists(){
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }
    
    func firebaseAuthWith(_ credential: AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if error != nil {
                print("TEDDY: Unable to authenticate with Firebase - \(error.debugDescription)")
            } else {
                print("TEDDY: Successfully authenticated with Firebase")
                if let user = user {
                    self.completesignInWith(id: user.user.uid)
                }
                
            }
        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user , error) in
                if error == nil {
                    print("TEDDY: Email user authenticated with Firebase")
                    if let user = user {
                        self.completesignInWith(id: user.user.uid)
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        guard error == nil else {
                            print("TEDDY: Unable to authenticate with Firebase using email - \(error!)")
                            return
                        }
                        guard error != nil else {
                            print("TEDDY: Successfully authenticated with Firebase using email")
                            if let user = user {
                                self.completesignInWith(id: user.user.uid)
                            }
                            return
                        }
                    })
                }
            }
        }
    }
    
    func completesignInWith(id: String) {
       let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID) //read this check firebase/manageUsers
        print("TEDDY: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
}

