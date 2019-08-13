//
//  ViewController.swift
//  Check It
//
//  Created by Andrew Aguilar on 8/13/19.
//  Copyright © 2019 Andrew Aguilar. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    let items = ["Buy tires", "Go try one new balances", "Update resume"]
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.textLabel?.text = items[indexPath.row]
        return cell
        
    }
    @objc func tableViewTapped(){
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.row])
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}

