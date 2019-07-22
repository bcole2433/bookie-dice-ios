//
//  LeaderboardTableViewController.swift
//  Bookie
//
//  Created by Brenden Coleman on 2/2/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import UIKit

class LeaderboardTableViewController: UITableViewController {
    @IBOutlet var leaderboardTableView: UITableView!
    
    var users : [User] = []
    var userBets : [PlacedBet] = [] {
        didSet {
            self.leaderboardTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Leaderboard"
        self.users = SocialHelper.sharedSocialHelper().users
        getAllUserBets(users: self.users)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getAllUserBets(users: [User]) {
        var betGroup : [PlacedBet] = []
        for user in users {
            getUserBets(user: user) {
                bets in
                betGroup.append(contentsOf: bets)
            }
        }
    }
    
    func getUserBets(user: User, completion: @escaping ([PlacedBet])-> Void) {
        var userBets : [PlacedBet] = []
            let name = user.name
            let betsList = SocialHelper.sharedSocialHelper().betsList
            for bet in betsList {
                var filteredPlacedBets : [PlacedBet]
                let placedBets = bet.placedBets
                filteredPlacedBets = (placedBets!.filter{($0.betterName.lowercased() == name)})
                userBets.append(contentsOf: filteredPlacedBets)
            }
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderCell") as? LeaderboardCell
        let user = users[indexPath.item]
        cell?.user = user
        cell?.contr = self
        cell?.name.text = user.name
        cell?.username.text = user.username
        let userBets = self.userBets
        var filteredPlacedBets : [PlacedBet] = []
        var betCount : Int = 0
        filteredPlacedBets = (userBets.filter{($0.betterName.lowercased() == user.name)})
        betCount = filteredPlacedBets.count
        
        
        cell?.totalBets.text = "Total Bets: \(betCount)"
        cell?.totalBetsWon.text = "Bets Won: 0"
        cell?.totalMoney.text = "$0"
        return cell!
    }

}
