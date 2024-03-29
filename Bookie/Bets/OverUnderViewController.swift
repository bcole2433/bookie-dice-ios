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
        addImageTitle()
        self.hideKeyboard()
        
        self.createBetButton.layer.backgroundColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1).cgColor
        self.createBetButton.setTitleColor(.white, for: UIControl.State())
        self.createBetButton.titleLabel?.textColor = .white
        self.createBetButton.layer.borderWidth = 0
        self.createBetButton.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

       // self.nameTextField.isFirstResponder
    }
    
    func addImageTitle() {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFill
        let logo = UIImage(named: "bookieappiconround")
        imageView.image = logo
        self.navigationItem.titleView = imageView
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @objc internal func dismissAlertController(alertController: UIAlertController) {
        alertController.dismiss(animated: true, completion: nil)
    }

    @IBAction func createBetTapped(_ sender: Any) {
        let userName = defaults.object(forKey: "UserName") as! String
        let name = defaults.object(forKey: "Name") as! String
        
        let betName = nameTextField.text?.replacingOccurrences(of: "/", with: "|")
        let betType = "over/under"
        var betValue = 0.0
        if let betVal = Double(valueField.text!) {
            betValue = betVal
            let overValue = "0"
            let underValue = "0"
            let tempBet = CreatedBet(bookieUsername: userName, bookieName: name, bookieID: self.userID!, betName: betName!, betType: betType, betValue: betValue, overValue: overValue, underValue: underValue, placedBets: [])
            
            print(tempBet)
            helper.betsList.append(tempBet)
            FirebaseHelper().sendCreatedBetToFirebase(userID: userID!, bet: tempBet)
            
            let  alertConfirm = UIAlertController(title: "Bet Created", message: "", preferredStyle: UIAlertController.Style.alert)
            self.present(alertConfirm, animated: true) {
                self.perform(#selector(BetView.dismissAlertController(alertController:)), with: alertConfirm, afterDelay: 0.5)
            }
            
        } else {
            print("Not a valid number: \(valueField.text!)")
            
            let  alertConfirm = UIAlertController(title: "Not a valid input", message: "Inputs should be numbers because I didn't have time to figure out all use cases.", preferredStyle: UIAlertController.Style.alert)
            self.present(alertConfirm, animated: true) {
                self.perform(#selector(BetView.dismissAlertController(alertController:)), with: alertConfirm, afterDelay: 2)
            }
        }
    }
    
}

