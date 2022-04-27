//
//  TodoTableViewController.swift
//  TodoApp
//
//  Created by daffolapmac-136 on 26/04/22.
//

import UIKit
import CoreData

class TodoTableViewController: UITableViewController {

    var items = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    @IBAction func addNewItem(_ sender: Any) {
        var itemTextField = UITextField()
        let alertController = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        alertController.addTextField { alertTextField in
            alertTextField.placeholder = "Add a new value"
            itemTextField = alertTextField
        }
        let action = UIAlertAction(title: "Save", style: .default) { action in
            
            let newItem = Item(context: self.context)
            if let itemName = itemTextField.text, itemName != ""{
                newItem.name = itemName
            }
            self.items.append(newItem)
            self.saveItems()
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func loadItems(){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
            items = try context.fetch(request)
        } catch{
            print("error while loading items \(error)")
        }
    }
    
    func saveItems(){
        do{
            try context.save()
        }catch{
            print("error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.name
        cell.accessoryType = item.isChecked ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.isChecked = !item.isChecked
        self.saveItems()
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


}
