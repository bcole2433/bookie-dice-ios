//
//  BetModel.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/11/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import Foundation
import UIKit

struct CreatedBet {
    let bookieUsername: String
    let bookieName: String
    let bookieID: String
    let betName: String
    let betType: String
    let betValue: Double
    let overValue: String
    let underValue: String
}

struct PlacedBet {
    let bookieUsername: String
    let bookieName: String
    let bookieID: String
    let betName: String
    let betType: String
    let betValue: Double
    let overValue: String
    let underValue: String
    let overMoneyTotal: Int
    let underMoneyTotal: Int
}
