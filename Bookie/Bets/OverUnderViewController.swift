//
//  OverUnderViewController.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/11/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import UIKit
import Firebase

class OverUnderViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var overField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var underField: UITextField!
    @IBOutlet weak var createBetButton: UIButton!
    
    let userID = Auth.auth().currentUser?.uid
    let helper = SocialHelper.sharedSocialHelper()
    let db =  Firestore.firestore()
    let defaults = UserDefaults.standard
    
    var userName = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.createBetButton.layer.backgroundColor = UIColor.blue.cgColor
        self.createBetButton.setTitleColor(.white, for: UIControl.State())
        self.createBetButton.titleLabel?.textColor = .white
        self.createBetButton.layer.borderWidth = 0
        self.createBetButton.layer.cornerRadius = 10
       // self.nameTextField.isFirstResponder
    }
    
    @objc internal func dismissAlertController(alertController: UIAlertController) {
        alertController.dismiss(animated: true, completion: nil)
    }

    @IBAction func createBetTapped(_ sender: Any) {
        let userName = defaults.object(forKey: "UserName") as! String
        let name = defaults.object(forKey: "Name") as! String
        
        let betName = nameTextField.text
        let betType = "over/under"
        var betValue = 0.0
        if let betVal = Double(valueField.text!) {
            betValue = betVal
        } else {
            print("Not a valid number: \(valueField.text!)")
        }
        let overValue = overField.text
        let underValue = underField.text
        let tempBet = CreatedBet(bookieUsername: userName, bookieName: name, bookieID: self.userID!, betName: betName!,betType: betType, betValue: betValue, overValue: overValue!, underValue: underValue!)
        
        print(tempBet)
        
        FirebaseHelper().sendCreatedBetToFirebase(userID: userID!, bet: tempBet)
        
        let  alertConfirm = UIAlertController(title: "Bet Created", message: "", preferredStyle: UIAlertController.Style.alert)
        self.present(alertConfirm, animated: true) {
            self.perform(#selector(BetView.dismissAlertController(alertController:)), with: alertConfirm, afterDelay: 0.5)
        }
    }
    
}
