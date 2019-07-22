//
//  MyBetsView.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/26/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import UIKit
import Firebase


class MyBetsView: UIViewController {
    @IBOutlet weak var bookieUsername: UILabel!
    @IBOutlet weak var bookieName: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var myBetsTableView: UITableView!
    
    
    var placedBets : [PlacedBet] = []
    var createdBets : [CreatedBet] = []
    var selectedBet : CreatedBet?
    
    let userID = Auth.auth().currentUser?.uid
    let helper = SocialHelper.sharedSocialHelper()
    let db =  Firestore.firestore()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCreatedBets()
        getPlacedBets()
        super.viewWillAppear(animated)
    }
    
    func setUpView() {
        myBetsTableView.delegate = self
        myBetsTableView.dataSource = self
        myBetsTableView.estimatedRowHeight = 100
        myBetsTableView.rowHeight = UITableView.automaticDimension
        addImageTitle()
        
        let userName = defaults.object(forKey: "UserName") as! String
        let name = defaults.object(forKey: "Name") as! String
        self.bookieUsername.text = userName
        self.bookieName.text = name
        
        DispatchQueue.main.async {
            self.myBetsTableView.reloadData()
        }
    }
    
    func addImageTitle() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFill
        let logo = UIImage(named: "bookieappiconround")
        imageView.image = logo
        self.navigationItem.titleView = imageView
    }

    func getPlacedBets() {
        if helper.myBets.count == 0 {
        FirebaseHelper().getUserPlacedBets(userID: userID!) {
            bets in
            self.placedBets = bets
            DispatchQueue.main.async {
                self.myBetsTableView.reloadData()
                }
            }
        } else {
            self.placedBets = helper.myBets
            DispatchQueue.main.async {
                self.myBetsTableView.reloadData()
            }
        }
    }
        
    func getCreatedBets() {
        FirebaseHelper().getUserCreatedBets(userID: userID!) {
            bets in
            self.createdBets = bets
            DispatchQueue.main.async {
                self.myBetsTableView.reloadData()
                }
            }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SubmitBetViewController {
            destination.bet = self.selectedBet
        }
    }
    @IBAction func indexChanged(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.myBetsTableView.reloadData()
        }
    }
    

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MyBetsView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        switch(self.segmentedControl.selectedSegmentIndex){
        case 0:
            if self.placedBets != nil {
            returnValue = self.placedBets.count
            } else {
                returnValue = 0
            }
        case 1:
            if self.createdBets != nil {
            returnValue = self.createdBets.count
            } else {
                returnValue = 0
            }
        default:
            break
        }
        return returnValue
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(self.segmentedControl.selectedSegmentIndex){
        case 0:
            // MARK : - PLACED BETS
            
            let cell = myBetsTableView.dequeueReusableCell(withIdentifier: "placedBets", for: indexPath) as? PlacedBetsCell
            let bet = placedBets[indexPath.item]
            cell!.contr = self
            cell!.bet = bet
            cell!.updateCell(bet: bet)
            return cell!
            
        case 1:
            // MARK : - Created BETS
            let cell = myBetsTableView.dequeueReusableCell(withIdentifier: "createdBets", for: indexPath) as? CreatedBetsCell
            let bet = createdBets[indexPath.item]
            cell!.contr = self
            cell!.bet = bet
            cell!.updateCell(bet: bet)
            return cell!
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(self.segmentedControl.selectedSegmentIndex){
        case 0:
            // MARK : - PLACED BETS
            print("On placedBets")
            
        case 1:
            // MARK : - Created BETS
            let cell = myBetsTableView.dequeueReusableCell(withIdentifier: "createdBets", for: indexPath) as? CreatedBetsCell
            let bet = createdBets[indexPath.item]
            self.selectedBet = bet
            self.performSegue(withIdentifier: "toFinalBetValue", sender: self)
            
            default:
            break
        }
    }
}


