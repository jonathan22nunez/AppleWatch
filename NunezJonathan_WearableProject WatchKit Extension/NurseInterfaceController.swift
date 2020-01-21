//
//  NurseInterfaceController.swift
//  NunezJonathan_WearableProject WatchKit Extension
//
//  Created by Jonathan Nunez on 6/24/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class NurseInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @available(watchOS 2.2, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    @IBOutlet weak var leftSideButton: WKInterfaceButton!
    @IBOutlet weak var rightSideButton: WKInterfaceButton!
    @IBOutlet weak var saveButton: WKInterfaceButton!
    @IBOutlet weak var timerLabel: WKInterfaceLabel!
    
    var leftIsRunning = false
    var rightIsRunning = false
    var startDate: Date?
    var leftSideDuration = 0
    var rightSideDuration = 0
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
    
    @IBAction func leftSideButtonClick() {
        rightSideButton.setBackgroundColor(UIColor(white: 0.75, alpha: CGFloat(0.17)))
        if leftIsRunning {
            leftIsRunning = false
            stopTimer()
        } else {
            leftIsRunning = true
            if rightIsRunning {
                rightIsRunning = false
            } else {
                starttimer()
            }
            leftSideButton.setBackgroundColor(UIColor(red: 216/255, green: 130/255, blue: 59/255, alpha: 1))
        }
    }
    
    @IBAction func rightSideButtonClick() {
        leftSideButton.setBackgroundColor(UIColor(white: 0.75, alpha: CGFloat(0.17)))
        if rightIsRunning {
            rightIsRunning = false
            stopTimer()
        } else {
            rightIsRunning = true
            if leftIsRunning {
                leftIsRunning = false
            } else {
                starttimer()
            }
            rightSideButton.setBackgroundColor(UIColor(red: 216/255, green: 130/255, blue: 59/233, alpha: 1))
    }
    }
    
    func stopTimer() {
        timer?.invalidate()
        saveButton.setHidden(false)
    }
    
    func starttimer() {
        if startDate == nil {
            startDate = Date()
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRun), userInfo: nil, repeats: true)
        saveButton.setHidden(true)
    }
    
    @objc
    func timerRun() {
        if leftIsRunning {
            leftSideDuration += 1
        } else if rightIsRunning {
            rightSideDuration += 1
        }
        updateTimerLabel()
    }
    
    func updateTimerLabel() {
        let duration = leftSideDuration + rightSideDuration
        let minutes = duration / 60
        let seconds = duration % 60
        
        timerLabel.setText(String(format: "%02d:%02d", minutes, seconds))
    }
    
    @IBAction func saveNurseEvent() {
        if let childId = UserDefaults.standard.string(forKey: "childId") {
            let newNurseEvent = NurseFeed(childId: childId, startDateTime: startDate!, durationInSeconds: Double(leftSideDuration), durationInSeconds: Double(rightSideDuration))
            sendNurseEvent(newNurseEvent: newNurseEvent)
        }
        
    }
    
    private func sendNurseEvent(newNurseEvent: NurseFeed) {
        NSKeyedArchiver.setClassName("nurse", for: NurseFeed.self)
        guard let nurseEventData = try? NSKeyedArchiver.archivedData(withRootObject: newNurseEvent, requiringSecureCoding: false) else {return}
        let message: [String: Data] = ["nurseEvent": nurseEventData]
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
        timerLabel.setText("00:00")
        leftIsRunning = false
        rightIsRunning = false
        leftSideDuration = 0
        rightSideDuration = 0
        startDate = nil
        saveButton.setHidden(true)
    }
}
