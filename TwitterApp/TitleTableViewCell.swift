//
//  TitleTableViewCell.swift
//  TwitterApp
//
//  Created by Jake SWEDENBURG on 10/20/16.
//  Copyright © 2016 Jake Swedenbug. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
