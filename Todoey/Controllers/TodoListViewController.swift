//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: SwipeTableViewController{
    
    var todoItems: Results<Item>?
    
    var realm = try! Realm()
    
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        databaseden verileri getiren func
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let deleteToItem = self.todoItems?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(deleteToItem)
                }
            }catch{
                print("swipper delete error : \(error)")
            }
        }
    }
    
    //MARK: -UITableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return todoItems?.count ?? 1
        
    }
//    Swipe özelliği mevcut
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell =  super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items yet"
            cell.accessoryType = .none
        }
        return cell
    }
    
    //MARK: - UITableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done.toggle()
                }
            }catch{
                print("güncelleme hatası : \(error)")
            }
        }
        
        tableView.reloadData()
        //seçtiğinde background yanıp söner
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add(button) New Item
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        // alert mesajı içeriği
        let alert = UIAlertController(title: "Add new Todo Item", message: "", preferredStyle: .alert)
        
        //button hareketleri ve özelleştirme
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // kullanıcı aletten add ıtem a tıkllayınca ne olsun?
            
            if let currentCategory = self.selectedCategory {
                
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.createdDate = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("add ıtem hatası : \(error)")
                }
            }
            self.tableView.reloadData()

            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}



extension TodoListViewController {
    // navigation arkaplan rengi için
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.3255, green: 0.9373, blue: 0.8667, alpha: 1)
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
  
    
    //functiona default parametre verdik
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData() 
        
    }
}

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "createdDate", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
}
