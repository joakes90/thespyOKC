//
//  TwitterController.swift
//  The Spy fm
//
//  Created by Justin Oakes on 6/18/15.
//  Copyright (c) 2015 Justin Oakes. All rights reserved.
//

import UIKit
import Accounts
import Social


class TwitterController: NSObject {
    
    static let sharedInstance: TwitterController = TwitterController()
    

    
    var tweets: [NSDictionary]?
    
    
    func getNewTweets() {
        let account: ACAccountStore = ACAccountStore()
        let accountType: ACAccountType = account.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        account.requestAccessToAccountsWithType(accountType, options: nil) { (granted, error) -> Void in
            if granted {
                let accounts: [AnyObject] = account.accountsWithAccountType(accountType)
                
                if accounts.count > 0 {
                    let twitterAccount: ACAccount = accounts.last as! ACAccount
                    let requestString: String = "https://api.twitter.com/1.1/statuses/user_timeline.json"
                    let requestURL: NSURL = NSURL(string: requestString)!
                    let params: NSMutableDictionary = ["screen_name" : "thespyfm", "count" : "100"]
                    
                    let posts: SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: requestURL, parameters: params as [NSObject : AnyObject])
                    posts.account = twitterAccount
                    
                    posts.performRequestWithHandler({ (data, responce, error) -> Void in
                            do {
                                self.tweets = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as? [NSDictionary]
                            } catch {
                                print(error)
                            }
                            
                            
                        
                        if self.tweets != nil {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                NSNotificationCenter.defaultCenter().postNotificationName("newTweets", object: nil)
                            })
                            
                        }
                    })
                }
                
            }
        }
    }

}

