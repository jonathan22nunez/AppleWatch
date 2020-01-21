//
//  TV_DiaperChangeLogController.swift
//  NunezJonathan_WearableProject
//
//  Created by Jonathan Nunez on 6/12/19.
//  Copyright © 2019 Jonathan Nunez. All rights reserved.
//

import UIKit

class TV_DiaperChangeLogController: UITableViewController {
    
    @IBOutlet weak var childrenBarButton: UIBarButtonItem!
    var diaperLogs = [Any]()
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
            retrieveWetDiaperLogs()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return diaperLogs.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaperTVCell", for: indexPath) as! DiaperTableViewCell

        // Configure the cell...
        if let isWetDiaper = diaperLogs[indexPath.row] as? WetDiaper {
            cell.dateLabel.text = isWetDiaper.date
            cell.diaperTypeLabel.text = "Wet"
            cell.diaperColorLabel.isHidden = true
            cell.diaperTextureLabel.isHidden = true
        } else if let isMixedDiaper = diaperLogs[indexPath.row] as? MixedDiaper {
            cell.dateLabel.text = isMixedDiaper.date
            cell.diaperTypeLabel.text = isMixedDiaper.diaperType
            cell.diaperColorLabel.text = "Color: " + isMixedDiaper.color
            cell.diaperTextureLabel.text = " Texture: " + isMixedDiaper.texture
        }

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
    
    func retrieveWetDiaperLogs() {
        if let childId = UserDefaults.standard.string(forKey: childId) {
            
            let db: TrackerLogsDatabase
            
            defer {self.tableView.reloadData()}
            
            do {
                db = try TrackerLogsDatabase.openDatabase(path: dbFilePath!)
                
                diaperLogs = try db.queryWetTable(childId: childId)
                let mixedDiapers = try db.queryMixedTable(childId: childId)
                for mixedDiaper in mixedDiapers {
                    diaperLogs.append(mixedDiaper)
                }
            } catch {
                print("Critical Error")
            }
        }
    }

}
