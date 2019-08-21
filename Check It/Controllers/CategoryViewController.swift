//
//  CategoryViewController.swift
//  Check It
//
//  Created by Andrew Aguilar on 8/19/19.
//  Copyright © 2019 Andrew Aguilar. All rights reserved.
//

import UIKit
import RealmSwift
class CategoryViewController: UITableViewController {
    let realm = try! Realm()
    var categoryItems: Results<Category>?
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems?.count ?? 1
    }
    //MARK: - Data Manipulation Methods
    
    //MARK: Add New Categories
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryItems?[indexPath.row].name ?? "No categories added"
        return cell
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var categoryTextField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert    )
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            print("add category pressed")
            print(categoryTextField)
            if(!categoryTextField.text!.isEmpty){
                let newCategory = Category()
                newCategory.name = categoryTextField.text!
                self.saveCategory(category: newCategory)
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new category"
            categoryTextField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func saveCategory(category: Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("ERROR")
            print("ERROR")
            print("ERROR")
            print("ERROR")
            print("\(error)")
        }
        self.tableView.reloadData()
    }
    func loadCategory(){
        categoryItems = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    //MARK: - TableView DataSource Methods
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryItems?[indexPath.row]
        }
    }
}
