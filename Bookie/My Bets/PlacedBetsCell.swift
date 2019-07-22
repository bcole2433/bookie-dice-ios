//
//  PlacedBetsCell.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/26/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import Foundation
import Firebase

class PlacedBetsCell: UITableViewCell {
    @IBOutlet weak var betName: UILabel!
    @IBOutlet weak var betValue: UILabel!
    @IBOutlet weak var totalMoneyBet: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    
    var bet: PlacedBet?
    var contr : MyBetsView? = nil
    let db = Firestore.firestore()
    var finalValue : Double? {
        didSet {
            checkBetFinalValue()
            changeValue()
            self.contr!.myBetsTableView.reloadData()
        }
    }
    
    func updateCell(bet: PlacedBet) {
        self.betName.text = bet.betName
        
        if bet.underMoneyTotal > 0 {
            self.betValue.text = "You bet UNDER \(bet.betValue)"
        } else if bet.overMoneyTotal > 0 {
            self.betValue.text = "You bet OVER \(bet.betValue)"
        } else {
        
        self.betValue.text = "Over / Under \(bet.betValue)"
        }
        
        let betTotal = bet.overMoneyTotal + bet.underMoneyTotal
        self.totalMoneyBet.text = "$\(betTotal)"
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
    
    func changeValue() {
        if self.finalValue == nil {
            self.winnerLabel.text = ""
        } else {
            
            if (finalValue?.isLess(than: (self.bet?.betValue)!))! {
                //Under hit
                if (bet?.underMoneyTotal)! > 0 {
                    self.winnerLabel.text = "Winner! +$\(bet!.underMoneyTotal)"
                }
                
                if (bet?.underMoneyTotal)! < 0 {
                    self.winnerLabel.text = "Loser! -$\(bet!.underMoneyTotal)"
                }
                
            } else if (finalValue?.isEqual(to: (self.bet!.betValue)))! {
                //push
                self.winnerLabel.text = "Push"
            } else {
                //Over hit
                if (bet?.overMoneyTotal)! > 0 {
                    self.winnerLabel.text = "Winner! +$\(bet!.overMoneyTotal)"
                    self.winnerLabel.textColor = UIColor.green
                }
                
                if (bet?.overMoneyTotal)! < 0 {
                    self.winnerLabel.text = "Loser! -$\(bet!.overMoneyTotal)"
                    self.winnerLabel.textColor = UIColor.red
                }
            }
        }
    }
    
}
