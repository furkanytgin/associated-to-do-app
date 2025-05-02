//
//  CategoryViewController.swift
//  Todoey
//
//  Created by furkan yetgin on 1.05.2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let datafilepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(datafilepath)
        //tüm categorileri listele
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (_) in
            // Buraya Core Data'ya kaydetme işlemi gelecek (2. adım)
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategories()
            

            
        }
        alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Write category name"
                textField = alertTextField
            }
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
    }


 
}


//MARK: - TableView Datasource Methods
extension CategoryViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
}



//MARK: -Add New & Get Categories
extension CategoryViewController{
    
    func saveCategories(){
        do{
            try self.context.save()
            tableView.reloadData()
        }catch{
            print("save categories error : \(error)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("load categories error : \(error)")
        }
    }
       
    
    

}

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
