//
//  BetsListViewController.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/11/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import UIKit
import Firebase

class BetsListViewController: UIViewController {
    @IBOutlet weak var betsListTableView: UITableView!
    @IBOutlet weak var createBetButton: UIButton!
    
    var bets : [CreatedBet]?
    var selectedBet : CreatedBet?
    
    override func viewDidLoad() {
        self.bets = SocialHelper.sharedSocialHelper().betsList
        addImageTitle()
        setupBetListTable()
        self.betsListTableView.reloadData()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bets = SocialHelper.sharedSocialHelper().betsList
        setupBetListTable()
        
        DispatchQueue.main.async {
            self.betsListTableView.reloadData()
        }
        super.viewWillAppear(animated)
    }
    
    func addImageTitle() {

        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFill
        let logo = UIImage(named: "bookieappiconround")
        imageView.image = logo
        self.navigationItem.titleView = imageView
    }
    
    func setupBetListTable() {
        betsListTableView.delegate = self
        betsListTableView.dataSource = self
        betsListTableView.estimatedRowHeight = 150
        betsListTableView.rowHeight = UITableView.automaticDimension
        
        self.createBetButton.layer.backgroundColor = UIColor(red: 74/255.0, green: 144/255.0, blue: 226/255.0, alpha: 1).cgColor
        self.createBetButton.setTitleColor(.white, for: UIControl.State())
        self.createBetButton.titleLabel?.textColor = .white
        self.createBetButton.layer.borderWidth = 0
        self.createBetButton.layer.cornerRadius = 10
        
        DispatchQueue.main.async {
            self.betsListTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? BetView {
            destination.bet = self.selectedBet
        }
    }


    @IBAction func createBetTapped(_ sender: Any) {
        guard let overUnderView  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "overUnderView") as? OverUnderViewController else {
            print("Could not instantiate card back full vc")
            return
        }
        self.performSegue(withIdentifier: "toCreateBet", sender: self)
    }
    
    func toFullBet(bet: CreatedBet) {
        guard let fullBetView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "fullBetView") as? BetView else {
            print("Could not instantiate events card back VC from Branch link")
            return
        }
        fullBetView.bet = bet
        self.selectedBet = bet
        self.performSegue(withIdentifier: "tofullBetView", sender: self)
        
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension BetsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bets!.count != 0 {
        return bets!.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = betsListTableView.dequeueReusableCell(withIdentifier: "betListViewCell", for: indexPath) as? BetsListTableCell
        let bet = bets![indexPath.item]
        cell!.contr = self
        cell!.bet = bet
        cell!.updateCell(bet: bet)

        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.betsListTableView.dequeueReusableCell(withIdentifier: "betListViewCell", for: indexPath) as! BetsListTableCell
        let bet = bets![indexPath.item]
        self.toFullBet(bet: bet)
    }
}

