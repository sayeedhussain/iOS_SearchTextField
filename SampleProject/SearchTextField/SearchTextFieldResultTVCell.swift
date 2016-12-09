//
//  SearchTextFieldResultTVCell.swift
//  assetplus
//
//  Created by Sayeed Munawar Hussain on 10/10/16.
//  Copyright © 2016 Sayeed Munawar Hussain. All rights reserved.
//

import UIKit

class SearchTextFieldResultTVCell: UITableViewCell {

    @IBOutlet private weak var lbl: UILabel!
    
    override func prepareForReuse() {
        clearCell()
        super.prepareForReuse()
    }
    
    func setTextValue(_ str: String) {
        self.lbl.text = str
    }
    
    private func clearCell() {
        lbl.text = nil
    }

}
