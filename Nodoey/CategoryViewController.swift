//
//  CategoryViewController.swift
//  Nodoey
//
//  Created by Didar Korkembay on 5/28/19.
//  Copyright © 2019 Didar Korkembay. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoryArray = [Category]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: " ", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            var categories = Category(context: self.context)
            categories.name = textField.text!
            
            self.categoryArray.append(categories)
            self.saveCategories()
            
            
        }
        alert.addAction(action)
        alert.addTextField { (textFieldx) in
            textFieldx.placeholder = "Add new Category"
            textField = textFieldx
            
        }
    
        present(alert, animated: true,completion: nil)
    
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
        let category = categoryArray[indexPath.row]
        cell?.textLabel?.text = category.name!
        return cell!
    }
    
    func loadCategories() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)

        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func saveCategories() {
        do{
            try context.save() }
        catch {
            print("Error \(error)")
        }
        tableView.reloadData()
    }
    
    
}
