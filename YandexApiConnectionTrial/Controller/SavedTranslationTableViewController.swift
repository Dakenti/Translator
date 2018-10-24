//
//  SavedTranslationTableViewController.swift
//  YandexApiConnectionTrial
//
//  Created by Dake Aga on 10/16/18.
//  Copyright © 2018 Dake Aga. All rights reserved.
//

import UIKit
import CoreData

protocol SyncronizeSavedTranslations {
    func keepTupledArrayUpdated(tupledArray: [TupledArray])
}

class SavedTranslationTableViewController: UITableViewController {
    
    var tupledArrayFromVC = [TupledArray]()
    
    var delegate: SyncronizeSavedTranslations?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.keepTupledArrayUpdated(tupledArray: tupledArrayFromVC)
        PersistenceService.saveContext()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tupledArrayFromVC.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SavedTranslationsTVC
        
        cell.abbrvFromLabel?.text = tupledArrayFromVC[indexPath.row].enteredTextLanguage
        cell.textFromLabel?.text = tupledArrayFromVC[indexPath.row].enteredText
        cell.abbrvToLabel?.text = tupledArrayFromVC[indexPath.row].outputTextLanguage
        cell.transTextLabel?.text = tupledArrayFromVC[indexPath.row].outputText
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tupledArrayFromVC.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedObject = tupledArrayFromVC[fromIndexPath.row]
        tupledArrayFromVC.remove(at: fromIndexPath.row)
        tupledArrayFromVC.insert(movedObject, at: to.row)
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
}
