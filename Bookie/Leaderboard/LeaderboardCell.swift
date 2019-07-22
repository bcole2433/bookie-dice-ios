//
//  LeaderboardCell.swift
//  Bookie
//
//  Created by Brenden Coleman on 2/2/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import Foundation
import UIKit

class LeaderboardCell: UITableViewCell {
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var totalBets: UILabel!
    @IBOutlet weak var totalBetsWon: UILabel!
    @IBOutlet weak var totalMoney: UILabel!
    
    var user: User?
    var contr : LeaderboardTableViewController? = nil
    
    
}
