//
//  CategoryDetailViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 21.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit

class CategoryDetailViewController: UIViewController {
    
    var text = ""

    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textLabel.text = text
    }
    

}
