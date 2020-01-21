//
//  BottleFeed.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/12/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import Foundation

class BottleFeed: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(childId, forKey: "childId")
        aCoder.encode(startingAmount, forKey: "startingAmount")
        aCoder.encode(endingAmount, forKey: "endingAmount")
        aCoder.encode(dateTime, forKey: "dateTime")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(childId: "", startingAmount: 0.0, endingAmount: 0.0, date: Date())
        
        childId = (aDecoder.decodeObject(forKey: "childId") as? String)!
        startingAmount = aDecoder.decodeDouble(forKey: "startingAmount")
        endingAmount = aDecoder.decodeDouble(forKey: "endingAmount")
        dateTime = (aDecoder.decodeObject(forKey: "dateTime") as? Date)!
    }
    
    var childId: String
    var startingAmount: Double
    var endingAmount: Double
    var dateTime: Date
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: dateTime)
    }
    
    var startTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: dateTime)
    }
    
    var startAmount: String {
        let amount = Int(startingAmount)
        return String(amount) + " oz"
    }
    
    var endAmount: String {
        let amount = Int(endingAmount)
        return String(amount) + " oz"
    }
    
    init(childId: String, startingAmount: Double, endingAmount: Double, date: Date) {
        self.childId = childId
        self.startingAmount = startingAmount
        self.endingAmount = endingAmount
        self.dateTime = date
    }
}
