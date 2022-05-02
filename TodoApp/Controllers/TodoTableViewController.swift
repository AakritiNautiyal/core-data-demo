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
    var selectedCategory : Category? {
        didSet{
            items = Utility.loadItems(selectedCategoryName: selectedCategory!.name!)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Create
    @IBAction func addNewItem(_ sender: Any) {
        var itemTextField = UITextField()
        let alertController = UIAlertController(title: "Add new item", message: nil, preferredStyle: .alert)
        alertController.addTextField { alertTextField in
            alertTextField.placeholder = "Add a new value"
            itemTextField = alertTextField
        }
        let action = UIAlertAction(title: "Save", style: .default) { action in
            
            let newItem = Item(context: Utility.context)
            if let itemName = itemTextField.text, itemName != ""{
                newItem.name = itemName
                newItem.parentCategory = self.selectedCategory
            }
            self.items.append(newItem)
            Utility.saveData()
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(action)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
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
    
    //Update
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        item.isChecked = !item.isChecked
        Utility.saveData()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //Delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let itemToBeDeleted = items[indexPath.row]
            Utility.context.delete(itemToBeDeleted)
            items.remove(at: indexPath.row)
            Utility.saveData()
            tableView.reloadData()
        }
    }
}

extension TodoTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@",searchText)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        items = Utility.loadItems(with: request, selectedCategoryName: selectedCategory!.name!, predicate: predicate)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            items = Utility.loadItems(selectedCategoryName: selectedCategory!.name!)
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
