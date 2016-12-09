//
//  ViewController.swift
//  SampleProject
//
//  Created by Sayeed Munawar Hussain on 09/12/16.
//  Copyright © 2016 *. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet fileprivate weak var textField: SearchTextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.textField.searchDelegate = self
        self.textField.tableViewMaxHeight = 88.0
        self.textField.setDataSource(["Paris", "London", "Madrid", "Detroit", "Dublin", "Manchester", "San Francisco", "New York", "Melbourne", "Chicago", "Madison", "Denver", "Washington", "Milan"])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: SearchTextFieldDelegate {
    
    func didSelectResult(_ result: String) {
        self.textField.text = result
    }
}

