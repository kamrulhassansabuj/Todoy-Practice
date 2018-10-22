//
//  CategoryViewController.swift
//  Todoy Practice
//
//  Created by Kamrul Hassan Sabuj on 30/9/18.
//  Copyright © 2018 SahiTech. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
class CategoryViewController: UITableViewController {
    

    let realm = try! Realm()
    
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        loadCategory()
       
    }

    //MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Category Added"
        cell.delegate = self
        return cell
        
    }
   
    

    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    //MARK: - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoyItemViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
           destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField  = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (UIAlertAction) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (addCategoryTextField) in
            addCategoryTextField.placeholder = "Add New Category"
            textField = addCategoryTextField
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancle", style: .default) { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manupulation
    
    func save(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Saving Category error \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
}

//MARK: Swipe Cell Delegate Method
extension CategoryViewController: SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle mode by updating data with deletion
            if let categoryForDeletion = self.categories?[indexPath.row]{
                do{
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                        
                    }
                }catch{
                    print(error)
                }
               
            }
            
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }

    
}
