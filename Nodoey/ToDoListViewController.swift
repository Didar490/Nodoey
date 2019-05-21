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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    

    override func viewDidLoad() {
        super.viewDidLoad()
//
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//
//    }        print(dataFilePath)
        
        loadItems()
        
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
            
                let newItem = Item()
                newItem.title = textField.text!
                
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray) // encoding the itemArray
            try data.write(to: self.dataFilePath!) // shows where the itemArray should be stored
        } catch {
            print ("Error encoding itemArray")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
        let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data) //Specifies the type of data and where it gets it(data)
            } catch {
                print("Error happened in decoding \(error)")
            }

        } /// Place where it gets data from
    }

}

