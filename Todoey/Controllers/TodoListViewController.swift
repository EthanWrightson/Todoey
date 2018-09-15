//
//  ViewController.swift
//  Todoey
//
//  Created by Ethan Wrightson on 25/08/2018.
//  Copyright © 2018 Ethan Wrightson. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print("\nDataFilePath: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TodoListItems.plist"))\n")
        
        print("viewDidLoad")
        
        // If we have saved data in the past, get it now.
        loadItems()
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("didRecieveMemoryWarning")
    }
    
    ///////////////////////////////////////////////////////////////////
    //MARK: - TableView methods
    
    // Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Creating cell.")
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        // Add in the little checkmark if necessary
        cell.accessoryType = itemArray[indexPath.row].isCompleted ? .checkmark : .none
        
        return cell
        
    }
    
    
    //MARK: Delegate methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Did select row")
        
        
        itemArray[indexPath.row].isCompleted = !(itemArray[indexPath.row].isCompleted)
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        
    }
    
    
    
    ///////////////////////////////////////////////////
    //MARK: - Functionality
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        print("Add Button Pressed")
        
        var textField : UITextField = UITextField() // This will be the text field inside the pop-up for new items.
        
        
        // Add a pop-up option that will allow the user to add a new item to the to-do list
        
        let alert = UIAlertController(title: "Add new item:", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) {
            (action) in
            
            // Completion handler for the action. Will run when the user has clicked 'Add item' in the alert
            
            if let textEntered = textField.text {
                
                print("User has clicked \'Add Item\'. Inside completion handler")
                print("The item is called: \(textEntered)")
                
                
                
                // Create the new item
                let newItem = Item(context: self.context)
                newItem.title = textEntered
                newItem.isCompleted = false
                
                self.itemArray.append(newItem) // Add the item to the array of items
                
                self.saveItems()
                
                // Update the table view
                self.tableView.reloadData()
                
            }
            
        }
        
        alert.addAction(action)
        
        
        
        
        // Add the text field where the user can enter the title of the item
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        
        present(alert, animated: true, completion: nil) // Show the alert
        
    }
    
    
    
    
    /////////////////////////////////////////////////////////////////
    //MARK: - Data Persistence
    
    func saveItems() {
        
        print("saveItems function")
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
    }
    
    func loadItems() {

        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }

    }
    
}
