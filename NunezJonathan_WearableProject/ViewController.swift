//
//  ViewController.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/12/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import UIKit

// TODO: implement the deletion of a child and all of it's subsequent data
class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var childrenTable: UITableView!
    
    let childId = TrackerLogsDBFileManager.childId
    var childrenList = [Child]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(ViewController.addChild(sender:))), animated: true)
        
        childrenTable.dataSource = self
        childrenTable.delegate = self
        
        retrieveChildrenList()
    }
    
    // MARK: - TableView setup
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childrenList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "childrenTVCell", for: indexPath)
        
        cell.textLabel?.text = childrenList[indexPath.row].firstName + " " + childrenList[indexPath.row].lastName
        if childrenList[indexPath.row].childId == UserDefaults.standard.string(forKey: childId) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveDefaults(child: childrenList[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
    // MARK: -
    
    @objc
    func addChild(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toAddChildController", sender: self)
    }
    
    @IBAction func unwindFromAddChild(_ segue: UIStoryboardSegue) {
        retrieveChildrenList()
        if let source = segue.source as? AddChildController {
            saveDefaults(child: source.newChild!)
        }
    }
    
    private func retrieveChildrenList() {
        
        let db: TrackerLogsDatabase
        
        defer {childrenTable.reloadData()}
        
        do {
            db = try TrackerLogsDatabase.openDatabase(path: TrackerLogsDBFileManager.getTrackerLogsDBFilePath()!)

            childrenList = try db.queryChildrenTable()
        } catch TrackerLogsDBError.OpenDatabase(let message) {
            print(message)
        } catch {
            print("Critical Error")
        }
    }
    
    private func saveDefaults(child: Child) {
        UserDefaults.standard.set(child.childId, forKey: childId)
        UserDefaults.standard.set(child.firstName, forKey: child.childId!)
    }
}

