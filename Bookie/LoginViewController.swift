//
//  ViewController.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/11/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var userName: String = ""
    var name: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.signUpButton.layer.backgroundColor = UIColor.clear.cgColor
        self.signUpButton.setTitleColor(UIColor.lightText, for: UIControl.State())
        self.signUpButton.layer.borderColor = UIColor.lightGray.cgColor
        self.signUpButton.layer.borderWidth = 1
        self.signUpButton.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameTextField.becomeFirstResponder()
    }
    
    
    // MARK: - Layout
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        self.signUpButton.layer.backgroundColor = UIColor.blue.cgColor
        self.signUpButton.setTitleColor(.white, for: UIControl.State())
        self.signUpButton.titleLabel?.textColor = .white
        self.signUpButton.layer.borderWidth = 0
        self.signUpButton.layer.cornerRadius = 10
    }

    @IBAction func userNameChanged(_ sender: Any) {
    }
    @IBAction func nameChanged(_ sender: Any) {
        
        self.signUpButton.isEnabled = true
    }
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        let username = userNameTextField.text
        let name = nameTextField.text
        SocialHelper.sharedSocialHelper().userName = username
        SocialHelper.sharedSocialHelper().name = name
        defaults.set(username, forKey: "UserName")
        defaults.set(name, forKey: "Name")

        FirebaseHelper().addUserNameAndName(userName: username!, name: name!)
        FirebaseHelper().loadAllBets() {
            bets in
            if bets.count != 0 {
            print("The bet count is \(bets.count)")
            SocialHelper.sharedSocialHelper().betsList = bets
  //         self.performSegue(withIdentifier: "loginToBetsList", sender: self)
            self.performSegue(withIdentifier: "loginToHome", sender: self)
                
            } else {
                print("no bets")
            }
        }
    }
    
}

