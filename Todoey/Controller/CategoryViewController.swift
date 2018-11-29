//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Levi Yoder on 11/27/18.
//  Copyright © 2018 Levi Yoder. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeCellTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Categories.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        loadCategories()
        tableView.rowHeight = 80.0
    }
    
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].title ?? "No Categories Added Yet"
    
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
        destinationVC.selectedCategory = categories?[indexPath.row]
        }}
    
    //MARK: - Add new items
    
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            var newCategory = Category()
            newCategory.title = textField.text!
            self.save(category: newCategory)
          
            self.tableView.reloadData()
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Saving/Loading Data
    
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    
    func loadCategories(){
categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
   
    //MARK: - Deleting Data
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch{
                print("error deleting category \(error)")
            }
            tableView.reloadData()
        }
    }
    
}


