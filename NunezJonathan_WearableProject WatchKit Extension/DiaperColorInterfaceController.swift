//
//  DiaperColorInterfaceController.swift
//  NunezJonathan_WearableProject WatchKit Extension
//
//  Created by Jonathan Nunez on 6/25/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import WatchKit
import Foundation


class DiaperColorInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var colorPicker: WKInterfacePicker!
    
    var mixed: Bool?
    var color: String?
    
    let pickerItemsList: [(String, String)] = [
        ("Item 1", "Black"),
        ("Item 2", "Yellow"),
        ("Item 3", "Orange"),
        ("Item 4", "Green"),
        ("Item 5", "Brown")
    ]

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        if let isMixed = context as? [String: Bool] {
            if isMixed["mixed"] != nil {
                mixed = isMixed["mixed"]
            }
        }
        
        let pickerItems: [WKPickerItem] = pickerItemsList.map {
            let pickerItem = WKPickerItem()
            pickerItem.caption = $0.0
            pickerItem.title = $0.1
            return pickerItem
        }
        colorPicker.setItems(pickerItems)
        
        color = pickerItemsList[0].1
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func colorPickerSelection(_ value: Int) {
        color = pickerItemsList[value].1
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        if segueIdentifier == "toTexture" {
            let dic: [String: Any] = ["mixed": mixed!, "color": color!]
            return dic
        }
        
        return nil
    }

}
