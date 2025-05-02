    //
    //  ViewController.swift
    //  Todoey
    //
    //  Created by Philipp Muellauer on 02/12/2019.
    //  Copyright © 2019 App Brewery. All rights reserved.
    //

    import UIKit
    import CoreData

    class TodoListViewController: UITableViewController{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        var itemArray: [DataItem] = []
        
        var selectedCategory: Category?{
            didSet{
                loadItems()
            }
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            //       databaseden verileri getiren func
            
        }
        
        //MARK: -UITableView DataSource
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return itemArray.count
            
        }
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
            
            let item = itemArray[indexPath.row]
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            return cell
        }
        
        //MARK: - UITableView Delegate
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            //        context.delete(itemArray[indexPath.row])
            //        itemArray.remove(at: indexPath.row)
            
            itemArray[indexPath.row].done = !itemArray[indexPath.row].done
            //.pliste değişiklikleri kaybetmek için
            
            saveItems()
            
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
                
                let newItem = DataItem(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
                self.saveItems()
                
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
        func saveItems() {
            
            do{
                try  context.save()
                tableView.reloadData()
                print("save işlemi başarılı")
            }catch{
                print("core date save ıtem hatası : \(error)")
            }
        }
        
        //functiona default parametre verdik
        func loadItems(with request: NSFetchRequest<DataItem> = DataItem.fetchRequest(), predicate: NSPredicate? = nil){
            //1. sorgu parent kategori için
            let categoryPredicate = NSPredicate(format: "parentCategory.name == %@", selectedCategory!.name!)
            //2.sorgu
            
             // burada kafalar yandı
            if let addtionalPredicate = predicate{
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
            }else{
                request.predicate = categoryPredicate
            }
            
            do{
                itemArray = try context.fetch(request)
                tableView.reloadData()
            }catch{
                print("load item hatası : \(error)")
            }
        }
    }

    extension TodoListViewController: UISearchBarDelegate{
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            let request: NSFetchRequest<DataItem> = DataItem.fetchRequest()
            
            //filtreleme işlemi
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            //sıralamasını alfabeye göre artan yap
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            loadItems(with: request, predicate: predicate)
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
