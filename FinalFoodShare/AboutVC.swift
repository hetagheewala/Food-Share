//
//  AboutVC.swift
//  FinalFoodShare
//
//  Created by Heta Gheewala on 5/9/17.
//  Copyright © 2017 Heta Gheewala. All rights reserved.
//

import UIKit
import FirebaseAuth
import KeychainSwift

class AboutVC: UIViewController{
    
    @IBOutlet weak var storedEmail: UITextField!
    override func viewDidLoad() {
        
        let email = FIRAuth.auth()?.currentUser?.email
        storedEmail.text = email
    }
    
    @IBAction func SignOut(_ sender: Any){
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        DataService().keyChain.delete("uid")
        dismiss(animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "GoToLogoutLogin", sender: nil)
        
    }
}
