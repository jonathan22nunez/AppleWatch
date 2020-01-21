//
//  NurseFeed.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/12/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import Foundation

class NurseFeed: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(childId, forKey: "childId")
        aCoder.encode(startDateTime, forKey: "startDateTime")
        aCoder.encode(leftDuration, forKey: "leftDuration")
        aCoder.encode(rightDuration, forKey: "rightDuration")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(childId: "", startDateTime: Date(), durationInSeconds: 0.0, durationInSeconds: 0.0)
        
        childId = (aDecoder.decodeObject(forKey: "childId") as? String)!
        startDateTime = (aDecoder.decodeObject(forKey: "startDateTime") as? Date)!
        leftDuration = aDecoder.decodeDouble(forKey: "leftDuration")
        rightDuration = aDecoder.decodeDouble(forKey: "rightDuration")
    }
    
    
    var childId: String
    var startDateTime: Date
    var leftDuration: Double
    var rightDuration: Double
    
    var startTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: startDateTime)
    }
    
    var leftTime: String {
        return String(format: "%02d:%02d", Int(leftDuration) / 60, Int(leftDuration) % 60)
    }
    
    var rightTime: String {
        return String(format: "%02d:%02d", Int(rightDuration) / 60, Int(rightDuration) % 60)
    }
    
    var stopTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: startDateTime.addingTimeInterval(leftDuration + rightDuration))
    }
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: startDateTime)
    }
    
    init(childId: String, startDateTime: Date, durationInSeconds left: Double, durationInSeconds right: Double) {
        self.childId = childId
        self.startDateTime = startDateTime
        self.leftDuration = left
        self.rightDuration = right
    }
}
