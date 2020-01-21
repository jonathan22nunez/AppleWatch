//
//  TV_FeedingLogController.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/12/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import UIKit

class TV_FeedingLogController: UITableViewController {
    
    @IBOutlet weak var nurseBottleToggle: UIBarButtonItem!
    @IBOutlet weak var childrenBarButton: UIBarButtonItem!
    
    var feedingLogs = [Any]()
    var feedingType = "nurse"
    let CHILD_ID = TrackerLogsDBFileManager.childId
    let dbFilePath = TrackerLogsDBFileManager.getTrackerLogsDBFilePath()
    var childId = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let hasSavedChildId = UserDefaults.standard.string(forKey: CHILD_ID) {
            self.childrenBarButton.title = UserDefaults.standard.string(forKey: hasSavedChildId)
            childId = hasSavedChildId

            if let feedType = UserDefaults.standard.string(forKey: "feedingType" + hasSavedChildId) {
                if feedType == "nurse" {
                    nurseBottleToggle.title = "Bottle"
                    navigationItem.title = "Nurse Log"
                    retrieveNurseLogs()
                } else if feedType == "bottle" {
                    feedingType = "bottle"
                    nurseBottleToggle.title = "Nurse"
                    navigationItem.title = "Bottle Log"
                    retrieveBottleLogs()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedingLogs.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedingTVCell", for: indexPath) as! FeedingTableViewCell

        // Configure the cell...
        if let feedingLog = feedingLogs[indexPath.row] as? NurseFeed {
            cell.durationLabel.text = feedingLog.startTime
            cell.dateLabel.text = feedingLog.date
            cell.leftDurationLabel.text = "Left: " + String(feedingLog.leftTime)
            cell.rightDurationLabel.text = "Right: " + String(feedingLog.rightTime)
        } else if let feedingLog = feedingLogs[indexPath.row] as? BottleFeed {
            cell.durationLabel.text = feedingLog.startTime
            cell.dateLabel.text = feedingLog.date
            cell.leftDurationLabel.text = "Starting: " + feedingLog.startAmount
            cell.rightDurationLabel.text = "Ending: " + feedingLog.endAmount
        }
        
        return cell
    }

    @IBAction func nurseBottleToggleClick(_ sender: UIBarButtonItem) {
        if feedingType == "nurse" {
            feedingType = "bottle"
            nurseBottleToggle.title = "Nurse"
            navigationItem.title = "Bottle Log"
            retrieveBottleLogs()
        } else if feedingType == "bottle" {
            feedingType = "nurse"
            nurseBottleToggle.title = "Bottle"
            navigationItem.title = "Nurse Log"
            retrieveNurseLogs()
        }
        
        UserDefaults.standard.set(feedingType, forKey: "feedingType" + childId)
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
    
    func retrieveNurseLogs() {
        let db: TrackerLogsDatabase
        
        defer {self.tableView.reloadData()}
        
        do {
            db = try TrackerLogsDatabase.openDatabase(path: dbFilePath!)
            
            feedingLogs = try db.queryNurseTable(childId: childId)
        } catch {
            print("Critical Error")
        }
    }
    
    func retrieveBottleLogs() {
        let db: TrackerLogsDatabase
        
        defer {self.tableView.reloadData()}
        
        do {
            db = try TrackerLogsDatabase.openDatabase(path: dbFilePath!)
            
            feedingLogs = try db.queryBottleTable(childId: childId)
        } catch {
            print("Critical Error")
        }
    }

}
