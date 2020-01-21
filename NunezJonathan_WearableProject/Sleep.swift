//
//  Sleep.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/12/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import Foundation

class Sleep: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(childId, forKey: "childId")
        aCoder.encode(startDatetime, forKey: "startDateTime")
        aCoder.encode(duration, forKey: "duration")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(childId: "", startDateTime: Date(), durationIn: 0.0)
        
        childId = (aDecoder.decodeObject(forKey: "childId") as? String)!
        startDatetime = (aDecoder.decodeObject(forKey: "startDateTime") as? Date)!
        duration = aDecoder.decodeDouble(forKey: "duration")
    }
    
    var childId: String
    var startDatetime: Date
    var duration: Double
    
    var startTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: startDatetime)
    }
    
    var stopTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: startDatetime.addingTimeInterval(duration))
    }
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: startDatetime)
    }
    
    var sleepDuration: String {
        let hours = Int(duration) / 60 / 60
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    init(childId: String, startDateTime: Date, durationIn seconds: Double) {
        self.childId = childId
        self.startDatetime = startDateTime
        self.duration = seconds
    }
}
