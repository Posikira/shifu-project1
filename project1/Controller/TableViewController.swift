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
 //       let newRowIndex = groceriesArray.count
//        groceriesArray.append(item)
//        digras.append(item)
//        print("Вот дигры \(digras.count)")
  //      let indexPath = IndexPath(row: newRowIndex, section: 0)
    //    let indexPaths = [indexPath]
       // tableView.insertRows(at: indexPaths, with: .automatic)
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    

    
    var digras = List<ListItem>()
    let item = ListItem()
//    var categories: Results<ListItem>
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
        
        if let item = groceriesArray?[indexPath.row] {
            
            cell.textLabel?.text = item.text
        }
        
        
        //cell.textLabel?.text = groceriesArray[indexPath.row].text
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
       
        if let item = groceriesArray?[indexPath.row] {
        
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("Error saving category \(error)")
        }
        }
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        tableView.reloadData()
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
    
    



