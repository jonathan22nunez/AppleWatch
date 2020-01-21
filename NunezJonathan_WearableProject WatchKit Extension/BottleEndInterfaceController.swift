//
//  BottleEndInterfaceController.swift
//  NunezJonathan_WearableProject WatchKit Extension
//
//  Created by Jonathan Nunez on 6/26/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class BottleEndInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @available(watchOS 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default:nil

    @IBOutlet weak var endAmountPicker: WKInterfacePicker!
    @IBOutlet weak var saveButton: WKInterfaceButton!
    
    var startingAmount: Int?
    var endingAmount: Int?
    
    let pickerItemsList: [(String, String)] = [
        ("Item 0", "0 oz"),
        ("Item 1", "1 oz"),
        ("Item 2", "2 oz"),
        ("Item 3", "3 oz"),
        ("Item 4", "4 oz"),
        ("Item 5", "5 oz"),
        ("Item 6", "6 oz"),
        ("Item 7", "7 oz"),
        ("Item 8", "8 oz"),
        ("Item 9", "9 oz"),
        ("Item 10", "10 oz"),
        ("Item 11", "11 oz"),
        ("Item 12", "12 oz")
    ]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        if context as? Int != nil {
            startingAmount = context as? Int
        }
        
        let pickerItems: [WKPickerItem] = pickerItemsList.map {
            let pickerItem = WKPickerItem()
            pickerItem.caption = $0.0
            pickerItem.title = $0.1
            return pickerItem
        }
        endAmountPicker.setItems(pickerItems)
        
        endingAmount = 0
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func endingAmountSelection(_ value: Int) {
        endingAmount = value
    }
    
    @IBAction func saveBottleEvent() {
        if let childId = UserDefaults.standard.string(forKey: "childId") {
            let newBottleEvent = BottleFeed(childId: childId,startingAmount: Double(startingAmount!), endingAmount: Double(endingAmount!), date: Date())
            sendBottleEvent(newBottleEvent: newBottleEvent)
        }
    }
    
    private func sendBottleEvent(newBottleEvent: BottleFeed) {
        NSKeyedArchiver.setClassName("bottle", for: BottleFeed.self)
        guard let bottleEventData = try? NSKeyedArchiver.archivedData(withRootObject: newBottleEvent, requiringSecureCoding: false) else {return}
        let message: [String: Data] = ["bottleEvent": bottleEventData]
        if let session = session, session.isReachable {
            session.sendMessage(message, replyHandler: nil, errorHandler: nil)
            saveButton.setBackgroundColor(UIColor.init(red: 88/255, green: 185/255, blue: 157/255, alpha: 0.5))
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
                self.popToRootController()
            }
        }
    }
}
