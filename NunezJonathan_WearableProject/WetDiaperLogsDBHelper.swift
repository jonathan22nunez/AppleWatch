//
//  WetDiaperLogsDBHelper.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/24/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import Foundation

struct WetDiaperLogsDBHelper: DBHelperProtocol{
    
    static let tableName = "wet"
    static let dateTime = "dateTime"
    
    static let createTableString = """
    CREATE TABLE IF NOT EXISTS \(tableName) (
    _id INTEGER PRIMARY KEY AUTOINCREMENT,
    \(childId) TEXT,
    \(dateTime) TEXT);
    """
    
    static let insertIntoTableString = """
    INSERT INTO \(tableName) (\(childId), \(dateTime))
    VALUES (?, ?);
    """
    
    static let queryTableString = """
    SELECT \(childId), \(dateTime)
    FROM \(tableName)
    WHERE \(childId) = ?;
    """
    
}
