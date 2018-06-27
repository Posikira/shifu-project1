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
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ListItem) {
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
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
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editaction = edit(at: indexPath)
        let delete = deleteAction(at: indexPath)
        load()
        return UISwipeActionsConfiguration(actions: [delete, editaction])
    }
    
    func edit(at indexPath: IndexPath) -> UIContextualAction {
        let groceries = groceriesArray?[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            //here perform edit actions
            self.performSegue(withIdentifier: "editItem", sender: self)
            completion(true)
        }
        action.image = #imageLiteral(resourceName: "icons8-edit-30")
        action.backgroundColor = .purple
        return action
        
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            if let item = self.groceriesArray?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(item)
                        
                    }
                } catch {
                    print("Error saving category \(error)")
                }
                
                let indexPaths = [indexPath]
                self.tableView.deleteRows(at: indexPaths, with: .fade)
                //self.load()
                self.tableView.reloadData()
                completion(true)
            }
           // load()
            //self.groceriesArray.remove(at: indexPath.row)
            //self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        action.image = #imageLiteral(resourceName: "icons8-trash-can-30")
        action.backgroundColor = .red
        return action
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
    
 //   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if let item = self.groceriesArray?[indexPath.row] {
//        do {
//            try self.realm.write {
//                self.realm.delete(item)
//
//            }
//        } catch {
//            print("Error saving category \(error)")
//        }
//
//            let indexPaths = [indexPath]
//            tableView.deleteRows(at: indexPaths, with: .fade)
//            load()
//            tableView.reloadData()
//
//        }
       
        
        
    //}
    
    
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "anotherSegue", sender: self)
    }
    func load() {
        
        groceriesArray = realm.objects(ListItem.self)
        groceriesArray = groceriesArray?.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItem" {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
        } else if segue.identifier == "editItem" {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
//            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
//                controller.itemToEdit = groceriesArray![indexPath.row]
//            }
        }
    }
    
    
    
    
    
    
    
}
    




