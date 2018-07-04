//
//  TableViewController.swift
//  FireFun
//
//  Created by Tran Ngoc Nam on 7/2/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TableViewController: UITableViewController {

    var students: [Student] =  []
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        loadData()
    }
    
    func loadData() {
        ref.queryOrdered(byChild: "id").observe(.value) { snapshot in
            var newItems: [Student] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    if let studentItem = Student(snapshot: snapshot) {
                        newItems.append(studentItem)
                    }
                }
            }
            self.students = newItems
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let student = students[indexPath.row]
        
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = String(student.age)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let studentItem = students[indexPath.row]
            studentItem.ref?.removeValue()
            self.loadData()
        }
    }
    
    // MARK: Navigation
    // Sửa
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        guard let dataViewController = unwindSegue.source as? DataViewController else { return }
        guard let student = dataViewController.student else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let studentItem = students[indexPath.row]
        studentItem.ref?.updateChildValues(student.toAnyObject() as! [AnyHashable : Any])
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dataViewController = segue.destination as? DataViewController else { return }
        guard let index = tableView.indexPathForSelectedRow else { return }
        let studentItem = students[index.row]
        print("NamTN: \(studentItem.name)")
        dataViewController.student = studentItem
    }

    @IBAction func addNewStudent(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Student Item", message: "Add a student", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let firstTextField = alert.textFields?.first else { return }
            guard let lastTextField = alert.textFields?.last else { return }
            
            if let id = firstTextField.text, let name = lastTextField.text {
                let studentItem = Student(id: Int(id)!, name: name, age: 19, address: "Ha Noi")
                let studentItemRef = self.ref.child(id.lowercased())
                studentItemRef.setValue(studentItem.toAnyObject())
                self.loadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        alert.addTextField()
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // 
}



