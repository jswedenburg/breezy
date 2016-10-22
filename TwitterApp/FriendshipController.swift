//
//  Friendship.swift
//  TwitterApp
//
//  Created by Jake SWEDENBURG on 10/17/16.
//  Copyright © 2016 Jake Swedenbug. All rights reserved.
//

import UIKit
import UserNotifications
import TwitterKit




class FriendshipController: NSObject{
    
    static let sharedController = FriendshipController()
    
    
    
    func followAccounts(accounts: [TwitterAccount]) {
        guard let userID = Twitter.sharedInstance().sessionStore.session()?.userID else { return }
        let client = TWTRAPIClient(userID: userID)
        let followEndPoint = "https://api.twitter.com/1.1/friendships/create.json"
        var clientError: NSError?
        
        
        
        for account in accounts {
            guard let screenName = account.screenName else { return }
            let params = ["screen_name": "\(screenName)"]
            let request = client.urlRequest(withMethod: "POST", url: followEndPoint, parameters: params, error: &clientError)
            client.sendTwitterRequest(request, completion: { (response, data, error) in
                if error != nil {
                    let alertController = UIAlertController()
                    alertController.title = "error following "
                    let action = UIAlertAction(title: "ok", style: .default, handler: nil)
                    alertController.addAction(action)
                    
                }
            })
            

        }
        
    }
        func unfollowAccounts(accounts: [TwitterAccount]) {
            guard let userID = Twitter.sharedInstance().sessionStore.session()?.userID else { return }
            let client = TWTRAPIClient(userID: userID)
            let followEndPoint = "https://api.twitter.com/1.1/friendships/destroy.json"
            var clientError: NSError?
            
            
            
            for account in accounts {
                guard let screenName = account.screenName else { return }
                let params = ["screen_name": "\(screenName)"]
                let request = client.urlRequest(withMethod: "POST", url: followEndPoint, parameters: params, error: &clientError)
                client.sendTwitterRequest(request, completion: { (response, data, error) in
                    if error != nil {
                        
                        //Do something
                        //print("Error following: \(error?.localizedDescription)")
                    }
                })
                
                
            }
        
}

}
