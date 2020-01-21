//
//  ChildrenListInterfaceController.swift
//  NunezJonathan_WearableProject WatchKit Extension
//
//  Created by Jonathan Nunez on 6/26/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class ChildrenListInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @available(watchOS 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default:nil
    
    @IBOutlet weak var childrenListTable: WKInterfaceTable!
    
    var childrenList = [(String, String, String, String)]()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        getChildren()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func getChildren() {
        let message: [String: Bool] = ["getChildren": true]
        if let session = session, session.isReachable {
            session.sendMessage(message, replyHandler: { (replyData) in
                DispatchQueue.main.async {
                    if let childrenData = replyData["childrenData"] as? Data {
                        NSKeyedUnarchiver.setClass(Child.self, forClassName: "child")
                        
                        do {
                            guard let children = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(childrenData) as? [Child] else {return}
                            
                            for child in children {
                                self.childrenList.append((child.childId!, child.firstName, child.feedingTypePref, child.medicalInfo))
                            }
                            
                            self.setupTable()
                        }
                    }
                }
            }, errorHandler: nil)
        }
    }
    
    func setupTable() {
        childrenListTable.setNumberOfRows(childrenList.count, withRowType: "childrenRow")
        
        for index in 0..<childrenListTable.numberOfRows {
            guard let controller = childrenListTable.rowController(at: index) as? ChildrenRowController else {return}
            
            controller.childNameLabel.setText(childrenList[index].1)
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        guard let controller = childrenListTable.rowController(at: rowIndex) as? ChildrenRowController else {return}
        
        controller.rowGroup.setBackgroundColor(UIColor.green)
        UserDefaults.standard.set(childrenList[rowIndex].0, forKey: "childId")
        UserDefaults.standard.set(childrenList[rowIndex].1, forKey: "childName")
        UserDefaults.standard.set(childrenList[rowIndex].2, forKey: "feedingType")
        UserDefaults.standard.set(childrenList[rowIndex].3, forKey: "medicalInfo")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
            self.pop()
        }
    }
}
