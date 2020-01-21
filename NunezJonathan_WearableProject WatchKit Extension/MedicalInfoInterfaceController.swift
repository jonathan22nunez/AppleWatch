//
//  MedicalInfoInterfaceController.swift
//  NunezJonathan_WearableProject WatchKit Extension
//
//  Created by Jonathan Nunez on 6/27/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import WatchKit
import Foundation


class MedicalInfoInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var medicalInfoLabel: WKInterfaceLabel!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        medicalInfoLabel.setText(UserDefaults.standard.string(forKey: "medicalInfo"))
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
