//
//  CategoryViewController.swift
//  Todoy Practice
//
//  Created by Kamrul Hassan Sabuj on 30/9/18.
//  Copyright © 2018 SahiTech. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategory()
       
    }

    //MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCell", for: indexPath)
        
        let currentCategory = categoryArray[indexPath.row]
        cell.textLabel?.text = currentCategory.name
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    //MARK: - TableView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoyItemViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
           destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField  = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (UIAlertAction) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categoryArray.append(newCategory)
            
            self.saveCategory()
            
        }
        alert.addTextField { (addCategoryTextField) in
            addCategoryTextField.placeholder = "Add New Category"
            textField = addCategoryTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manupulation
    
    func saveCategory(){
        do{
         try context.save()
        }catch{
            print("Saving Category error \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        do{
         categoryArray = try context.fetch(request)
        }catch{
            print("Loading Category Eroor \(error)")
        }
        tableView.reloadData()
    }
}
