//
//  BetsTableCell.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/27/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import Foundation
import UIKit

class BetsTableCell: UITableViewCell {
    @IBOutlet weak var betterName: UILabel!
    @IBOutlet weak var betValue: UILabel!
    @IBOutlet weak var betterActualName: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    var bet: PlacedBet?
    var contr: SubmitBetViewController? = nil
    
    func updateCell(bet: PlacedBet) {
        self.betterName.text = bet.betterName
        self.betterActualName.text = bet.betterUserName
        if bet.overMoneyTotal > 0 {
            self.betValue.text = "They bet $\(bet.overMoneyTotal)" + " (Over)"
        } else {
            self.betValue.text = "They bet $\(bet.underMoneyTotal) (Under)"
        }

    }
}
