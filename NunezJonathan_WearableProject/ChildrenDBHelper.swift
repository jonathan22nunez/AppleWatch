//
//  TrackerLogsDBHelper.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/14/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import Foundation

struct ChildrenDBHelper:DBHelperProtocol {
    
    static let tableName = "children"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let dob = "dob"
    
    static let createTableString = """
    CREATE TABLE IF NOT EXISTS \(tableName) (
    _id INTEGER PRIMARY KEY AUTOINCREMENT,
    \(childId) TEXT UNIQUE,
    \(firstName) TEXT,
    \(lastName) TEXT,
    \(dob) TEXT);
    """
    
    static let insertIntoTableString = """
    INSERT INTO \(tableName) (\(childId), \(firstName), \(lastName), \(dob))
    VALUES (?, ?, ?, ?);
    """
    
    static var queryTableString = """
    SELECT \(childId), \(firstName), \(lastName), \(dob)
    FROM \(tableName);
    """
}
