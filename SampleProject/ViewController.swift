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

        self.textField.searchDelegate = self
        self.textField.setDataSource(["Paris", "London", "Madrid", "Detroit", "Dublin", "Manchester", "San Francisco", "New York", "Melbourne", "Chicago", "Madison", "Denver", "Washington", "Milan"])

        /*
        //Programmatic initialization

        let textField = SearchTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        textField.placeholder = "Enter City"
        textField.borderStyle = .roundedRect
        view.addSubview(textField)
        
        textField.searchDelegate = self
        textField.setDataSource(["Paris", "London", "Madrid", "Detroit", "Dublin", "Manchester", "San Francisco", "New York", "Melbourne", "Chicago", "Madison", "Denver", "Washington", "Milan"])
        
        let widthConstraint = NSLayoutConstraint(item: textField, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 250)
        textField.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
        textField.addConstraint(heightConstraint)
        
        let xConstraint = NSLayoutConstraint(item: textField, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 60)

        view.addConstraint(xConstraint)
        view.addConstraint(yConstraint)
        */
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

