//
//  ViewController.swift
//  Todoey
//
//  Created by Ethan Wrightson on 25/08/2018.
//  Copyright © 2018 Ethan Wrightson. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mawi", "Cross Ocean", "Restore Heart"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    ///////////////////////////////////////////////////////////////////
    //MARK: - TableView methods
    
    // Datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Creating cell.")
        
        //TODO: Remove the test code
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    
    
    
    //MARK: Delegate methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Add in or remove the little tick icon in the cell
        if tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    ///////////////////////////////////////////////////
    //MARK: Functionality
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField : UITextField = UITextField() // This will be the text field inside the pop-up for new items.
        
        
        // Add a pop-up option that will allow the user to add a new item to the to-do list
        
        let alert = UIAlertController(title: "Add new item:", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) {
            (action) in
            
            // Completion handler for the action. Will run when the user has clicked 'Add item' in the alert
            
            if let textEntered = textField.text {
                
                print("User has clicked \'Add Item\'. Inside completion handler")
                print("The item is called: \(textEntered)")
                
                self.itemArray.append(textEntered) // Add the item to the array of items
                
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
    

}

