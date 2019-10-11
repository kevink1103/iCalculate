//
//  TableViewController.swift
//  iCalculate
//
//  Created by Kevin Kim on 7/10/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var records: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        records = loadRecords()
    }
    
    // MARK: Core Data
    func loadRecords() -> [String] {
        var records: [String] = []

        guard let del = UIApplication.shared.delegate as? AppDelegate else {
            return records
        }
        let context = del.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        fetchReq.sortDescriptors = [NSSortDescriptor.init(key: "timestamp", ascending: false)]
        
        do {
            let results = try context.fetch(fetchReq)
            for data in results as! [NSManagedObject] {
                let record = data.value(forKey: "equation") as! String
                records.append(record)
            }
        } catch let error as NSError {
            print("\(error)")
            return records
        }
        return records
    }
    
    func deleteRecord(_ target: String) -> Bool {
        guard let del = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        let context = del.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        
        do {
            let results = try context.fetch(fetchReq)
            for data in results as! [NSManagedObject] {
                let record = data.value(forKey: "equation") as! String

                if record == target {
                    context.delete(data)
                    do {
                        try context.save()
                    } catch let error as NSError {
                        print("\(error)")
                        return false
                    }
                    return true
                }
            }
        } catch let error as NSError {
            print("\(error)")
            return false
        }
        return false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return records.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "record", for: indexPath)

        // Configure the cell...
        let index = indexPath.row
        let record = records[index]
        let equalIndex = record.search("=")
        let eq = record[0..<(equalIndex-1)]
        let result = record[(equalIndex+1)...]
        cell.textLabel?.text = String(eq)
        cell.detailTextLabel?.text = String(result)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIPasteboard.general.string = records[indexPath.row]
        let alert = UIAlertController(title: "Copy Successful", message: "Copied to clipboard.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
            if deleteRecord(records[indexPath.row]) {
                records.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
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
