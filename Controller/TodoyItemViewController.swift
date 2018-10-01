//
//  ViewController.swift
//  Todoy Practice
//
//  Created by Kamrul Hassan Sabuj on 30/9/18.
//  Copyright © 2018 SahiTech. All rights reserved.
//

import UIKit
import RealmSwift
class TodoyItemViewController: UITableViewController {

    var todoItems : Results<Item>?
    
    let realm = try! Realm()
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
        
        if  let currentItem = todoItems?[indexPath.row]{
            cell.textLabel?.text = currentItem.title
            cell.accessoryType = currentItem.done ? .checkmark : .none
            
        }else{
            cell.textLabel?.text = "No Item Added"
        }
     
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return todoItems?.count ?? 1
    }

    //MARK: - TableView Delegate MEthod
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    //for deleteing selecting item
                    //realm.delete(item)
                    
                   item.done = !item.done
                }
            }catch{
                print("Saving done status error, \(error)")
            }
        }
        tableView.reloadData()
        
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (UIAlertAction) in
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.currentTime = Date()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                        print(Date())
                    }
                }catch{
                    print("Saving Item error \(error)")
                }
                
            }
            self.tableView.reloadData()
            
        }
  
        alert.addTextField { (addItemTextField) in
            addItemTextField.placeholder = "Add New Item"
            textField = addItemTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
   
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

    }

}

//MARK: - Search Bar Method

extension TodoyItemViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "title", ascending: true)
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "currentTime", ascending: true)
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
