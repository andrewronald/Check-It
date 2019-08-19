//
//  ViewController.swift
//  Check It
//
//  Created by Andrew Aguilar on 8/13/19.
//  Copyright © 2019 Andrew Aguilar. All rights reserved.
//

import UIKit
import CoreData
class ListViewController: UITableViewController{
    var items = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        return items.count
    }
    func configureTableView(){
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        cell.accessoryType = items[indexPath.row].complete ? .checkmark : .none
        return cell
        
    }
    @objc func tableViewTapped(){
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.row])
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        items[indexPath.row].complete = !items[indexPath.row].complete //toggles accessorytype
//        context.delete(items[indexPath.row])
//        items.remove(at: indexPath.row)
//        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add Item To List
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("add item button pressed")
            print(textField.text!)
            if(!textField.text!.isEmpty){
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.complete = false
                newItem.parentCategory = self.selectedCategory
                self.items.append(newItem)
//                self.defaults.set(self.items, forKey: "ItemsArray")
                self.saveItems()
                
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

    func saveItems(){
        do{
            try context.save()
        }catch{
            print("ERROR")
            print("ERROR")
            print("ERROR")
            print("ERROR")
            print("\(error)")
            }
        self.tableView.reloadData()
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additonalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additonalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        //        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//        request.predicate = compoundPredicate
        do{
            items = try context.fetch(request)
        }catch{
            print("ERROR")
            print("ERROR")
            print("ERROR")
            print("ERROR")
            print("\(error)")
            
        }
        tableView.reloadData()
    }
    
}
extension ListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
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
