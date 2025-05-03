//
//  CategoryViewController.swift
//  Todoey
//
//  Created by furkan yetgin on 1.05.2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: SwipeTableViewController {
    
    var categoryArray: Results<Category>?
    
    var realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        //        tüm categorileri listele
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            // Buraya Core Data'ya kaydetme işlemi gelecek (2. adım)
            let newCategory = Category()
            newCategory.name = textField.text!
            self.saveCategories(newCategory)
            

            
        }
        alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Write category name"
                textField = alertTextField
            }
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
    }
    //MARK: - Delete Category From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let deleteToCategory = self.categoryArray?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(deleteToCategory.items)
                    self.realm.delete(deleteToCategory)
                }
            }catch{
                print("swipper delete error : \(error)")
            }
        }
    }

 
}


//MARK: - TableView Datasource Methods
extension CategoryViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
    }
    
//    SWipe özelliği mevcut
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //cell = süper classdaki cell özelliklerini ekle
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories yet"
        
        return cell
    }

}

//MARK: -TableView Delegate Methods

extension CategoryViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
}


//MARK: -Add New & Get Categories
extension CategoryViewController{
    
    func saveCategories(_ category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
            tableView.reloadData()
        }catch{
            print("save categories error : \(error)")
        }
    }
    
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }

}
//MARK: -navbar background color
extension CategoryViewController{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.3255, green: 0.9373, blue: 0.8667, alpha: 1)
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

}



