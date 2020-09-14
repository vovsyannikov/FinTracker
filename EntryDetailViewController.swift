//
//  EntryDetailViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 14.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var name = ""
    var cost = ""
    var sign = UIImage()
    var color = UIColor()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var signImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        costLabel.text = cost
        signImageView.image = sign
        
        signImageView.tintColor = color
        costLabel.textColor = color
    }
    

}
