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
    var bet: CreatedBet?
    var contr : BetsListViewController? = nil
    
    func updateCell(bet: CreatedBet) {
        self.bookieUsername.text = bet.bookieUsername
        self.bookieName.text = bet.bookieName
        self.betName.text = bet.betName
        self.betValue.text = "\(bet.betValue)"
        
        DispatchQueue.main.async {
            self.contr!.betsListTableView.reloadData()
        }
    }
    
    
}
