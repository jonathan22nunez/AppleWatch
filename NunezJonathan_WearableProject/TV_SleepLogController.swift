//
//  TV_SleepLogController.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/12/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import UIKit

class TV_SleepLogController: UITableViewController {
    
    @IBOutlet weak var childrenBarButton: UIBarButtonItem!
    
    var sleepLogs = [Sleep]()
    let childId = TrackerLogsDBFileManager.childId
    let dbFilePath = TrackerLogsDBFileManager.getTrackerLogsDBFilePath()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let hasSavedChildId = UserDefaults.standard.string(forKey: childId) {
            self.childrenBarButton.title = UserDefaults.standard.string(forKey: hasSavedChildId)
            retrieveSleepLogs()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sleepLogs.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sleepTVCell", for: indexPath) as! SleepLogTableViewCell

        // Configure the cell...
        let sleepLog = sleepLogs[indexPath.row]
        cell.durationLabel.text = sleepLog.sleepDuration
        cell.dateLabel.text = sleepLog.date
        cell.startStopTime.text = sleepLog.startTime + " - " + sleepLog.stopTime

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func retrieveSleepLogs() {
        if let childId = UserDefaults.standard.string(forKey: childId) {
            
            let db: TrackerLogsDatabase
            
            defer {self.tableView.reloadData()}
            
            do {
                db = try TrackerLogsDatabase.openDatabase(path: dbFilePath!)
                
                sleepLogs = try db.querySleepTable(childId: childId)
            } catch {
                print("Critical Error")
            }
        }
    }
}
