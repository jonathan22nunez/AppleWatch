//
//  Child.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/14/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import Foundation

class Child: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(childId, forKey: "childId")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(feedingTypePref, forKey: "feedingTypePref")
        aCoder.encode(dob, forKey: "dob")
        aCoder.encode(medicalInfo, forKey: "medicalInfo")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(firstName: "", lastName: "", dob: Date())
        
        childId = aDecoder.decodeObject(forKey: "childId") as? String
        firstName = (aDecoder.decodeObject(forKey: "firstName") as? String)!
        lastName = (aDecoder.decodeObject(forKey: "lastName") as? String)!
        feedingTypePref = aDecoder.decodeObject(forKey: "feedingTypePref") as! String
        dob = (aDecoder.decodeObject(forKey: "dob") as? Date)!
        medicalInfo = aDecoder.decodeObject(forKey: "medicalInfo") as! String
    }
    
    var childId: String?
    var firstName: String
    var lastName: String
    var feedingTypePref = "nurse"
    var dob: Date
    var medicalInfo = ""
    
    var dobString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: dob)
    }
    
    var generateChildId: String {
        let uniqueNumId = Int.random(in: 1000...9999)
        childId = lastName + firstName + String(uniqueNumId)
        return childId!
    }
    
    init(firstName: String, lastName: String, dob: Date) {
        self.firstName = firstName
        self.lastName = lastName
        self.dob = dob
    }
    
    convenience init(childId: String, firstName: String, lastName: String, dob: Date) {
        self.init(firstName: firstName, lastName: lastName, dob: dob)
        
        self.childId = childId
    }
}
