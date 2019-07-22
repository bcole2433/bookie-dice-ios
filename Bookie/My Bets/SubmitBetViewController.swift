//
//  SubmitBetViewController.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/27/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import UIKit
import Firebase

class SubmitBetViewController: UIViewController {

    @IBOutlet weak var betName: UILabel!
    @IBOutlet weak var betValue: UILabel!
    @IBOutlet weak var actualValueField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    @IBOutlet weak var finalValueLabel: UILabel!
    @IBOutlet weak var betsTableView: UITableView!
    
    var bet: CreatedBet?
    var bettersBets: [PlacedBet] = []
    var finalValue: Double? {
        didSet {
            checkBetFinalValue()
            changeValue()
        }
    }
    
    let db = Firestore.firestore()
    let socHelper = SocialHelper.sharedSocialHelper()
    let userID = Auth.auth().currentUser?.uid
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.betName.text = bet?.betName
        let betValue = (bet?.betValue)!
        self.betValue.text = "Over / Under " + "\(betValue)"
        
        self.submitButton.layer.backgroundColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1).cgColor
        self.submitButton.setTitleColor(.white, for: UIControl.State())
        self.submitButton.titleLabel?.textColor = .white
        self.submitButton.layer.borderWidth = 0
        self.submitButton.layer.cornerRadius = 10
        configureTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //checking to see if there is a final value or not
        checkBetFinalValue()
        changeValue()
        FirebaseHelper().getBettersInCreatedBet(betName: (bet?.betName)!) {
            bets in
            self.bettersBets = bets
            self.betsTableView.reloadData()
        }
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
       // changeValue()
        DispatchQueue.main.async {
            self.betsTableView.reloadData()
        }
        super.viewDidAppear(animated)
    }
    
    func configureTableView() {
        betsTableView.delegate = self
        betsTableView.dataSource = self
        betsTableView.estimatedRowHeight = 45
        betsTableView.rowHeight = UITableView.automaticDimension
    }
    
    func changeValue() {
        if self.finalValue == nil {
            self.finalValueLabel.text = ""
        } else {
            if (finalValue?.isLess(than: (self.bet?.betValue)!))! {
                //Under hit
                self.finalValueLabel.text = "Final Value: \(finalValue!) (Under)"
            } else if (finalValue?.isEqual(to: (self.bet?.betValue)!))! {
                //push
                self.finalValueLabel.text = "Final Value: \(finalValue!) (Push)"
            } else {
                //Over hit
                self.finalValueLabel.text = "Final Value: \(finalValue!) (Over)"
            }
        }
        self.betsTableView.reloadData()
    }
    
    func checkBetFinalValue(){
        let betRef = db.collection("Bets").document(self.bet!.betName)
        betRef.getDocument { (document, error) in
            let bet = document?.data()
            if let fVal = bet!["finalValue"] as? Double {
                self.finalValue = fVal
            } else {
                print("Document does not exist")
            }
        }
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
        
        checkBetFinalValue()
        changeValue()
        self.betsTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension SubmitBetViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bettersBets.count != 0 {
            return bettersBets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = betsTableView.dequeueReusableCell(withIdentifier: "betterCell", for: indexPath) as? BetsTableCell
        let bet = bettersBets[indexPath.item]
        cell!.contr = self
        cell!.bet = bet
        cell!.updateCell(bet: bet)
        // calculate bet winnings here
        if self.finalValue == nil {
            cell?.moneyLabel.text = "pending"
            cell?.moneyLabel.textColor = UIColor.lightGray
        } else {
            if (finalValue?.isLess(than: (self.bet?.betValue)!))! {
                //Under hit
                if bet.overMoneyTotal > 0 {
                    //better lost
                    cell?.moneyLabel.text = "+$\(bet.overMoneyTotal)"
                    cell?.moneyLabel.textColor = UIColor.green
                } else if bet.underMoneyTotal > 0 {
                    //better won
                    cell?.moneyLabel.text = "-$\(bet.underMoneyTotal)"
                    cell?.moneyLabel.textColor = UIColor.red
                }
                
            } else if (finalValue?.isEqual(to: (self.bet?.betValue)!))! {
                //push
                cell?.moneyLabel.text = "PUSH"
                cell?.moneyLabel.textColor = .lightGray
            } else {
                //Over hit
                if bet.overMoneyTotal > 0 {
                    //better won
                    cell?.moneyLabel.text = "-$\(bet.overMoneyTotal)"
                    cell?.moneyLabel.textColor = UIColor.red
                } else if bet.underMoneyTotal > 0 {
                    //better lost
                    cell?.moneyLabel.text = "+$\(bet.underMoneyTotal)"
                    cell?.moneyLabel.textColor = UIColor.green
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

