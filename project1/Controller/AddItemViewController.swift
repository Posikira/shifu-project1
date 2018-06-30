//
//  AddItemViewController.swift
//  project1
//
//  Created by Eugene Posikyra on 19.06.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import UIKit
import RealmSwift
protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(_controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ListItem)
    func addItemViewController(_ controller: AddItemViewController, didFinishEditing item: ListItem) 
}
class AddItemViewController: UITableViewController, UITextFieldDelegate {
    
    let realm = try! Realm()
    var textFields = UITextField()
    var newThings: Results<ListItem>?
    var itemToEdit: ListItem?
    var itemToDelete = ListItem()
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            textField1.text = item.content
            textField2.text = item.link
            doneBarButton.isEnabled = true
        }
    }
    weak var delegate: AddItemViewControllerDelegate?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        createOrUpdate()
        return true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
        textField.placeholder = "Create new item"
        textField1.placeholder = "Text"
        textField2.placeholder = "http://"
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            textField1.text = item.content
            textField2.text = item.link
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        delegate?.addItemViewControllerDidCancel(_controller: self)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        
        createOrUpdate()
    }

    func save(category: ListItem) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        load()
        tableView.reloadData()
    }
    
    func load() {
        newThings = realm.objects(ListItem.self)
        newThings = newThings?.sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
    }
    
    
    func createOrUpdate() {
        if let itemToEdit = itemToEdit {
            title = "Edit Item"
            do {
                try realm.write {
                    itemToEdit.text = textField.text!
                    itemToEdit.content = textField1.text!
                    itemToEdit.link = textField2.text!
                }
            } catch {
                print(error)
            }
            
            doneBarButton.isEnabled = true
            delegate?.addItemViewController(self, didFinishEditing: itemToEdit)
        } else {
            
            let item = ListItem()
            item.text = textField.text!
            item.content = textField1.text!
            item.link = textField2.text!
            item.dateCreated = Date()
            item.id = item.dateCreated!.description
            navigationController?.popViewController(animated: true)
            
            self.save(category: item)
            
            delegate?.addItemViewController(self, didFinishAdding: item)
        }
        
    }
}
