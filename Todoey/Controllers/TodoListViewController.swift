//
//  ViewController.swift
//  Todoey
//
//  Created by Ethan Wrightson on 25/08/2018.
//  Copyright © 2018 Ethan Wrightson. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("viewDidLoad")
        
        searchBar.delegate = self
        
        // If we have saved data in the past, it will be loaded as soon as we have a value for selectedCategory so there is no need to load it here
       
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
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Creating cell.")
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // Add in the little checkmark if necessary
            cell.accessoryType = item.isCompleted ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No items added yet..."
        }
        
        return cell
        
    }
    
    
    //MARK: Delegate methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Did select row")
        
        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    item.isCompleted = !(item.isCompleted)
                }
            } catch {
                print("Error saving new isCompleted value: \(error)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
        
    }
    

    ///////////////////////////////////////////////////
    //MARK: - Add Item Functionality
    
    
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
                
                
                
                if let currentCategory = self.selectedCategory {
                    
                    do {
                        
                        try self.realm.write {
                            // Create the new item
                            let newItem = Item()
                            newItem.title = textEntered
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                            
                            print("Saving new item")
                            
                        }
                
                    } catch {
                        print("Error saving new item: \(error)")
                    }
                    
                }
                
                self.loadItems()
                
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
    
    
    func loadItems() { // The default value for the request just gets everything
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: false)

        tableView.reloadData()

    }
    
}

//////////////////////////////////////////////////////////////////////////////////////
//MARK: - Search Bar Functionality

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        print("SearchButtonClicked method")
        
        if let textEntered = searchBar.text {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", textEntered).sorted(byKeyPath: "dateCreated", ascending: true)
        }
        
        tableView.reloadData()

    }


    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        // If the user clicks the 'x' and the search bar becomes empty, go back to showing everything
        if searchBar.text?.count == 0 {

            loadItems()


            // Deselect the searchBar
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }

    }

}
