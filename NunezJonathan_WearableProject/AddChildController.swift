//
//  AddChildController.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/13/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import UIKit
import SQLite3

class AddChildController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var medicalInfoTextView: UITextView!
    
    let dbFileManager = TrackerLogsDBFileManager()
    var newChild: Child?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(AddChildController.saveChild(sender:))), animated: true)
        
        dobPicker.maximumDate = Date()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == firstNameTextField.tag {
            firstNameTextField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
        } else if textField.tag == lastNameTextField.tag {
            lastNameTextField.resignFirstResponder()
            dobPicker.becomeFirstResponder()
        }
        
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if medicalInfoTextView .isFirstResponder {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    
    @objc func saveChild(sender: UIBarButtonItem) {
        if firstNameTextField.text!.isEmpty, lastNameTextField.text!.isEmpty {
            showEmptyFieldsAlert()
            return
        }
        
        defer {openDB()}
        
        newChild = Child(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, dob: dobPicker.date)
        
        if !medicalInfoTextView.text.isEmpty {
            newChild?.medicalInfo = medicalInfoTextView.text
        }
    }
    
    func openDB() {
        
        let db: TrackerLogsDatabase

        defer {performSegue(withIdentifier: "unwindToChildrenList", sender: self)}
        
        do {
            db = try TrackerLogsDatabase.openDatabase(path: TrackerLogsDBFileManager.getTrackerLogsDBFilePath()!)
            
            let childId = newChild?.generateChildId
            
            try db.insertIntoChildrenTable(childId: childId!, firstName: newChild!.firstName, lastName: newChild!.lastName, dob: newChild!.dobString)
            
            UserDefaults.standard.set("nurse", forKey: "feedingType" + childId!)
            UserDefaults.standard.set(newChild?.medicalInfo, forKey: "medicalInfo" + childId!)
        } catch TrackerLogsDBError.OpenDatabase(let message) {
            print(message)
        } catch {
            print("Critical Error")
        }
    }
    
    private func showEmptyFieldsAlert() {
        let alert = UIAlertController(title: "Whoops", message: "Please do not leave any fields empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
