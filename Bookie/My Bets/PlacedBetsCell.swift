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
    
    var bet: PlacedBet?
    var contr : MyBetsView? = nil
    
    func updateCell(bet: PlacedBet) {
        self.betName.text = bet.betName
        self.betValue.text = "Over / Under \(bet.betValue)"
        let betTotal = bet.overMoneyTotal + bet.underMoneyTotal
        self.totalMoneyBet.text = "\(betTotal)"
        
        DispatchQueue.main.async {
            self.contr!.myBetsTableView.reloadData()
        }
    }
    
}
