//
//  SavedTranslationsTVC.swift
//  YandexApiConnectionTrial
//
//  Created by Dake Aga on 10/17/18.
//  Copyright © 2018 Dake Aga. All rights reserved.
//

import UIKit

class SavedTranslationsTVC: UITableViewCell {

    @IBOutlet weak var abbrvFromLabel: UILabel!
    @IBOutlet weak var textFromLabel: UILabel!
    @IBOutlet weak var abbrvToLabel: UILabel!
    @IBOutlet weak var transTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
