//
//  BottleStartInterfaceController.swift
//  NunezJonathan_WearableProject WatchKit Extension
//
//  Created by Jonathan Nunez on 6/26/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import WatchKit
import Foundation


class BottleStartInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var startAmountPicker: WKInterfacePicker!
    
    var startingAmount: Int?
    
    let pickerItemsList: [(String, String)] = [
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
        
        let pickerItems: [WKPickerItem] = pickerItemsList.map {
            let pickerItem = WKPickerItem()
            pickerItem.caption = $0.0
            pickerItem.title = $0.1
            return pickerItem
        }
        startAmountPicker.setItems(pickerItems)
        
        startingAmount = 1
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func startAmountSelection(_ value: Int) {
        startingAmount = value + 1
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        if segueIdentifier == "toEndingAmount" {
            return startingAmount
        }
        
        return nil
    }
}
