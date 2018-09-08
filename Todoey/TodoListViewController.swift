//
//  ViewController.swift
//  Todoey
//
//  Created by Ethan Wrightson on 25/08/2018.
//  Copyright © 2018 Ethan Wrightson. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let defaults = UserDefaults.standard // This is how we will store the data in the todo list
    
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("viewDidLoad")
        
        // If we have saved data in the past, get it now.
        if let itemData = defaults.data(forKey: "TodoListArray"), let items = try? JSONDecoder().decode([Item].self, from: itemData) {
            
            itemArray = items
            
            print("Gathered existing items from UserDefaults")
        } else {
            print("There seems to be nothing in the UserDefaults.")
        }
        
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
        
        // Save in the userDefaults the new value of 'isCompleted'
        saveToUserDefaults(itemArray: itemArray)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        
    }
    
    
    
    ///////////////////////////////////////////////////
    //MARK: Functionality
    
    
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
                let newItem = Item()
                newItem.title = textEntered
                
                self.itemArray.append(newItem) // Add the item to the array of items
                
                // Save the new array to the defaults
                self.saveToUserDefaults(itemArray: self.itemArray)
                
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
    //MARK: - UserDefaults handling

    func saveToUserDefaults(itemArray : [Item]) {
        
        if let encoded = try? JSONEncoder().encode(itemArray) {
            
            defaults.set(encoded, forKey: "TodoListArray")
            
        }
        
    }
    
}

