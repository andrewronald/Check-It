//
//  ViewController.swift
//  Check It
//
//  Created by Andrew Aguilar on 8/13/19.
//  Copyright © 2019 Andrew Aguilar. All rights reserved.
//

import UIKit
import RealmSwift
class ListViewController: UITableViewController{
    var items: Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath!)
//        if let itemsPList = defaults.array(forKey: "ItemsArray") as? [Item]{
//            items = itemsPList
//        }
        //loadItems()
        // Do any additional setup after loading the view.
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    func configureTableView(){
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath)
        if let item = items?[indexPath.row]{
            cell.textLabel?.text = item.title
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
    
}
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
