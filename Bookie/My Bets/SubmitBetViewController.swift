//
//  SubmitBetViewController.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/27/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import UIKit

class SubmitBetViewController: UIViewController {

    @IBOutlet weak var betName: UILabel!
    @IBOutlet weak var betValue: UILabel!
    @IBOutlet weak var actualValueField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var bet: CreatedBet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.betName.text = bet?.betName
        let betValue = bet?.betValue
        self.betValue.text = "Over / Under \(String(describing: betValue))"
        
        self.submitButton.layer.backgroundColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1).cgColor
        self.submitButton.setTitleColor(.white, for: UIControl.State())
        self.submitButton.titleLabel?.textColor = .white
        self.submitButton.layer.borderWidth = 0
        self.submitButton.layer.cornerRadius = 10
        
    }
    
    @objc internal func dismissAlertController(alertController: UIAlertController) {
        alertController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        let bet = self.bet
        var actualValue: Double?
        if let betVal = Double(actualValueField.text!) {
            actualValue = betVal
        } else {
            print("Not a valid number: \(actualValueField.text!)")
        }
        
        //TODO: Insert bet field for if it is complete or not
        FirebaseHelper().submitFinalValue(betName: (bet?.betName)!, finalValue: actualValue!)
        
        
        let  alertConfirm = UIAlertController(title: "Final Bet Value Submitted", message: "", preferredStyle: UIAlertController.Style.alert)
        self.present(alertConfirm, animated: true) {
            self.perform(#selector(BetView.dismissAlertController(alertController:)), with: alertConfirm, afterDelay: 0.5)
        }
    }
    
}
