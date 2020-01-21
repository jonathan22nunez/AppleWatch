//
//  BottleLogsDBHelper.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/24/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import Foundation

struct BottleLogsDBHelper: DBHelperProtocol {
    
    static let tableName = "bottle"
    static let startingAmount = "startingAmount"
    static let endingAmount = "endingAmount"
    static let dateTime = "dateTime"
    
    static let createTableString = """
    CREATE TABLE IF NOT EXISTS \(tableName) (
    _id INTEGER PRIMARY KEY AUTOINCREMENT,
    \(childId) TEXT,
    \(startingAmount) REAL,
    \(endingAmount) REAL,
    \(dateTime) TEXT);
    """
    
    static let insertIntoTableString = """
    INSERT INTO \(tableName) (\(childId), \(startingAmount), \(endingAmount), \(dateTime))
    VALUES (?, ?, ?, ?);
    """
    
    static let queryTableString = """
    SELECT \(childId), \(startingAmount), \(endingAmount), \(dateTime)
    FROM \(tableName)
    WHERE \(childId) = ?;
    """
}
