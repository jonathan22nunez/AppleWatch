//
//  MixedDiaperLogsDBHelper.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/24/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import Foundation

struct MixedDiaperLogsDBHelper: DBHelperProtocol {
    
    static let tableName = "mixed"
    static let mixed = "mixed"
    static let color = "color"
    static let texture = "texture"
    static let dateTime = "dateTime"
    
    static let createTableString = """
    CREATE TABLE IF NOT EXISTS \(tableName) (
    _id INTEGER PRIMARY KEY AUTOINCREMENT,
    \(childId) TEXT,
    \(mixed) INTEGER,
    \(color) TEXT,
    \(texture) TEXT,
    \(dateTime) TEXT);
    """
    
    static let insertIntoTableString = """
    INSERT INTO \(tableName) (\(childId), \(mixed), \(color), \(texture), \(dateTime))
    VALUES (?, ?, ?, ?, ?);
    """
    
    static let queryTableString = """
    SELECT \(childId), \(mixed), \(color), \(texture), \(dateTime)
    FROM \(tableName)
    WHERE \(childId) = ?;
    """
}
