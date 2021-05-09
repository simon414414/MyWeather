//
//  SearchRecordTableViewController.swift
//  Weather
//
//  Created by Simon on 8/5/2021.
//

import UIKit

class SearchRecordTableViewController: UITableViewController {

    var records = [SearchRecord]()
    let cellReuseIdentifier = "SearchRecordCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        records = SearchRecordManager.sharedInstance.getRecords()
        self.tableView.reloadData()
        self.title = "Search History"
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) else {
                return UITableViewCell(style: .default, reuseIdentifier: cellReuseIdentifier)
                }
                return cell
            }()
        
        
        let record = records[indexPath.row]
        // Configure the cell...
        if record.type == .GPS {
            cell.textLabel?.text  = "Search by \(record.type!)"
        } else {
            cell.textLabel?.text  = "Search by \(record.type!): \(record.input!)"
        }
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            //Code I want to do here
            self.records =  SearchRecordManager.sharedInstance.removeRecord(index: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let criteria = records[indexPath.row]
        NotificationCenter.default.post(name: NSNotification.Name( "GetCurrentWeather"), object: nil, userInfo: ["criteria":criteria])
                                        
        self.navigationController?.popViewController(animated: true)
                                            
    }

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

}
