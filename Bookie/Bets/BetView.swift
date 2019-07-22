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
        self.hideKeyboard()
        
        self.placeBetButton.layer.backgroundColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1).cgColor
        self.placeBetButton.setTitleColor(.white, for: UIControl.State())
        self.placeBetButton.titleLabel?.textColor = .white
        self.placeBetButton.layer.borderWidth = 0
        self.placeBetButton.layer.cornerRadius = 10

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureBet() {
        self.bookieUsername.text = bet?.bookieUsername
        self.bookieName.text = bet?.bookieName
        self.betName.text = bet!.betName
        self.betValue.text = "\(String(describing: bet!.betValue))"
//        self.betOdds.text = "Over: \(bet!.overValue) | Under: \(bet!.underValue)"

    }
    
    func checkBetTime() {
        let superBowlTime = "2019-02-03 22:30:00"
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.string(from: currentDateTime)
        print(currentDateTime)
        print(superBowlTime)
        let dateString = "\(currentDateTime)"
        
        switch dateString.compare(superBowlTime) {
        case .orderedAscending:
            print("\(dateString) is earlier than \(superBowlTime)")
            //MARK: User allowed to bet
            let defaults = UserDefaults.standard
            let betterName = defaults.object(forKey: "Name") as! String
            let betterUserName = defaults.object(forKey: "UserName") as! String
            
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
            
            let tempBet = PlacedBet(betterName: betterName, betterUserName: betterUserName, bookieUsername: (bet?.bookieUsername)!, bookieName: (bet?.bookieName)!, bookieID: self.userID!, betName: (bet?.betName)!, betType: (bet?.betType)!, betValue: (bet?.betValue)!, overValue: (bet?.overValue)!, underValue: (bet?.underValue)!, overMoneyTotal: overValue, underMoneyTotal: underValue)
            var placedBets = SocialHelper.sharedSocialHelper().myBets
            placedBets.append(tempBet)
            FirebaseHelper().addUserBetToFirebase(userID: userID!, bet: tempBet)
            
            
            let  alertConfirm = UIAlertController(title: "Bet Placed", message: "", preferredStyle: UIAlertController.Style.alert)
            self.present(alertConfirm, animated: true) {
                self.perform(#selector(BetView.dismissAlertController(alertController:)), with: alertConfirm, afterDelay: 0.5)
            }
            
            
        case .orderedDescending:
            print("\(dateString) is later than \(superBowlTime)")
            let  alertConfirm = UIAlertController(title: "Not So Fast", message: "Bets are disabled during the game, you cheater.", preferredStyle: UIAlertController.Style.alert)
            self.present(alertConfirm, animated: true) {
                self.perform(#selector(BetView.dismissAlertController(alertController:)), with: alertConfirm, afterDelay: 3)
            }
        case .orderedSame:
            print("same time")
            let  alertConfirm = UIAlertController(title: "Not So Fast", message: "Bets are disabled during the game, you cheater.", preferredStyle: UIAlertController.Style.alert)
            self.present(alertConfirm, animated: true) {
                self.perform(#selector(BetView.dismissAlertController(alertController:)), with: alertConfirm, afterDelay: 3)
            }
        }
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

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func placeBetTapped(_ sender: Any) {
        checkBetTime()
    }
    
}
