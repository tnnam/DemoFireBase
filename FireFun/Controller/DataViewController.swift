//
//  DataViewController.swift
//  FireFun
//
//  Created by Tran Ngoc Nam on 7/2/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    var student: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure() {
        if let student = student {
            IDTextField.text = String(student.id)
            nameTextField.text = student.name
            ageTextField.text = String(student.age)
            addressTextField.text = student.address
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = IDTextField.text else { return }
        guard let name = nameTextField.text else { return }
        guard let age = ageTextField.text else { return }
        guard let address = addressTextField.text else { return }
        let studentItem = Student(id: Int(id) ?? 0, name: name, age: Int(age) ?? 0, address: address)
        student = studentItem
    }

    
}
