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
    @IBOutlet weak var finalButton: UIButton!
    
    var bet : CreatedBet?
    var contr : MyBetsView? = nil
    

    
    func updateCell(bet: CreatedBet) {
        self.betName.text = bet.betName
        self.betValue.text = "Over / Under \(bet.betValue)"
        

        self.finalButton.setTitleColor(UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1), for: UIControl.State())
        self.finalButton.titleLabel?.textColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1)
        self.finalButton.layer.borderWidth = 1
        self.finalButton.layer.borderColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1).cgColor
        self.finalButton.layer.cornerRadius = 10
        
        DispatchQueue.main.async {
            self.contr!.myBetsTableView.reloadData()
        }
    }
}
