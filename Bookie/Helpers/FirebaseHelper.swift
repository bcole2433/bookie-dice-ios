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
    
    func addUserNameAndName(userName: String, name: String) {
        
        if  let userID = Auth.auth().currentUser?.uid {
            let usersRef = db.collection("users")
            let ID = ["ID" : userID]
            let firUserName = ["UserName" : userName]
            let firName = ["Name" : name]
            
            
            // Add a new document with a generated ID
            let userData : [String: Any] = [
                "\(userID)" : [
                    ID,
                    firUserName,
                    firName
                ]
            ]
            usersRef.document(userID).setData(userData)
        }
    }
    
    func loadAllBets(completion: @escaping ([CreatedBet])-> Void) {
        var bets : [CreatedBet] = []
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
                    print(bet)
                        let betType = bet["betType"] as! String
                        let betValue = bet["betValue"] as! Double
                        let bookieuserName = bet["bookieUsername"] as! String
                        let bookieName = bet["bookieName"] as! String
                        let overValue = bet["overOdds"] as! String
                        let underValue = bet["underOdds"] as! String


                    let tempBet = CreatedBet(bookieUsername: bookieuserName, bookieName: bookieName, bookieID: userID!, betName: betName, betType: betType, betValue: betValue, overValue: overValue, underValue: underValue)
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
        let betData : [String: Any] = [
                "userID": userID,
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

//        let userBetData : [String: Any] = [
//                "userID" : userID,
//                "totalBet" : totalBet,
//                "totalOver" : bet.overMoneyTotal,
//                "totalUnder" : bet.underMoneyTotal
//        ]

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
        createdBets = (betsList.filter{($0.bookieID == userID)})
        completion(createdBets)
    }
    func getUserPlacedBets(userID: String, completion: @escaping ([PlacedBet]) -> Void) {
        //TODO grab all the bets the user made
        var placedBets : [PlacedBet] = []
        let betsList = SocialHelper.sharedSocialHelper().betsList
        for bet in betsList {
            let placedBetRef = db.collection("Bets").document(bet.betName).collection("placedBets")
            placedBetRef.getDocuments { (snapshot, err) in
                if let err = err {
                    print("\(err.localizedDescription)")
                } else {
                    for document in (snapshot?.documents)! {
                        if document.documentID == self.userID {
                            print("\(document.documentID) => \(document.data())")
                            let betName = document.documentID
                            let bet = document.data()
                            print(bet)
                            let betType = bet["betType"] as! String
                            let betValue = bet["betValue"] as! Double
                            let bookieusername = bet["bookieUsername"] as! String
                            let bookieName = bet["bookieName"] as! String
                            let overValue = bet["overOdds"] as! String
                            let underValue = bet["underOdds"] as! String
                            let overMoneyTotal = bet["totalOver"] as! Int
                            let underMoneyTotal = bet["totalUnder"] as! Int
                            
                            
                            let tempBet = PlacedBet(bookieUsername: bookieusername, bookieName: bookieName, bookieID: userID, betName: betName, betType: betType, betValue: betValue, overValue: overValue, underValue: underValue, overMoneyTotal: overMoneyTotal, underMoneyTotal: underMoneyTotal)
                            placedBets.append(tempBet)
                            
                        }
                    }
                }
            }
        }
        
        completion(placedBets)
    }
}
