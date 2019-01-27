//
//  ProtectedViewController.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/11/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProtectedViewController: UIViewController {
    var authListener: AuthStateDidChangeListenerHandle?
    let db =  Firestore.firestore()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            checkUsername()
        } else {
        signInAnonymously()
        }
    }
    

    func signInAnonymously() {
        Auth.auth().signInAnonymously() { (authResult, error) in
            let user = authResult!.user
            let isAnonymous = user.isAnonymous  // true
            let uid = user.uid
        }
        self.performSegue(withIdentifier: "toSignup", sender: self)
    }
    
    func checkUsername() {
        if  let userID = Auth.auth().currentUser?.uid {
            let userRef = db.collection("users").document(userID)
            var userName = ""
            var name = ""
            userRef.getDocument { (document, err) in
                if let document = document, document.exists {
                    print("user exists, going to home")
                    self.setUpBetsList()
                } else {
                    print("Document does not exist")
                    self.performSegue(withIdentifier: "toSignup", sender: self)
                }
            }
        }
    }
    
    func setUpBetsList() {
        FirebaseHelper().loadAllBets() {
            bets in
            print("The bet count is \(bets.count)")
            SocialHelper.sharedSocialHelper().betsList = bets
            self.performSegue(withIdentifier: "toHome", sender: self)
         //   self.performSegue(withIdentifier: "ToBetsList", sender: self)
        }
    }

}
