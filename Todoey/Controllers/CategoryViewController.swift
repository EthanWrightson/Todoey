//
//  TableViewController.swift
//  Todoey
//
//  Created by Ethan Wrightson on 15/09/2018.
//  Copyright © 2018 Ethan Wrightson. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    var categoryArray : Results<Category>?

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("viewDidLoad")
        
        loadCategories()
        
    }


    /////////////////////////////////////////////////////////
    //MARK: - TableView Methods
    //MARK: Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Creating Cateogry Cell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].title ?? "No categories added yet..."
        
        return cell
        
    }
    
    //MARK: Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    
    /////////////////////////////////////////////////////////
    //MARK: - Add Category Functionality
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        print("Add Button Pressed")
        
        var textField = UITextField() // This will be the text field inside the pop-up for new items.
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) {
            (action) in
            
            print("Add button in action pressed. Inside completion handler.")
            
            if let textEntered = textField.text {
             
                print("This category is called: \(textEntered)")
                
                // Create the new category
                let newCategory = Category()
                newCategory.title = textEntered
                
                self.save(category: newCategory)
                
                self.tableView.reloadData()
                
            }
            
        }
        
        alert.addAction(action)
        
        // Add the text field where the user can enter the title of the item
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
            
        }
        
        
        present(alert, animated: true, completion: nil) // Show the alert
        
    }
    
    /////////////////////////////////////////////////////////
    //MARK: - Data Manipulation
    
    func save(category: Category) {
        
        print("saveCategories function")
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving data: \(error)")
        }
        
    }
    
    func loadCategories() {
        
        print("loadCategories function")
        
        categoryArray = realm.objects(Category.self)

        tableView.reloadData()
      
    }
    
}
