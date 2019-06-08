//
//  ViewController.swift
//  Nodoey
//
//  Created by Didar Korkembay on 5/9/19.
//  Copyright © 2019 Didar Korkembay. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    var itemArray = [Item]()
    var selectedCategory: Category? { //optional because it will have value once category selected
        didSet {
            loadItems()
        } ///Didset activates once selectedCategory will have value from Categoryviewcontroller
    }
   

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //creating context
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//
//    }        print(dataFilePath)
        
        
}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //MARK: - What every cell should illustrate.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      var cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else
//        { cell.accessoryType = .none
//        }
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
//
     itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    self.saveItems()
    
//    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .none
//    } else {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//    }
    
    
    
     tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        var alert = UIAlertController(title: "Add task", message: " ", preferredStyle: .alert)
        
        var action = UIAlertAction(title: "Add", style: .default) { (action) in
            
                let newItem = Item(context: self.context) //specifies where this item is going to exist.
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
            
            
                self.itemArray.append(newItem)
            
               self.saveItems()
        }
        
        alert.addAction(action)
        alert.addTextField { (textFieldx) in
            textFieldx.placeholder = "Add the item"
            textField = textFieldx
        }
        
        present(alert,animated: true, completion: nil)
    }
    
    func saveItems() {
        do {
         try context.save()
            
        } catch {

        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) { //default value is Item.fetchRequest
//        let request: NSFetchRequest <Item> = Item.fetchRequest() // <Item> specifying what type of data we want to get.
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        } else {
            request.predicate = categoryPredicate //if the other predicate is nill, only categoryPredicate will work
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
//
//        request.predicate = compoundPredicate
        do {
           itemArray = try context.fetch(request) } catch {
                print("Error")
        }
        
        
        } /// Place where it gets data from
    
    }
//MARK: -SearchBar Methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // searching the value in title property of Item.
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor] // Sorts out the given data in a form of Array.
        
        loadItems(with: request,predicate: predicate)
        

    }
    

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // Should do again. Disappear all words and keyboard.
            }
            
        }
    }
    
    
}



