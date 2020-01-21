//
//  DiaperTextureInterfaceController.swift
//  NunezJonathan_WearableProject WatchKit Extension
//
//  Created by Jonathan Nunez on 6/26/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class DiaperTextureInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @available(watchOS 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default:nil
    
    @IBOutlet weak var texturePicker: WKInterfacePicker!
    @IBOutlet weak var saveButton: WKInterfaceButton!
    
    var mixed: Bool?
    var color: String?
    var texture: String?
    
    let pickerItemsList: [(String, String)] = [
        ("Item1", "Runny"),
        ("Item2", "Seedy"),
        ("Item3", "Soft"),
        ("Item4", "Firm"),
        ("Item5", "Hard")
    ]

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        if let dic = context as? [String: Any] {
            if let isMixed = dic["mixed"] as? Bool {
                mixed = isMixed
            }
            if let isColor = dic["color"] as? String {
                color = isColor
            }
        }
        
        let pickerItems: [WKPickerItem] = pickerItemsList.map {
            let pickerItem = WKPickerItem()
            pickerItem.caption = $0.0
            pickerItem.title = $0.1
            return pickerItem
        }
        texturePicker.setItems(pickerItems)
        
        texture = pickerItemsList[0].1
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func texturePickerSelection(_ value: Int) {
        texture = pickerItemsList[value].1
    }
    
    @IBAction func saveMixedDiaperEvent() {
        if mixed != nil, color != nil, texture != nil, let childId = UserDefaults.standard.string(forKey: "childId") {
            let newMixedDiaperEvent = MixedDiaper(childId: childId, isDiaper: mixed!, color: color!, texture: texture!, datetime: Date())
            sendMixedDiaperEvent(newMixedDiaperEvent: newMixedDiaperEvent)
        }
    }
    
    private func sendMixedDiaperEvent(newMixedDiaperEvent: MixedDiaper) {
        NSKeyedArchiver.setClassName("mixedDiaper", for: MixedDiaper.self)
        guard let mixedDiaperEventData = try? NSKeyedArchiver.archivedData(withRootObject: newMixedDiaperEvent, requiringSecureCoding: false) else {return}
        let message: [String: Data] = ["mixedDiaperEvent": mixedDiaperEventData]
        if let session = session, session.isReachable {
            session.sendMessage(message, replyHandler: nil, errorHandler: nil)
            saveButton.setBackgroundColor(UIColor.init(red: 88/255, green: 185/255, blue: 157/255, alpha: 0.5))
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
                self.popToRootController()
            }
        }
    }
}
