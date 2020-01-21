//
//  NurseLogsDBHelper.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/23/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import Foundation

struct NurseLogsDBHelper: DBHelperProtocol {
    
    static let tableName = "nurse"
    static let startDateTime = "startDateTime"
    static let leftDuration = "leftDuration"
    static let rightDuration = "rightDuration"
    
    
    static let createTableString = """
    CREATE TABLE IF NOT EXISTS \(tableName) (
    _id INTEGER PRIMARY KEY AUTOINCREMENT,
    \(childId) TEXT,
    \(startDateTime) TEXT,
    \(leftDuration) REAL,
    \(rightDuration) REAL);
    """
    
    static let insertIntoTableString = """
    INSERT INTO \(tableName) (\(childId), \(startDateTime), \(leftDuration), \(rightDuration))
    VALUES (?, ?, ?, ?);
    """
    
    static let queryTableString = """
    SELECT \(childId), \(startDateTime), \(leftDuration), \(rightDuration)
    FROM \(tableName)
    WHERE \(childId) = ?;
    """
}
