//
//  LanguageTableViewCell.swift
//  YandexApiConnectionTrial
//
//  Created by Dake Aga on 10/10/18.
//  Copyright © 2018 Dake Aga. All rights reserved.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func congigureCell(text: String) {
        label.text = text
    }
}
