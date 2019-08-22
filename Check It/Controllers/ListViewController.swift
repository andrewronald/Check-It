//
//  ViewController.swift
//  Check It
//
//  Created by Andrew Aguilar on 8/13/19.
//  Copyright © 2019 Andrew Aguilar. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class ListViewController: SwipeTableViewController{
    var items: Results<Item>?
    let realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let colorHex = selectedCategory?.color else {fatalError()}
        title = selectedCategory?.name
        updateNavBar(withHexcode: colorHex)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexcode: "48DBFB")
    }
    //MARK: NAVI METHODS
    func updateNavBar(withHexcode colorHexCode: String){
        guard let navBar = navigationController?.navigationBar else {fatalError("Navi controller does not exist :(")}
        guard let navBarColor = UIColor(hexString: colorHexCode) else{fatalError()}
        navBar.barTintColor = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        searchBar.barTintColor = navBarColor
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    func configureTableView(){
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row]{
            cell.textLabel?.text = item.title
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            cell.accessoryType = item.complete ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
        }
        
        return cell
        
    }
    @objc func tableViewTapped(){
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row]{ //selected item
            do{
                try realm.write{
                    item.complete = !item.complete
                }
            }catch{
                print("ERROR")
                print("ERROR")
                print("ERROR")
                print("ERROR")
                print("error saving complete satus")
                print("\(error)")
            }
        }
        tableView.reloadData()
        
    }
    
    //MARK - Add Item To List
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("add item button pressed")
            print(textField.text!)
            if(!textField.text!.isEmpty){
                if let currentCategory = self.selectedCategory{
                    do{
                        try self.realm.write{
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    }catch{
                        print("ERROR")
                        print("ERROR")
                        print("ERROR")
                        print("ERROR")
                        print("\(error)")
                    }
                }
                self.tableView.reloadData()  
                
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter new item"
            textField = alertTextField
            //print(alertTextField.text)
        }
         alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func loadItems(){
        items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        if let item = items?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(item)
                }
            }catch{
                print("ERROR")
                print("ERROR")
                print("ERROR")
                print("ERROR")
                print("Error deleting item")
                print("\(error)")
            }
        }
    }
}
//start extension

extension ListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
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

