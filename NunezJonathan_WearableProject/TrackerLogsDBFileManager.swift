//
//  TrackerLogsDBFileManager.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/14/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import Foundation

struct TrackerLogsDBFileManager {
    
    private static let dbFileName = "tracker_logs.sqlite"
    static let childId = "childId"
    
    static func createDatabaseFileIfNotExist() -> String? {
        if doesDatabaseFileExist() {
            print("Database File Exists")
            return nil
        } else {
            //let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbFileName)
            print("Created Database File for the first time")
            return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbFileName).path
        }
    }
    
    static func doesDatabaseFileExist() -> Bool {
        guard let filePath = getTrackerLogsDBFilePath() else {return false} 
        let fileManager = FileManager.default
        
        // Check if file exists
        return fileManager.fileExists(atPath: filePath)
    }
    
    static func getTrackerLogsDBFilePath() -> String? {
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            return dir.appendingFormat("/" + dbFileName)
        } else {
            return nil
        }
    }
}
