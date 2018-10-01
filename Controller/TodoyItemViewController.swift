//
//  ViewController.swift
//  Todoy Practice
//
//  Created by Kamrul Hassan Sabuj on 30/9/18.
//  Copyright © 2018 SahiTech. All rights reserved.
//

import UIKit
import CoreData
class TodoyItemViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Items]()
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    
    //MARK: - TableView DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoListItemCell", for: indexPath)
        
        let currentItem = itemArray[indexPath.row]
        
        cell.accessoryType = currentItem.done ? .checkmark : .none
        cell.textLabel?.text = currentItem.title
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemArray.count
    }

    //MARK: - TableView Delegate MEthod
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (UIAlertAction) in
            
            let newItem = Items(context: self.context)
            
            newItem.parentCategory = self.selectedCategory
            newItem.title = textField.text
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItem()
        }
        
        alert.addTextField { (addItemTextField) in
            addItemTextField.placeholder = "Add New Item"
            textField = addItemTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveItem(){
        do{
            try context.save()
        }catch{
            print("Saving Items Error \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Items> = Items.fetchRequest(), predicate : NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
           itemArray =  try context.fetch(request)
        }catch{
            print("Fetching data from context error \(error)")
        }
        tableView.reloadData()
        
    }
    
}

//MARK: - Search Bar Method

extension TodoyItemViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Items> = Items.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
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
