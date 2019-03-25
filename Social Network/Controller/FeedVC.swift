//
//  FeedVC.swift
//  Social Network
//
//  Created by Teddy on 3/25/19.
//  Copyright © 2019 a. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        removeFromKeychain()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    func removeFromKeychain() {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("TEDDY: ID removed from keychain \(keychainResult)")
        
        do {
            try Auth.auth().signOut()
        } catch let error{
            print(error.localizedDescription)
        }
    }
    
}
