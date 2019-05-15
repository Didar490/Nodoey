//
//  ViewController.swift
//  Nodoey
//
//  Created by Didar Korkembay on 5/9/19.
//  Copyright © 2019 Didar Korkembay. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
   
    var itemArray = ["Find Mike", " Buy Eggos", "Destory Demogorgon"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = items
        }
}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      var cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item
        return cell
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedRow = itemArray[indexPath.row]
    
    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    } else {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    
    
     tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        var alert = UIAlertController(title: "Add task", message: " ", preferredStyle: .alert)
        
        var action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let item = textField.text {
                self.itemArray.append(item)
                
                self.defaults.set(self.itemArray, forKey: "ToDoListArray")
                
                self.tableView.reloadData()
                
            }
            
        }
        
        alert.addAction(action)
        alert.addTextField { (textFieldx) in
            textFieldx.placeholder = "Add the item"
            textField = textFieldx
        }
        
        present(alert,animated: true, completion: nil)
    }
    

}

