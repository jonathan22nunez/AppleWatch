//
//  AppDelegate.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/12/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import UIKit
import SQLite3
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var session: WCSession? {
        didSet{
            if let session = session{
                session.delegate = self
                session.activate()
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if WCSession.isSupported() {
            session = WCSession.default
        }
        
        if TrackerLogsDBFileManager.createDatabaseFileIfNotExist() != nil {
            let db: TrackerLogsDatabase
            do {
                db = try TrackerLogsDatabase.openDatabase(path: TrackerLogsDBFileManager.getTrackerLogsDBFilePath()!)
                try db.createChildrenTable()
                try db.createSleepTable()
                try db.createNurseTable()
                try db.createBottleTable()
                try db.createWetTable()
                try db.createMixedTable()
            } catch TrackerLogsDBError.OpenDatabase(let message) {
                print(message)
            } catch {
                print("Critical Error")
            }
        }
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let childId = UserDefaults.standard.string(forKey: TrackerLogsDBFileManager.childId) {
            DispatchQueue.main.async {
                if let messageData = message["sleepEvent"] as? Data {
                    self.prepareSleepEventForDB(messageData: messageData)
                } else if let messageData = message["nurseEvent"] as? Data {
                    self.prepareNurseEventForDB(messageData: messageData)
                } else if let messageData = message["bottleEvent"] as? Data {
                    self.prepareBottleEventForDB(messageData: messageData)
                } else if let messageData = message["wetDiaperEvent"] as? Data {
                    self.prepareWetDiaperEventForDB(messageData: messageData)
                } else if let messageData = message["mixedDiaperEvent"] as? Data {
                    self.prepareMixedDiaperEventForDB(childId: childId, messageData: messageData)
                }
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            if (message["getChild"] as? Bool != nil) {
                if let childId = UserDefaults.standard.string(forKey: TrackerLogsDBFileManager.childId) {
                    let childName = UserDefaults.standard.string(forKey: childId)
                    let feedingTypePref = UserDefaults.standard.string(forKey: "feedingType" + childId)
                    let medicalInfo = UserDefaults.standard.string(forKey: "medicalInfo" + childId)
                    
                    replyHandler(["childId": childId, "childName": childName!, "feedingType": feedingTypePref!, "medicalInfo": medicalInfo!])
                } else {
                    replyHandler(["childName": "No Child Available"])
                }
            } else if (message["getChildren"] as? Bool != nil) {
                let children = self.retrieveChildrenList()
                
                for child in children {
                    child.feedingTypePref = UserDefaults.standard.string(forKey: "feedingType" + child.childId!)!
                    child.medicalInfo = UserDefaults.standard.string(forKey: "medicalInfo" + child.childId!)!
                }
                NSKeyedArchiver.setClassName("child", for: Child.self)
                
                do {
                    guard let childrenData = try? NSKeyedArchiver.archivedData(withRootObject: children, requiringSecureCoding: false) else {return}
                    
                    replyHandler(["childrenData": childrenData])
                }
            }
        }
    }
    
    // MARK: - Prepare & Insert SleepEvent
    func prepareSleepEventForDB(messageData: Data) {
        NSKeyedUnarchiver.setClass(Sleep.self, forClassName: "sleep")
        
        if let sleepEvent = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(messageData) as? Sleep {
            self.insertIntoSleepDB(childId: sleepEvent.childId, startDateTime: sleepEvent.startDatetime, duration: sleepEvent.duration)
        }
    }
    
    func insertIntoSleepDB(childId: String, startDateTime: Date, duration: Double) {
        let db: TrackerLogsDatabase
        
        do {
            db = try TrackerLogsDatabase.openDatabase(path: TrackerLogsDBFileManager.getTrackerLogsDBFilePath()!)
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .short
            
            try db.insertIntoSleepTable(childId: childId, startDateTime: formatter.string(from: startDateTime), duration: duration)
            
        } catch {
            print("Critical Error")
        }
    }
    
    // MARK: - Prepare & Insert NurseEvent
    func prepareNurseEventForDB(messageData: Data) {
        NSKeyedUnarchiver.setClass(NurseFeed.self, forClassName: "nurse")
        
        if let nurseEvent = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(messageData) as? NurseFeed {
            self.insertIntoNurseDB(childId: nurseEvent.childId, startDateTime: nurseEvent.startDateTime, leftDuration: nurseEvent.leftDuration, rightDuration: nurseEvent.rightDuration)
        }
    }
    
    func insertIntoNurseDB(childId: String, startDateTime: Date, leftDuration: Double, rightDuration: Double) {
        let db: TrackerLogsDatabase
        
        do {
            db = try TrackerLogsDatabase.openDatabase(path: TrackerLogsDBFileManager.getTrackerLogsDBFilePath()!)
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .short
            
            try db.insertIntoNurseTable(childId: childId, startDateTime: formatter.string(from: startDateTime), leftDuration: leftDuration, rightDuration: rightDuration)
            
        } catch {
            print("Critical Error")
        }
    }
    
    // MARK: - Prepare & Insert BottleEvent
    func prepareBottleEventForDB(messageData: Data) {
        NSKeyedUnarchiver.setClass(BottleFeed.self, forClassName: "bottle")
        
        if let bottleEvent = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(messageData) as? BottleFeed {
            self.insertIntoBottleDB(childId: bottleEvent.childId, startingAmount: bottleEvent.startingAmount, endingAmount: bottleEvent.endingAmount, dateTime: bottleEvent.dateTime)
        }
    }
    
    func insertIntoBottleDB(childId: String, startingAmount: Double, endingAmount: Double, dateTime: Date) {
        let db: TrackerLogsDatabase
        
        do {
            db = try TrackerLogsDatabase.openDatabase(path: TrackerLogsDBFileManager.getTrackerLogsDBFilePath()!)
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .short
            
            try db.insertIntoBottleTable(childId: childId, startingAmount: startingAmount, endingAmount: endingAmount, dateTime: dateTime)
            
        } catch {
            print("Critical Error")
        }
    }
    
    // MARK: - Prepare & Insert WetDiaperEvent
    func prepareWetDiaperEventForDB(messageData: Data) {
        NSKeyedUnarchiver.setClass(WetDiaper.self, forClassName: "wetDiaper")
        
        if let wetDiaperEvent = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(messageData) as? WetDiaper {
            self.insertIntoWetDiaperDB(childId: wetDiaperEvent.childId, dateTime: wetDiaperEvent.dateTime)
        }
    }
    
    func insertIntoWetDiaperDB(childId: String, dateTime: Date) {
        let db: TrackerLogsDatabase
        
        do {
            db = try TrackerLogsDatabase.openDatabase(path: TrackerLogsDBFileManager.getTrackerLogsDBFilePath()!)
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .short
            
            try db.insertIntoWetTable(childId: childId, dateTime: dateTime)
            
        } catch {
            print("Critical Error")
        }
    }
    
    // MARK: - Prepare & Insert MixedDiaperEvent
    func prepareMixedDiaperEventForDB(childId: String, messageData: Data) {
        NSKeyedUnarchiver.setClass(MixedDiaper.self, forClassName: "mixedDiaper")
        
        if let mixedDiaperEvent = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(messageData) as? MixedDiaper {
            self.insertIntoMixedDiaperDB(childId: childId, mixed: mixedDiaperEvent.mixed, color: mixedDiaperEvent.color, texture: mixedDiaperEvent.texture, dateTime: mixedDiaperEvent.dateTime)
        }
    }
    
    func insertIntoMixedDiaperDB(childId: String, mixed: Bool, color: String, texture: String, dateTime: Date) {
        let db: TrackerLogsDatabase
        
        do {
            db = try TrackerLogsDatabase.openDatabase(path: TrackerLogsDBFileManager.getTrackerLogsDBFilePath()!)
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .short
            
            try db.insertIntoMixedTable(childId: childId, mixed: mixed, color: color, texture: texture, dateTime: dateTime)
            
        } catch {
            print("Critical Error")
        }
    }
    
    private func retrieveChildrenList() -> [Child] {
        
        let db: TrackerLogsDatabase
        
        do {
            db = try TrackerLogsDatabase.openDatabase(path: TrackerLogsDBFileManager.getTrackerLogsDBFilePath()!)
            
             return try db.queryChildrenTable()
        } catch TrackerLogsDBError.OpenDatabase(let message) {
            print(message)
        } catch {
            print("Critical Error")
        }
        
        return [Child]()
    }
}

