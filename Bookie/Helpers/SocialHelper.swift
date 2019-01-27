//
//  SocialHelper.swift
//  Bookie
//
//  Created by Brenden Coleman on 1/14/19.
//  Copyright © 2019 Brenden Coleman. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth


//methods to work with social networks
class SocialHelper {
    var userName : String?
    var name : String?
    var betsList : [CreatedBet] = []
    var myBets : [PlacedBet] = []
    fileprivate static var info: SocialHelper?
    
    class func sharedSocialHelper() -> SocialHelper {
        if self.info == nil {
            self.info = SocialHelper()
        }
        
        return self.info!
    }
    
}
