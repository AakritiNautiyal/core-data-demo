//
//  Utilities.swift
//  TodoApp
//
//  Created by daffolapmac-136 on 02/05/22.
//

import Foundation
import UIKit
import CoreData

class Utility {
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    class func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), selectedCategoryName : String , predicate : NSPredicate? = nil) -> [Item] {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@",selectedCategoryName)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do{
            return try context.fetch(request)
        } catch{
            print("error while loading items \(error)")
        }
        return [Item]()
    }
    
    class func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) -> [Category]{

        do{
            return try context.fetch(request)
        } catch{
            print("error while loading categories \(error)")
        }
        return [Category]()
    }
    
    class func saveData(){
        do {
            try context.save()
        } catch {
            print("error while saving category \(error)")
        }
    }
}
