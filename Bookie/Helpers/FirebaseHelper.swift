//
//  FirebaseHelper.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/11/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class FirebaseHelper {
    let db = Firestore.firestore()
    let socHelper = SocialHelper.sharedSocialHelper()
    let userID = Auth.auth().currentUser?.uid
    let defaults = UserDefaults.standard
    
    func addUserNameAndName(userName: String, name: String) {
        
        if  let userID = Auth.auth().currentUser?.uid {
            let usersRef = db.collection("users")
            
            // Add a new document with a generated ID
            let userData : [String: Any] = [
                "ID" : userID,
                "UserName" : userName,
                "Name" : name
            ]
            usersRef.document(userID).setData(userData)
        }
    }
    
    func loadAllBets(completion: @escaping ([CreatedBet])-> Void) {
        var bets : [CreatedBet] = []
        var placedBets : [PlacedBet] = []
        let betListRef = db.collection("Bets")
        let userID = Auth.auth().currentUser?.uid
        
        betListRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(bets)
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                        let betName = document.documentID
                        let bet = document.data()
                        let betType = bet["betType"] as! String
                        let betValue = bet["betValue"] as! Double
                        let ubookieID = bet["bookieID"] as! String
                        let bookieuserName = bet["bookieUsername"] as! String
                        let bookieName = bet["bookieName"] as! String
                        let overValue = bet["overOdds"] as! String
                        let underValue = bet["underOdds"] as! String
                    
                    self.getBettersInCreatedBet(betName: betName) {
                        tPlacedBets in
                        placedBets = tPlacedBets
                    }

                    let tempBet = CreatedBet(bookieUsername: bookieuserName, bookieName: bookieName, bookieID: ubookieID, betName: betName, betType: betType, betValue: betValue, overValue: overValue, underValue: underValue, placedBets: placedBets)
                    bets.append(tempBet)
                }
                SocialHelper().betsList = bets
                completion(bets)
            }
        }
    }
    
    func sendCreatedBetToFirebase(userID: String, bet: CreatedBet) {
        
        let betData: [String: Any] = [
                "bookieID": userID,
                "betType": bet.betType,
                "betValue": bet.betValue,
                "bookieName": bet.bookieName,
                "bookieUsername": bet.bookieUsername,
                "overOdds": bet.overValue,
                "underOdds": bet.underValue
        ]
        
        db.collection("users").document(userID).collection("createdBets").addDocument(data: betData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }

        
        db.collection("Bets").document(bet.betName).setData(betData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func sendCreatedbetToUser(userID: String, bet: CreatedBet) {
        let betData: [String: Any] = [
                "betType": bet.betType,
                "betValue": bet.betValue,
                "bookieName": bet.bookieName,
                "bookieUsername": bet.bookieUsername,
                "overOdds": bet.overValue,
                "underOdds": bet.underValue
            ]

        let placedBetsRef = db.collection("users").document("placedBets").collection(bet.betName)
        placedBetsRef.addDocument(data: betData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func addUserBetToFirebase(userID: String, bet: PlacedBet) {
        let userBetRef = db.collection("users").document(userID)
        let betForBookieRef = db.collection("Bets").document(bet.betName).collection("placedBets")
        var totalBet : Int = 0
        if bet.overMoneyTotal != 0 {
            totalBet = bet.overMoneyTotal
        } else {
            totalBet = bet.overMoneyTotal
        }
        let betName = bet.betName
        let defaults = UserDefaults.standard
        let betterUserName = defaults.object(forKey: "UserName") as! String
        let betterName = defaults.object(forKey: "Name") as! String
        let betData : [String: Any] = [
                "userID": userID,
                "betterUserName": betterUserName,
                "betterName": betterName,
                "betName" : betName,
                "betType": bet.betType,
                "betValue": bet.betValue,
                "bookieID" : bet.bookieID,
                "bookieName": bet.bookieName,
                "bookieUsername": bet.bookieUsername,
                "overOdds": bet.overValue,
                "underOdds": bet.underValue,
                "totalbet" : totalBet,
                "totalOver" : bet.overMoneyTotal,
                "totalUnder" : bet.underMoneyTotal
            ]

        betForBookieRef.document(userID).setData(betData,merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }

    }
    
    func getUserCreatedBets(userID: String, completion: @escaping ([CreatedBet]) -> Void) {
        var createdBets : [CreatedBet] = []
        let betsList = SocialHelper.sharedSocialHelper().betsList
        let userName = defaults.object(forKey: "UserName") as! String
        createdBets = (betsList.filter{($0.bookieUsername == userName)})
        completion(createdBets)
    }
    func getUserPlacedBets(userID: String, completion: @escaping ([PlacedBet]) -> Void) {
        let myGroup = DispatchGroup()
        var placedBets : [PlacedBet] = []
        let betsList = SocialHelper.sharedSocialHelper().betsList
        for bet in betsList {
            myGroup.enter()
            let betName = bet.betName
            getPlacedBets(userID: self.userID!, betName: betName) {
                bets in
                placedBets.append(contentsOf: bets)
                myGroup.leave()
            }
        }
        myGroup.notify(queue: DispatchQueue.global(qos: .default), execute: {
            SocialHelper.sharedSocialHelper().myBets = placedBets
            completion(placedBets)
        })
    }
    
    func getPlacedBets(userID: String, betName: String, completion: @escaping ([PlacedBet]) -> Void) {
        var placedBets: [PlacedBet] = []
        let placedBetRef = db.collection("Bets").document(betName).collection("placedBets")
        placedBetRef.getDocuments { (snapshot, err) in
            if let err = err {
                print("\(err.localizedDescription)")
                completion(placedBets)
            } else {
                for document in (snapshot?.documents)! {
                    print("\(document.documentID) and \((self.userID)!)")
                    if document.documentID.contains(self.userID!) {
                        print("DocumentID and userID matches")
                        
                        print("\(document.documentID) => \(document.data())")
                        let bet = document.data()
                        let betName = betName
                        var betterUserName = ""
                        var betterName = "Dice"
                        if let betVal = bet["betterName"] as? String {
                            betterName = betVal
                        }
                        if let uVal = bet["betterUserName"] as? String {
                            betterUserName = uVal
                        }
                        let betType = bet["betType"] as! String
                        let betValue = bet["betValue"] as! Double
                        let bookieusername = bet["bookieUsername"] as! String
                        let bookieName = bet["bookieName"] as! String
                        let overValue = bet["overOdds"] as! String
                        let underValue = bet["underOdds"] as! String
                        let overMoneyTotal = bet["totalOver"] as! Int
                        let underMoneyTotal = bet["totalUnder"] as! Int
                        
                        
                        let tempBet = PlacedBet(betterName: betterName, betterUserName: betterUserName, bookieUsername: bookieusername, bookieName: bookieName, bookieID: userID, betName: betName, betType: betType, betValue: betValue, overValue: overValue, underValue: underValue, overMoneyTotal: overMoneyTotal, underMoneyTotal: underMoneyTotal)
                        print("The tempBet is \(tempBet)")
                        placedBets.append(tempBet)
                    } else {
                        print("The documentID and UserID does not match")
                    }
                }
                completion(placedBets)
            }
        }
    }
    
    func submitFinalValue(betName: String, finalValue: Double) {
        
        let betRef = db.collection("Bets").document(betName)
        let data = ["finalValue" : finalValue]
        betRef.updateData(data)
    }
    
    
    func getBettersInCreatedBet(betName: String, completion: @escaping ([PlacedBet]) -> Void) {
        let betRef = db.collection("Bets").document(betName)
        var placedBets : [PlacedBet] = []
        betRef.collection("placedBets").getDocuments { (snapshot, err) in
            if let err = err {
                print("\(err.localizedDescription)")
                completion(placedBets)
            } else {
                for document in (snapshot?.documents)! {
                        
                        print("\(document.documentID) => \(document.data())")
                        let bet = document.data()
                        let betName = betName
                        var betterName = "Anon"
                        var betterUserName = ""
                        if let betVal = bet["betterName"] as? String {
                            betterName = betVal
                        }
                        if let uVal = bet["betterUserName"] as? String {
                            betterUserName = uVal
                        }
                        let betType = bet["betType"] as! String
                        let betValue = bet["betValue"] as! Double
                        let bookieusername = bet["bookieUsername"] as! String
                        let bookieName = bet["bookieName"] as! String
                        let bookieID = bet["bookieID"] as! String
                        let overValue = bet["overOdds"] as! String
                        let underValue = bet["underOdds"] as! String
                        let overMoneyTotal = bet["totalOver"] as! Int
                        let underMoneyTotal = bet["totalUnder"] as! Int
                        
                        let tempBet = PlacedBet(betterName: betterName, betterUserName: betterUserName, bookieUsername: bookieusername, bookieName: bookieName, bookieID: bookieID, betName: betName, betType: betType, betValue: betValue, overValue: overValue, underValue: underValue, overMoneyTotal: overMoneyTotal, underMoneyTotal: underMoneyTotal)
                        print("The tempBet is \(tempBet)")
                        placedBets.append(tempBet)
                }
                completion(placedBets)
            }
        }
    }
    
    func getUsers(completion: @escaping ([User]) -> Void) {
        let usersRef = db.collection("users")
        var users : [User] = []
        
        usersRef.getDocuments { (snapshot, err) in
            if let err = err {
                print("\(err.localizedDescription)")
                completion(users)
            } else {
                for document in (snapshot?.documents)! {
                    let user = document.data()
                    let userID = document.documentID
                    
                        let username = user["UserName"] as! String
                        let name = user["Name"] as! String
                        let tempUser = User(userID: userID, username: username, name: name)
                        users.append(tempUser)

                }
                completion(users)
            }
        }
    }
}
