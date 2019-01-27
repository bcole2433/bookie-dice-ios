//
//  BetView.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/11/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import UIKit
import Firebase

class BetView: UIViewController {
    @IBOutlet weak var bookieUsername: UILabel!
    @IBOutlet weak var bookieName: UILabel!
    @IBOutlet weak var betName: UILabel!
    @IBOutlet weak var betType: UILabel!
    @IBOutlet weak var betValue: UILabel!
    @IBOutlet weak var betOdds: UILabel!
    @IBOutlet weak var placeBetButton: UIButton!
    @IBOutlet weak var overTextField: UITextField!
    @IBOutlet weak var underTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    
    var bet: CreatedBet?
    var totalBet: Int = 0
    let userID = Auth.auth().currentUser?.uid
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBet()

    }
    
    func configureBet() {
        self.bookieUsername.text = bet?.bookieUsername
        self.bookieName.text = bet?.bookieName
        self.betName.text = bet!.betName
        self.betValue.text = "\(String(describing: bet!.betValue))"
        self.betOdds.text = "Over: \(bet!.overValue) | Under: \(bet!.underValue)"
        
        self.placeBetButton.layer.backgroundColor = UIColor.blue.cgColor
        self.placeBetButton.setTitleColor(.white, for: UIControl.State())
        self.placeBetButton.titleLabel?.textColor = .white
        self.placeBetButton.layer.borderWidth = 0
        self.placeBetButton.layer.cornerRadius = 10
        
    }
    
    @objc internal func dismissAlertController(alertController: UIAlertController) {
        alertController.dismiss(animated: true, completion: nil)
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func placeBetTapped(_ sender: Any) {
//        let userName = defaults.object(forKey: "UserName") as! String
//        let name = defaults.object(forKey: "Name") as! String
        
        var overValue = 0
        if let overVal = Int(overTextField.text!) {
            overValue = overVal
        } else {
            print("Not a valid number: \(overTextField.text!)")
            overValue = 0
        }
        
        var underValue = 0
        if let underVal = Int(underTextField.text!) {
            underValue = underVal
        } else {
            print("Not a valid number: \(underTextField.text!)")
            underValue = 0
        }
        
        if overTextField.text != "" {
            self.totalBet = overValue
        } else {
            self.totalBet = underValue
        }
        
        let tempBet = PlacedBet(bookieUsername: (bet?.bookieUsername)!, bookieName: (bet?.bookieName)!, bookieID: self.userID!, betName: (bet?.betName)!, betType: (bet?.betType)!, betValue: (bet?.betValue)!, overValue: (bet?.overValue)!, underValue: (bet?.underValue)!, overMoneyTotal: overValue, underMoneyTotal: underValue)
        
        FirebaseHelper().addUserBetToFirebase(userID: userID!, bet: tempBet)
        
        
        let  alertConfirm = UIAlertController(title: "Bet Placed", message: "", preferredStyle: UIAlertController.Style.alert)
        self.present(alertConfirm, animated: true) {
            self.perform(#selector(BetView.dismissAlertController(alertController:)), with: alertConfirm, afterDelay: 0.5)
        }
    }
    
}
