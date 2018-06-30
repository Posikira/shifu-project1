//
//  ViewController.swift
//  project1
//
//  Created by Eugene Posikyra on 15.06.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import UIKit
import RealmSwift
class TableViewController: UITableViewController, AddItemViewControllerDelegate {
    let realm = try! Realm()
    
    func addItemViewControllerDidCancel(_controller: AddItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishEditing item: ListItem) {
        
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ListItem) {
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func load() {

        groceriesArray = realm.objects(ListItem.self)
        groceriesArray = groceriesArray?.sorted(byKeyPath: "dateCreated", ascending: false)
        self.tableView.setEditing(false, animated: true)
        tableView.reloadData()
    }
    
    let item = ListItem()
    var groceriesArray: Results<ListItem>?
    var itemToEdit: ListItem?
    override func viewDidLoad() {
        load()
        super.viewDidLoad()
        tableView.separatorStyle = .singleLine
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            let item = self.groceriesArray?[indexPath.row]
            try! self.realm.write({
                self.realm.delete(item!)
            })
            
            tableView.deleteRows(at:[indexPath], with: .automatic)
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            let toBeUpdated = self.groceriesArray![indexPath.row]
            self.performSegue(withIdentifier: "editItem", sender: toBeUpdated)
        }
        edit.backgroundColor = .purple
        delete.backgroundColor = .red
        
        return [delete, edit]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceriesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.text = groceriesArray?[indexPath.row].text ?? "nothing here yet"
        
        
        if let item = groceriesArray?[indexPath.row] {
        cell.textLabel?.text = item.text
         }
        return cell
    }
    
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "anotherSegue", sender: self)
    }
    

    @IBAction func addItem(_ sender: UIBarButtonItem) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItem" {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
        }
        if segue.identifier == "editItem" {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
            if let item = sender as? ListItem {
                controller.itemToEdit = item
            }
            let object = sender as! ListItem
            controller.itemToDelete = object
        }
    }
    
    
    
    
    
    
    
    
    
    
}
    




