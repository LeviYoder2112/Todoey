//
//  ViewController.swift
//  Todoey
//
//  Created by Levi Yoder on 11/15/18.
//  Copyright © 2018 Levi Yoder. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(dataFilePath)
    
        loadItems()
    }

    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = itemArray[indexPath.row].title
       
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveData()
        tableView.reloadData()
    }
    
    //MARK: - Add new items
    
        @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
            
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
                var newItem = Item()
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                
                
                self.saveData()
                
                self.tableView.reloadData()
           
            
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new item"
           textField = alertTextField
            }
            
            alert.addAction(action)
        present(alert, animated: true, completion: nil)
        }
    

    //MARK: - Saving/Pulling Data
    
    func saveData(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("error encoding item array \(error)")
        }
    }
    
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("error loading items \(error)")
            }
        }
    }
}

