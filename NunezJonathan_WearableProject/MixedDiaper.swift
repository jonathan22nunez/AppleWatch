//
//  MixDiaper.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/12/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import Foundation

class MixedDiaper: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(childId, forKey: "childId")
        aCoder.encode(mixed, forKey: "mixed")
        aCoder.encode(color, forKey: "color")
        aCoder.encode(texture, forKey: "texture")
        aCoder.encode(dateTime, forKey: "dateTime")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(childId: "", isDiaper: false, color: "", texture: "", datetime: Date())
        
        childId = (aDecoder.decodeObject(forKey: "childId") as? String)!
        mixed = aDecoder.decodeBool(forKey: "mixed")
        color = (aDecoder.decodeObject(forKey: "color") as? String)!
        texture = (aDecoder.decodeObject(forKey: "texture") as? String)!
        dateTime = (aDecoder.decodeObject(forKey: "dateTime") as? Date)!
    }
    
    var childId: String
    var mixed: Bool
    var color: String
    var texture: String
    var dateTime: Date
    
    var diaperType: String {
        if mixed {
            return "Mixed"
        } else {
            return "Poopy"
        }
    }
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: dateTime)
    }
    
    init(childId: String, isDiaper mixed: Bool, color: String, texture: String, datetime: Date) {
        self.childId = childId
        self.mixed = mixed
        self.color = color
        self.texture = texture
        self.dateTime = datetime
    }
}
