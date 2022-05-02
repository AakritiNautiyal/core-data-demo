//
//  CategoryTableViewController.swift
//  TodoApp
//
//  Created by daffolapmac-136 on 02/05/22.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
        
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = Utility.loadCategories()
        tableView.reloadData()
    }
    
    @IBAction func addCategory(_ sender: Any) {
        var categoryTextField = UITextField()
        let alertController = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        alertController.addTextField { alertTextField in
            alertTextField.placeholder = "Add a new value"
            categoryTextField = alertTextField
        }
        let action = UIAlertAction(title: "Save", style: .default) { action in
            
            let newCategory = Category(context: Utility.context)
            if let categoryName = categoryTextField.text, categoryName != ""{
                newCategory.name = categoryName
            }
            self.categories.append(newCategory)
            Utility.saveData()
            self.tableView.reloadData()
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let item = categories[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let itemToBeDeleted = categories[indexPath.row]
            Utility.context.delete(itemToBeDeleted)
            categories.remove(at: indexPath.row)
            Utility.saveData()
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let todoVC = mainStoryboard.instantiateViewController(identifier: "TodoTableVC") as? TodoTableViewController{
            todoVC.selectedCategory = category
            navigationController?.pushViewController(todoVC, animated: true)
        }
    }
}
