//
//  ViewController.swift
//  Nodoey
//
//  Created by Didar Korkembay on 5/9/19.
//  Copyright © 2019 Didar Korkembay. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
   
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy eggs"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy the Machine"
        itemArray.append(newItem3)
}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
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
    
    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    } else {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    
    
     tableView.deselectRow(at: indexPath, animated: true)
    tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        var alert = UIAlertController(title: "Add task", message: " ", preferredStyle: .alert)
        
        var action = UIAlertAction(title: "Add", style: .default) { (action) in
            
                let newItem = Item()
                newItem.title = textField.text!
                
                self.itemArray.append(newItem)
                
//                self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                self.tableView.reloadData()
                
            
            
        }
        
        alert.addAction(action)
        alert.addTextField { (textFieldx) in
            textFieldx.placeholder = "Add the item"
            textField = textFieldx
        }
        
        present(alert,animated: true, completion: nil)
    }
    

}

