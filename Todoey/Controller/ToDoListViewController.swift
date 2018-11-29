//
//  ViewController.swift
//  Todoey
//
//  Created by Levi Yoder on 11/15/18.
//  Copyright © 2018 Levi Yoder. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeCellTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
   var masterColor = ""
    var selectedCategory: Category? {
        didSet {
            loadItems()
            masterColor = (selectedCategory?.color)!
        }
    }
    
    var items: Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    tableView.rowHeight = 80.0
    tableView.separatorStyle = .none
      
    }

    
    override func viewWillAppear(_ animated: Bool) {
      
        title = selectedCategory?.title
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller doesn't exist.")
            
        }
         navBar.barTintColor = UIColor(hexString: masterColor)
         navBar.tintColor = UIColor.init(contrastingBlackOrWhiteColorOn: UIColor(hexString: masterColor), isFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.init(contrastingBlackOrWhiteColorOn:  UIColor(hexString: masterColor), isFlat: true)]
        
        searchBar.barTintColor =  UIColor(hexString: masterColor)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if let originalColor = UIColor(hexString: "1478F6"){
            navigationController?.navigationBar.barTintColor = originalColor
            navigationController?.navigationBar.tintColor = UIColor.flatWhite()
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(contrastingBlackOrWhiteColorOn: originalColor, isFlat: true)]
        }
        
    }
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
        
if let color = UIColor(hexString: masterColor).darken(byPercentage: CGFloat(indexPath.row) / CGFloat((items!.count))) {
            cell.textLabel?.text = item.title
            cell.backgroundColor = color
    cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: color, isFlat: true)
            }
      
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
