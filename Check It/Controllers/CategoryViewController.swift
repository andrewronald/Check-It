//
//  CategoryViewController.swift
//  Check It
//
//  Created by Andrew Aguilar on 8/19/19.
//  Copyright © 2019 Andrew Aguilar. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework
class CategoryViewController: SwipeTableViewController{
    let realm = try! Realm()
    var categoryItems: Results<Category>?
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        tableView.separatorStyle = .none
        //tableView.rowHeight = 70
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItems?.count ?? 1
    }
    
    //MARK: Add New Categories
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categoryItems?[indexPath.row]{
            cell.textLabel?.text = category.name
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
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
                newCategory.color = UIColor.randomFlat.hexValue()
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
    //MARK: DATA MANIPULATION METHODS
    
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
    //MARK: DELETE DATA FROM SWIPE
    override func updateModel(at indexPath: IndexPath) {
        if let categoryDeletion = self.categoryItems?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(categoryDeletion)
                }
            }catch{
                print("ERROR")
                print("ERROR")
                print("ERROR")
                print("ERROR")
                print("Erorr deleting category")
                print("\(error)")
            }
                        //tableView.reloadData()
        }
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
