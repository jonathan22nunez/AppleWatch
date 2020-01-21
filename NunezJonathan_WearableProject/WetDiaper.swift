//
//  WetDiaper.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/12/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import Foundation

class WetDiaper: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(childId, forKey: "childId")
        aCoder.encode(dateTime, forKey: "dateTime")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(childId: "", dateTime: Date())
        
        childId = (aDecoder.decodeObject(forKey: "childId") as? String)!
        dateTime = (aDecoder.decodeObject(forKey: "dateTime") as? Date)!
    }
    
    var childId: String
    var dateTime: Date
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: dateTime)
    }
    
    init(childId: String, dateTime: Date) {
        self.childId = childId
        self.dateTime = dateTime
    }
}
