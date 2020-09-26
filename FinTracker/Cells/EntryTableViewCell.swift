//
//  EntryTableViewCell.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 14.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var signImageView: UIImageView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setSignImageView(with sign: EntryType) {
        switch sign {
        case .income: do {
            self.signImageView.image = UIImage(systemName: "plus.circle")
            self.signImageView.tintColor = myColors.green
            self.costLabel.textColor = myColors.green
        }
        case .outcome: do {
            self.signImageView.image = UIImage(systemName: "minus.circle")
            self.signImageView.tintColor = myColors.red
            self.costLabel.textColor = myColors.red
        }
        default: break
        }
    }

}
