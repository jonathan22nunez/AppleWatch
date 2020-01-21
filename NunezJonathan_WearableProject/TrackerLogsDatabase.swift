//
//  TrackerLogsDatabase.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/13/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import Foundation
import SQLite3

enum TrackerLogsDBError: Error {
    case OpenDatabase(message: String)
    case Prepare(message: String)
    case Step(message: String)
}

class TrackerLogsDatabase {
    
    private let dbHelper = ChildrenDBHelper()
    private let sleepDBHelper = SleepLogDBHelper()
     private let dbPointer: OpaquePointer?
    private let dateFormatter = DateFormatter()
    
    private init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
        
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
    }
    
    deinit {
        sqlite3_close(dbPointer)
    }
    
    static func openDatabase(path: String) throws -> TrackerLogsDatabase {
        var db: OpaquePointer? = nil
        
        if sqlite3_open(path, &db) == SQLITE_OK {
            return TrackerLogsDatabase(dbPointer: db)
        } else {
            defer {
                sqlite3_close(db)
            }
            
            throw TrackerLogsDBError.OpenDatabase(message: "Error opening database")
        }
    }
    
    private func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer? = nil
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            throw TrackerLogsDBError.Prepare(message: "Error preparing statement")
        }
        return statement
    }
}

// MARK: - Children Database extension
extension TrackerLogsDatabase {
    func createChildrenTable() throws {
        let sqlStatement = try prepareStatement(sql: ChildrenDBHelper.createTableString)
        
        guard sqlite3_step(sqlStatement) == SQLITE_DONE else {
            throw TrackerLogsDBError.Step(message: "Error creating Children Table")
        }
        sqlite3_finalize(sqlStatement)
    }
    
    func insertIntoChildrenTable(childId: String, firstName: String, lastName: String, dob: String) throws {
        let sqlStatement = try prepareStatement(sql: ChildrenDBHelper.insertIntoTableString)
        let childId = NSString(string: childId)
        let firstName = NSString(string: firstName)
        let lastName = NSString(string: lastName)
        let dob = NSString(string: dob)
        
        sqlite3_bind_text(sqlStatement, 1, childId.utf8String, -1, nil)
        sqlite3_bind_text(sqlStatement, 2, firstName.utf8String, -1, nil)
        sqlite3_bind_text(sqlStatement, 3, lastName.utf8String, -1, nil)
        sqlite3_bind_text(sqlStatement, 4, dob.utf8String, -1, nil)
        
        if sqlite3_step(sqlStatement) == SQLITE_DONE {
            print("Successfully added (child) into children table")
        }
        
        sqlite3_finalize(sqlStatement)
    }
    
    func queryChildrenTable() throws -> [Child]{
        
        var childrenList = [Child]()
        let sqlStatement = try prepareStatement(sql: ChildrenDBHelper.queryTableString)
        
        while sqlite3_step(sqlStatement) == SQLITE_ROW {
            let queryResultCol1 = sqlite3_column_text(sqlStatement, 0)
            let childId = String(cString: queryResultCol1!)
            let queryResultCol2 = sqlite3_column_text(sqlStatement, 1)
            let firstName = String(cString: queryResultCol2!)
            let queryResultCol3 = sqlite3_column_text(sqlStatement, 2)
            let lastName = String(cString: queryResultCol3!)
            let queryResultCol4 = sqlite3_column_text(sqlStatement, 3)
            let dob = String(cString: queryResultCol4!)
            
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            childrenList.append(Child(childId: childId, firstName: firstName, lastName: lastName, dob: formatter.date(from: dob)!))
        }
        
        return childrenList
    }
}

// MARK: - Sleep Database extension
extension TrackerLogsDatabase {
    func createSleepTable() throws {
        let sqlStatement = try prepareStatement(sql: SleepLogDBHelper.createTableString)
        
        guard sqlite3_step(sqlStatement) == SQLITE_DONE else {
            throw TrackerLogsDBError.Step(message: "Error creating Sleep Table")
        }
        
        sqlite3_finalize(sqlStatement)
    }
    
    func insertIntoSleepTable(childId: String, startDateTime: String, duration: Double) throws {
        let sqlStatement = try prepareStatement(sql: SleepLogDBHelper.insertIntoTableString)
        let childId = NSString(string: childId)
        let startDateTime = NSString(string: startDateTime)
        
        sqlite3_bind_text(sqlStatement, 1, childId.utf8String, -1, nil)
        sqlite3_bind_text(sqlStatement, 2, startDateTime.utf8String, -1, nil)
        sqlite3_bind_double(sqlStatement, 3, duration)
        
        if sqlite3_step(sqlStatement) == SQLITE_DONE {
            print("Successfully added (sleep) into sleep table")
        }
    }
    
    func querySleepTable(childId: String) throws -> [Sleep] {
        
        let childId = NSString(string: childId)
        var sleepList = [Sleep]()
        let sqlStatement = try prepareStatement(sql: SleepLogDBHelper.queryTableString)
        
        sqlite3_bind_text(sqlStatement, 1, childId.utf8String, -1, nil)
        
        while sqlite3_step(sqlStatement) == SQLITE_ROW {
            let queryResultCol1 = sqlite3_column_text(sqlStatement, 0)
            let childId = String(cString: queryResultCol1!)
            let queryResultCol2 = sqlite3_column_text(sqlStatement, 1)
            let startDateTimeString = String(cString: queryResultCol2!)
            let duration = sqlite3_column_double(sqlStatement, 2)
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .short
            
            sleepList.append(Sleep(childId: childId, startDateTime: formatter.date(from: startDateTimeString)!, durationIn: duration))
        }
        
        return sleepList
    }
}

// MARK: - Nurse Database extension
extension TrackerLogsDatabase {
    func createNurseTable() throws {
        let sqlStatement = try prepareStatement(sql: NurseLogsDBHelper.createTableString)
        
        guard sqlite3_step(sqlStatement) == SQLITE_DONE else {
            throw TrackerLogsDBError.Step(message: "Error creating Nurse Table")
        }
        
        sqlite3_finalize(sqlStatement)
    }
    
    func insertIntoNurseTable(childId: String, startDateTime: String, leftDuration: Double, rightDuration: Double) throws {
        let sqlStatement = try prepareStatement(sql: NurseLogsDBHelper.insertIntoTableString)
        let childId = NSString(string: childId)
        let startDateTime = NSString(string: startDateTime)
        
        sqlite3_bind_text(sqlStatement, 1, childId.utf8String, -1, nil)
        sqlite3_bind_text(sqlStatement, 2, startDateTime.utf8String, -1, nil)
        sqlite3_bind_double(sqlStatement, 3, leftDuration)
        sqlite3_bind_double(sqlStatement, 4, rightDuration)
        
        if sqlite3_step(sqlStatement) == SQLITE_DONE {
            print("Successfully added (nurse) into sleep table")
        }
    }
    
    func queryNurseTable(childId: String) throws -> [NurseFeed] {
        
        let childId = NSString(string: childId)
        var nurseList = [NurseFeed]()
        let sqlStatement = try prepareStatement(sql: NurseLogsDBHelper.queryTableString)
        
        sqlite3_bind_text(sqlStatement, 1, childId.utf8String, -1, nil)
        
        while sqlite3_step(sqlStatement) == SQLITE_ROW {
            let queryResultCol1 = sqlite3_column_text(sqlStatement, 0)
            let childId = String(cString: queryResultCol1!)
            let queryResultCol2 = sqlite3_column_text(sqlStatement, 1)
            let startDateTimeString = String(cString: queryResultCol2!)
            let leftDuration = sqlite3_column_double(sqlStatement, 2)
            let rightDuration = sqlite3_column_double(sqlStatement, 3)
            
            nurseList.append(NurseFeed(childId: childId, startDateTime: dateFormatter.date(from: startDateTimeString)!, durationInSeconds: leftDuration, durationInSeconds: rightDuration))
        }
        
        return nurseList
    }
}

// MARK: - Bottle Database extension
extension TrackerLogsDatabase {
    func createBottleTable() throws {
        let sqlStatement = try prepareStatement(sql: BottleLogsDBHelper.createTableString)
        
        guard sqlite3_step(sqlStatement) == SQLITE_DONE else {
            throw TrackerLogsDBError.Step(message: "Error creating Bottle Table")
        }
        
        sqlite3_finalize(sqlStatement)
    }
    
    func insertIntoBottleTable(childId: String, startingAmount: Double, endingAmount: Double, dateTime: Date) throws {
        let sqlStatement = try prepareStatement(sql: BottleLogsDBHelper.insertIntoTableString)
        let childId = NSString(string: childId)
        let dateTime = NSString(string: dateFormatter.string(from: dateTime))
        
        sqlite3_bind_text(sqlStatement, 1, childId.utf8String, -1, nil)
        sqlite3_bind_double(sqlStatement, 2, startingAmount)
        sqlite3_bind_double(sqlStatement, 3, endingAmount)
        sqlite3_bind_text(sqlStatement, 4, dateTime.utf8String, -1, nil)
        
        if sqlite3_step(sqlStatement) == SQLITE_DONE {
            print("Successfully added (bottle) into sleep table")
        }
    }
    
    func queryBottleTable(childId: String) throws -> [BottleFeed] {
        
        let childId = NSString(string: childId)
        var bottleList = [BottleFeed]()
        let sqlStatement = try prepareStatement(sql: BottleLogsDBHelper.queryTableString)
        
        sqlite3_bind_text(sqlStatement, 1, childId.utf8String, -1, nil)
        
        while sqlite3_step(sqlStatement) == SQLITE_ROW {
            let queryResultCol1 = sqlite3_column_text(sqlStatement, 0)
            let childId = String(cString: queryResultCol1!)
            let startingAmount = sqlite3_column_double(sqlStatement, 1)
            let endingAmount = sqlite3_column_double(sqlStatement, 2)
            let queryResultCol4 = sqlite3_column_text(sqlStatement, 3)
            let dateTime = String(cString: queryResultCol4!)
            
            bottleList.append(BottleFeed(childId: childId, startingAmount: startingAmount, endingAmount: endingAmount, date: dateFormatter.date(from: dateTime)!))
        }
        return bottleList
    }
}

// MARK: - Wet Database extension
extension TrackerLogsDatabase {
    func createWetTable() throws {
        let sqlStatement = try prepareStatement(sql: WetDiaperLogsDBHelper.createTableString)
        
        guard sqlite3_step(sqlStatement) == SQLITE_DONE else {
            throw TrackerLogsDBError.Step(message: "Error creating Wet Table")
        }
        
        sqlite3_finalize(sqlStatement)
    }
    
    func insertIntoWetTable(childId: String, dateTime: Date) throws {
        let sqlStatement = try prepareStatement(sql: WetDiaperLogsDBHelper.insertIntoTableString)
        let childId = NSString(string: childId)
        let dateTime = NSString(string: dateFormatter.string(from: dateTime))
        
        sqlite3_bind_text(sqlStatement, 1, childId.utf8String, -1, nil)
        sqlite3_bind_text(sqlStatement, 2, dateTime.utf8String, -1, nil)
        
        if sqlite3_step(sqlStatement) == SQLITE_DONE {
            print("Successfully added (wet) into sleep table")
        }
    }
    
    func queryWetTable(childId: String) throws -> [WetDiaper] {
        
        let childId = NSString(string: childId)
        var wetList = [WetDiaper]()
        let sqlStatement = try prepareStatement(sql: WetDiaperLogsDBHelper.queryTableString)
        
        sqlite3_bind_text(sqlStatement, 1, childId.utf8String, -1, nil)
        
        while sqlite3_step(sqlStatement) == SQLITE_ROW {
            let queryResultCol1 = sqlite3_column_text(sqlStatement, 0)
            let childId = String(cString: queryResultCol1!)
            let queryResultCol2 = sqlite3_column_text(sqlStatement, 1)
            let dateTime = String(cString: queryResultCol2!)
            
            wetList.append(WetDiaper(childId: childId, dateTime: dateFormatter.date(from: dateTime)!))
        }
        return wetList
    }
}

// MARK: - Mixed Database extension
extension TrackerLogsDatabase {
    func createMixedTable() throws {
        let sqlStatement = try prepareStatement(sql: MixedDiaperLogsDBHelper.createTableString)
        
        guard sqlite3_step(sqlStatement) == SQLITE_DONE else {
            throw TrackerLogsDBError.Step(message: "Error creating Mixed Table")
        }
        
        sqlite3_finalize(sqlStatement)
    }
    
    func insertIntoMixedTable(childId: String, mixed: Bool, color: String, texture: String, dateTime: Date) throws {
        let sqlStatement = try prepareStatement(sql: MixedDiaperLogsDBHelper.insertIntoTableString)
        let childId = NSString(string: childId)
        let color = NSString(string: color)
        let texture = NSString(string: texture)
        let dateTime = NSString(string: dateFormatter.string(from: dateTime))
        
        sqlite3_bind_text(sqlStatement, 1, childId.utf8String, -1, nil)
        if mixed {
            sqlite3_bind_int(sqlStatement, 2, 1)
        } else {
            sqlite3_bind_int(sqlStatement, 2, 0)
        }
        sqlite3_bind_text(sqlStatement, 3, color.utf8String, -1, nil)
        sqlite3_bind_text(sqlStatement, 4, texture.utf8String, -1, nil)
        sqlite3_bind_text(sqlStatement, 5, dateTime.utf8String, -1, nil)
        
        if sqlite3_step(sqlStatement) == SQLITE_DONE {
            print("Successfully added (mixed) into sleep table")
        }
    }
    
    func queryMixedTable(childId: String) throws -> [MixedDiaper] {
        
        let childId = NSString(string: childId)
        var mixedList = [MixedDiaper]()
        let sqlStatement = try prepareStatement(sql: MixedDiaperLogsDBHelper.queryTableString)
        
        sqlite3_bind_text(sqlStatement, 1, childId.utf8String, -1, nil)
        
        while sqlite3_step(sqlStatement) == SQLITE_ROW {
            let queryResultCol1 = sqlite3_column_text(sqlStatement, 0)
            let childId = String(cString: queryResultCol1!)
            let queryResultCol2 = sqlite3_column_int(sqlStatement, 1)
            let queryResultCol3 = sqlite3_column_text(sqlStatement, 2)
            let color = String(cString: queryResultCol3!)
            let queryResultCol4 = sqlite3_column_text(sqlStatement, 3)
            let texture = String(cString: queryResultCol4!)
            let queryResultCol5 = sqlite3_column_text(sqlStatement, 4)
            let dateTime = String(cString: queryResultCol5!)
            
            var mixed = false
            if queryResultCol2 == 1 {
                mixed = true
            }
            
            mixedList.append(MixedDiaper(childId: childId, isDiaper: mixed, color: color, texture: texture, datetime: dateFormatter.date(from: dateTime)!))
            
        }
        return mixedList
    }
}
