//
//  Schedule+CoreDataClass.swift
//  TwitterApp
//
//  Created by Jake SWEDENBURG on 10/6/16.
//  Copyright © 2016 Jake Swedenbug. All rights reserved.
//

import Foundation
import CoreData


public class Schedule: NSManagedObject {

    convenience init(repeating: Bool, startTime: NSDate = NSDate(), endTime: NSDate = NSDate(), title: String = "Fantasy Football", enabled: Bool = true, twitterAccounts: [TwitterAccount] = [], days: [daysOfWeek] = [], context: NSManagedObjectContext = CoreDataStack.context){
        
        
        
        self.init(context: context)
        self.repeating = repeating
        self.startTime = startTime as NSDate
        self.endTime = endTime as NSDate
        self.twitterAccounts = NSSet(array: twitterAccounts)
        self.days = NSSet(array: days)
        self.title = title
        self.enabled = enabled
        
        
        
        
    }

    
}