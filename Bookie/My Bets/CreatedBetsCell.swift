//
//  CreatedBetsCell.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/26/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import Foundation
import Firebase

class CreatedBetsCell: UITableViewCell {
    @IBOutlet weak var betName: UILabel!
    @IBOutlet weak var betValue: UILabel!
    
    var bet : CreatedBet?
    var contr : MyBetsView? = nil
    
    func updateCell(bet: CreatedBet) {
        self.betName.text = bet.betName
        self.betValue.text = "Over / Under \(bet.betValue)"
        
        DispatchQueue.main.async {
            self.contr!.myBetsTableView.reloadData()
        }
    }
}
