//
//  AddItemViewController.swift
//  project1
//
//  Created by Eugene Posikyra on 19.06.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import UIKit
protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(_controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ListItem)
}
class AddItemViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
    }
    weak var delegate: AddItemViewControllerDelegate?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        navigationController?.popViewController(animated: true)
        print("content of textfield: \(textField.text!)")
        let item = ListItem()
        item.text = textField.text!
        delegate?.addItemViewController(self, didFinishAdding: item)
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
        textField.placeholder = "create new item"
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        delegate?.addItemViewControllerDidCancel(_controller: self)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
//        navigationController?.popViewController(animated: true)
//        print("content of textfield: \(textField.text!)")
        
        let item = ListItem()
        item.text = textField.text!
        delegate?.addItemViewController(self, didFinishAdding: item)
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
