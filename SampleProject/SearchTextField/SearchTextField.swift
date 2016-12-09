//
//  SearchTextField.swift
//  assetplus
//
//  Created by Sayeed Munawar Hussain on 10/10/16.
//  Copyright © 2016 Sayeed Munawar Hussain. All rights reserved.
//

import UIKit

protocol SearchTextFieldDelegate: class {
    func didSelectResult(_ result: String)
}

class SearchTextField: UITextField {

    //////configurable properties from other classes
    
    /**
     The delegate that will handle the callback invoked when a search result is chosen.
    */
    weak var searchDelegate: SearchTextFieldDelegate?
    
    /**
     The y Offset of the search results drop down from the search text field. It defaults to 0.
    */
    var tableViewOffsetFromTextField: CGFloat = 0
    
    /**
     The max height of the search results drop down. Default height is 44.0(row Height) * 3. Ignored if keyboard frame hides the search results.
    */
    var tableViewMaxHeight: CGFloat?
    
    /////end of configurable properties

    fileprivate var dataSource: [String]?
    fileprivate var filteredDataSource: [String]?

    fileprivate var tableViewHeight: NSLayoutConstraint!
    fileprivate let tableViewDefaultHeight: CGFloat = 44.0 /*row height*/ * 3 /*num rows*/
    fileprivate var tableView: UITableView
    
    override init(frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)) {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        super.init(frame: frame)
        _sminitialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
        super.init(coder: aDecoder)
        _sminitialize()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func didMoveToSuperview() {
       
        super.didMoveToSuperview()
        
        if let _ = self.superview {//this is called whenever the superView changes that is both on load and unload of superview.
            //so need to check before we lay it out.
            _layout()
        }
    }
    
    func setDataSource(_ dataSource: [String]) {
        
        DispatchQueue.main.async {
            self.dataSource = dataSource
        }
    }
    
    func dismissSearch() {
        _dismiss()
    }
    
    fileprivate func _sminitialize() {//initialization
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.delegate = self

        tableView.register(UINib(nibName: String(describing: SearchTextFieldResultTVCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SearchTextFieldResultTVCell.self))

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.borderWidth = 1.0
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.tableFooterView = UIView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(SearchTextField.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    fileprivate func _dismiss() {//dismiss
        self.resignFirstResponder()
//        self.text = nil
        filteredDataSource = nil
        tableView.reloadData()
        tableView.isHidden = true
    }
    
    fileprivate func _layout() {
        
        self.superview?.addSubview(tableView)
        self.superview?.bringSubview(toFront: tableView)
        
        var constraints = [NSLayoutConstraint]()
        
        let views: [String: AnyObject] = ["tableView": tableView, "textField": self]
        
        //          H:|-[icon(==iconDate)]-20-[iconLabel(120@250)]-20@750-[iconDate(>=50)]-|
        
        let ver = NSLayoutConstraint.constraints(withVisualFormat: "V:[textField]-\(tableViewOffsetFromTextField)-[tableView]", options: [.alignAllLeading], metrics: nil, views: views)
        let hor = NSLayoutConstraint.constraints(withVisualFormat: "H:[tableView(==textField)]", options: [], metrics: nil, views: views)
        
        tableViewHeight = NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: tableViewMaxHeight ?? tableViewDefaultHeight)

        constraints += ver
        constraints += hor
        
        constraints += [tableViewHeight!]
        
        NSLayoutConstraint.activate(constraints)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension SearchTextField: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredDataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchTextFieldResultTVCell.self), for: indexPath) as! SearchTextFieldResultTVCell
        cell.setTextValue(self.filteredDataSource?[indexPath.row] ?? "")
        cell.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, cell.bounds.size.width)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.searchDelegate?.didSelectResult(self.filteredDataSource![indexPath.row])
        _dismiss()
    }    
}

//MARK:- Keyboard

extension SearchTextField {
    
    func keyboardWillShow(_ notif: NSNotification) {
        
        guard var keyboardBounds = (notif.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        keyboardBounds = self.superview!.convert(keyboardBounds, to: nil)
        let selfBounds = self.superview!.convert(self.frame, to: nil)
        let deltaY = selfBounds.origin.y + selfBounds.size.height + 10 /*extra padding*/ - keyboardBounds.origin.y
        
        if let _tableViewMaxHeight = tableViewMaxHeight {//if tableViewMaxHeight is set, use it.
            tableViewHeight.constant = _tableViewMaxHeight > -deltaY ? -deltaY : _tableViewMaxHeight
        }
        else {
            tableViewHeight.constant = -deltaY
        }
    }
}

//MARK:- UITextFieldDelegate

extension SearchTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if range.location == 0 && string.characters.count == 0 {//last character being deleted, just hide the tableView and return.
            tableView.isHidden = true
            return true
        }
        
        self.filteredDataSource = self.dataSource?.filter({(item) -> Bool in
            let searchStr = textField.text!.lowercased() + string.lowercased()
            return item.lowercased().contains(searchStr) ? true : false
        })
        
        if let results = self.filteredDataSource {
            self.tableView.isHidden = results.count == 0 ? true : false
        }
        else {
            self.tableView.isHidden = true
        }
        
        self.tableView.reloadData()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _dismiss()
        return false
    }
}
