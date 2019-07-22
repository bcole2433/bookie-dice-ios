//
//  BetsListTableCell.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/11/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import Foundation
import UIKit

class BetsListTableCell: UITableViewCell {
    @IBOutlet weak var bookieUsername: UILabel!
    @IBOutlet weak var bookieName: UILabel!
    @IBOutlet weak var betName: UILabel!
    @IBOutlet weak var betValue: UILabel!
    @IBOutlet weak var bookieStar: UIImageView!
    var bet: CreatedBet?
    var contr : BetsListViewController? = nil
    
    func updateCell(bet: CreatedBet) {
        self.bookieUsername.text = bet.bookieUsername
        self.bookieName.text = bet.bookieName
        self.betName.text = bet.betName
        self.betValue.text = "\(bet.betValue)"
        if bet.bookieID.contains("YQGJMvHoGkT83cx6gdW1lx5eHF43") {
            print("Bookie Dice bet")
            self.bookieStar.isHidden = false
        }
    }
    
    
}
