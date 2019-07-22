//
//  BetModel.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/11/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import Foundation
import UIKit

struct User {
    let userID: String
    let username: String
    let name: String
}

struct UserWithBets {
    let userID: String
    let username: String
    let name: String
    let totalBets: Int
    let totalBetsWon: Int
    let totalMoney: Int
    
}

struct CreatedBet {
    let bookieUsername: String
    let bookieName: String
    let bookieID: String
    let betName: String
    let betType: String
    let betValue: Double
    let overValue: String
    let underValue: String
    let placedBets : [PlacedBet]?
}

struct PlacedBet {
    let betterName: String
    let betterUserName: String
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
