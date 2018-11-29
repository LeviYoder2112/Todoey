//
//  ViewController.swift
//  Todoey
//
//  Created by Levi Yoder on 11/15/18.
//  Copyright © 2018 Levi Yoder. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeCellTableViewController {
  let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    var items: Results<Item>?
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(dataFilePath)
    tableView.rowHeight = 80.0
    }

    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
        cell.textLabel?.text = item.title
       
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status. \(error)")
            }
        }
        tableView.reloadData()
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem){
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                
                do{
                    try self.realm.write {
                        var newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                        newItem.dateCreated = Date()
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            //            self.saveData(item: newItem)
            
            self.tableView.reloadData()
        }
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new item"
                textField = alertTextField
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
       
 
    }
    
    

    //MARK: - Saving/Pulling Data
    
//    func saveData(item: Item){
//        do {
//            try realm.write {
//                realm.add(item)
//            }
//        } catch {
//            print("Error saving context \(error)")
//        }
//        self.tableView.reloadData()
//
//    }
    
    
    func loadItems(){
       items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
}

    
    //MARK: - Deleting Data
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.items?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch{
                print("error deleting category \(error)")
            }
            tableView.reloadData()
        }
    }
    
    
}


//MARK: - Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
      items = items?.filter("title CONTAINS[CD] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)

        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
    
}
