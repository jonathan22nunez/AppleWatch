//
//  SleepInterfaceController.swift
//  NunezJonathan_WearableProject WatchKit Extension
//
//  Created by Jonathan Nunez on 6/15/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class SleepInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @available(watchOS 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    @IBOutlet weak var sleepTimerLabel: WKInterfaceLabel!
    @IBOutlet weak var startStopButton: WKInterfaceButton!
    @IBOutlet weak var saveButton: WKInterfaceButton!
    
    var timerIsRunning = false
    var startDate: Date?
    var duration = 0
    var timer: Timer?
    
    fileprivate let session: WCSession? = WCSession.isSupported() ? WCSession.default:nil

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
    
    @IBAction func startStopTimer() {
        if timerIsRunning {
            timer?.invalidate()
            timerIsRunning = false
            startStopButton.setTitle("Start")
            saveButton.setHidden(false)
        } else {
            if startDate == nil {
                startDate = Date()
            }
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRun), userInfo: nil, repeats: true)
            timerIsRunning = true
            startStopButton.setTitle("Stop")
            saveButton.setHidden(true)
        }
    }
    
    @objc
    func timerRun() {
        duration += 1
        updateTimerLabel()
    }
    
    func updateTimerLabel() {
        let hours = duration / 60 / 60
        let minutes = duration / 60
        let seconds = duration % 60
        
        sleepTimerLabel.setText(String(format: "%02d:%02d:%02d", hours, minutes, seconds))
    }
    
    @IBAction func saveSleepEvent() {
        if let childId = UserDefaults.standard.string(forKey: "childId") {
            let newSleepEvent = Sleep(childId: childId, startDateTime: startDate!, durationIn: Double(duration))
            sendSleepEvent(newSleepEvent: newSleepEvent)
        }
        
    }
    
    private func sendSleepEvent(newSleepEvent: Sleep) {
        NSKeyedArchiver.setClassName("sleep", for: Sleep.self)
        guard let sleepEventData = try? NSKeyedArchiver.archivedData(withRootObject: newSleepEvent, requiringSecureCoding: false) else {return}
        let message: [String: Data] = ["sleepEvent": sleepEventData]
        if let session = session, session.isReachable {
            session.sendMessage(message, replyHandler: nil, errorHandler: nil)
            saveButton.setBackgroundColor(UIColor.init(red: 88/255, green: 185/255, blue: 157/255, alpha: 0.5))
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
                self.saveButton.setBackgroundColor(UIColor(white: 0.75, alpha: CGFloat(0.17)))
                self.resetInterface()
            }
        }
    }
    
    private func resetInterface() {
        sleepTimerLabel.setText("00:00:00")
        duration = 0
        startDate = nil
        saveButton.setHidden(true)
    }

}
