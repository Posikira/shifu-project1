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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - TableVeiw Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceriesArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.text = groceriesArray?[indexPath.row].text ?? "nothing here yet"
        
        
//        if let item = groceriesArray?[indexPath.row] {
//        cell.textLabel?.text = item.text
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let item = self.groceriesArray?[indexPath.row] {
        do {
            try self.realm.write {
                self.realm.delete(item)
            }
        } catch {
            print("Error saving category \(error)")
        }
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
            tableView.reloadData()
        }
    }
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "anotherSegue", sender: self)
    }
    func load() {
        groceriesArray = realm.objects(ListItem.self)
        tableView.reloadData()
    }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addItem" {
            let controller = segue.destination as! AddItemViewController
            controller.delegate = self
        }
    }
    
    
    
    
    
    
    
}
    




