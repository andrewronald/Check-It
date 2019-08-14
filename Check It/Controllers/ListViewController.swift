//
//  ViewController.swift
//  Check It
//
//  Created by Andrew Aguilar on 8/13/19.
//  Copyright © 2019 Andrew Aguilar. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    var items = [Item]()
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        let newItem = Item()
        newItem.title="Buy Tires"
        items.append(newItem)
        let newItem1 = Item()
        newItem1.title="Update Resume"
        items.append(newItem1)
        let newItem2 = Item()
        newItem2.title="Get New Shoes"
        items.append(newItem2)
        if let itemsPList = defaults.array(forKey: "ItemsArray") as? [Item]{
            items = itemsPList
        }
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
        items[indexPath.row].complete = !items[indexPath.row].complete
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
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
                let newItem = Item()
                newItem.title = textField.text!
                self.items.append(newItem)
                self.defaults.set(self.items, forKey: "ItemsArray")
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
}



