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
    
    
    
    func followAccounts(accounts: [TwitterAccount], completion: @escaping ((_ error: Error?) -> Void)){
        guard let userID = Twitter.sharedInstance().sessionStore.session()?.userID else { return }
        let client = TWTRAPIClient(userID: userID)
        let followEndPoint = "https://api.twitter.com/1.1/friendships/create.json"
        var clientError: NSError?
        
        
        
        for account in accounts {
            guard let screenName = account.screenName else { return }
            let params = ["screen_name": "\(screenName)"]
            let request = client.urlRequest(withMethod: "POST", url: followEndPoint, parameters: params, error: &clientError)
            client.sendTwitterRequest(request, completion: { (response, data, error) in
                
                    DispatchQueue.main.async {
                        completion(error)
                    
                    
                }
               
            })
            

        }
        
    }
        func unfollowAccounts(accounts: [TwitterAccount], completion: @escaping ((_ error: Error?) -> Void)) {
            guard let userID = Twitter.sharedInstance().sessionStore.session()?.userID else { return }
            let client = TWTRAPIClient(userID: userID)
            let followEndPoint = "https://api.twitter.com/1.1/friendships/destroy.json"
            var clientError: NSError?
            
            
            
            for account in accounts {
                guard let screenName = account.screenName else { return }
                let params = ["screen_name": "\(screenName)"]
                let request = client.urlRequest(withMethod: "POST", url: followEndPoint, parameters: params, error: &clientError)
                client.sendTwitterRequest(request, completion: { (response, data, error) in
                    DispatchQueue.main.async {
                        completion(error)
                }
                
                
            })
        
}

}
}
