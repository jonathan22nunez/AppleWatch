//
//  DiaperChangeInterfaceController.swift
//  NunezJonathan_WearableProject WatchKit Extension
//
//  Created by Jonathan Nunez on 6/25/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class DiaperChangeInterfaceController: WKInterfaceController, WCSessionDelegate{
    
    @available(watchOS 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default:nil
    
    @IBOutlet weak var wetDiaperButton: WKInterfaceButton!
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func wetDiaperClick() {
        if let childId = UserDefaults.standard.string(forKey: "childId") {
            let newWetDiaperEvent = WetDiaper(childId: childId, dateTime: Date())
            sendWetDiaperEvent(newWetDiaperEvent: newWetDiaperEvent)
        }
    }
    
    private func sendWetDiaperEvent(newWetDiaperEvent: WetDiaper) {
        NSKeyedArchiver.setClassName("wetDiaper", for: WetDiaper.self)
        guard let wetDiaperEventData = try? NSKeyedArchiver.archivedData(withRootObject: newWetDiaperEvent, requiringSecureCoding: false) else {return}
        let message: [String: Data] = ["wetDiaperEvent": wetDiaperEventData]
        if let session = session, session.isReachable {
            session.sendMessage(message, replyHandler: nil, errorHandler: nil)
            wetDiaperButton.setBackgroundColor(UIColor.init(red: 88/255, green: 185/255, blue: 157/255, alpha: 0.5))
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
                self.wetDiaperButton.setBackgroundColor(UIColor(white: 0.75, alpha: CGFloat(0.17)))
            }
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        if segueIdentifier == "poopy" {
            return ["mixed": false]
        } else {
            return ["mixed": true]
        }
    }
}
