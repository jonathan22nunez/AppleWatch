//
//  SleepLogsDBHelper.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/15/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import Foundation

struct SleepLogDBHelper: DBHelperProtocol {
    
    static let tableName = "sleep"
    static let startDateTime = "startDateTime"
    static let duration = "duration"
    
    static let createTableString = """
    CREATE TABLE IF NOT EXISTS \(tableName) (
    _id INTEGER PRIMARY KEY AUTOINCREMENT,
    \(childId) TEXT,
    \(startDateTime) TEXT,
    \(duration) REAL);
    """
    
    static let insertIntoTableString = """
    INSERT INTO \(tableName) (\(childId), \(startDateTime), \(duration))
    VALUES (?, ?, ?);
    """
    
    static let queryTableString = """
    SELECT \(childId), \(startDateTime), \(duration)
    FROM \(tableName)
    WHERE \(childId) = ?;
    """
}
