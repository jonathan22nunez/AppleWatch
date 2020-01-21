//
//  InterfaceController.swift
//  NunezJonathan_WearableProject WatchKit Extension
//
//  Created by Jonathan Nunez on 6/12/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

// TODO: check if there is a childId active, otherwise disable the feature buttons and prompt creation of child profile
class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @available(watchOS 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let childName = hasLocalChildName() {
            childLabel.setText(childName)
        } else {
            getChildNameFromMainApp()
        }
    }
    
    fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default:nil
    
    override init(){
        super.init()
        session?.delegate = self
        session?.activate()
    }
    
    @IBOutlet weak var noChildAvailableLabel: WKInterfaceLabel!
    @IBOutlet weak var reloadChildButton: WKInterfaceButton!
    @IBOutlet weak var childLabel: WKInterfaceLabel!
    @IBOutlet weak var sleepTrackerButton: WKInterfaceButton!
    @IBOutlet weak var nurseTrackerButton: WKInterfaceButton!
    @IBOutlet weak var bottleTrackerButton: WKInterfaceButton!
    @IBOutlet weak var diaperChangeTrackerButton: WKInterfaceButton!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if let childName = hasLocalChildName() {
            childLabel.setText(childName)
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func reloadChildClick() {
        self.noChildAvailableLabel.setHidden(true)
        self.reloadChildButton.setHidden(true)
        getChildNameFromMainApp()
    }
    
    @IBAction func tapSelectChild(_ sender: Any) {
        DispatchQueue.main.async {
            self.pushController(withName: "childrenList", context: nil)
        }
    }
    
    @IBAction func longPressChild(_ sender: Any) {
        DispatchQueue.main.async {
            self.pushController(withName: "medicalInfo", context: nil)
        }
    }
    
    private func hasLocalChildName() -> String? {
        if let childName = UserDefaults.standard.string(forKey: "childName"), let feedingType = UserDefaults.standard.string(forKey: "feedingType") {
            self.sleepTrackerButton.setHidden(false)
            if feedingType == "nurse" {
                self.nurseTrackerButton.setHidden(false)
                self.bottleTrackerButton.setHidden(true)
            } else if feedingType == "bottle" {
                self.bottleTrackerButton.setHidden(false)
                self.nurseTrackerButton.setHidden(true)
            }
            self.diaperChangeTrackerButton.setHidden(false)
            
            return childName
        }
        
        return nil
    }
    
    private func getChildNameFromMainApp() {
        let message: [String: Bool] = ["getChild": true]
        if let session = session, session.isReachable {
            session.sendMessage(message, replyHandler: { (replyData) in
                DispatchQueue.main.async {
                    if let childId = replyData["childId"] as? String, let childName = replyData["childName"] as? String, let feedingType = replyData["feedingType"] as? String, let medicalInfo = replyData["medicalInfo"] as? String {
                        if childName != "No Child Available" {
                            self.sleepTrackerButton.setHidden(false)
                            if feedingType == "nurse" {
                                self.nurseTrackerButton.setHidden(false)
                            } else if feedingType == "bottle" {
                                self.bottleTrackerButton.setHidden(false)
                            }
                            self.diaperChangeTrackerButton.setHidden(false)
                            
                            UserDefaults.standard.set(childId, forKey: "childId")
                            UserDefaults.standard.set(childName, forKey: "childName")
                            UserDefaults.standard.set(feedingType, forKey: "feedingType")
                            UserDefaults.standard.set(medicalInfo, forKey: "medicalInfo")
                        } else {
                            self.noChildAvailableLabel.setHidden(false)
                            self.reloadChildButton.setHidden(false)
                        }
                        self.childLabel.setText(childName)
                    }
                }
            }, errorHandler: nil)
        }
    }
}
