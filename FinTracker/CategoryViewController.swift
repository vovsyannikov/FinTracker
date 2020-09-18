//
//  CategoryViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 17.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    static let shared = CategoryViewController()
    
    var userCategories: FinanceCategory = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultCategories.count + userCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category") as! CategoryTableViewCell
        
        let cat = defaultCategories[indexPath.row]
        
        cell.nameLabel.text = cat.name
        cell.iconImageView.image = cat.icon
        
        if indexPath.row == 0{
            cell.iconImageView.tintColor = myColors.green
        } else {
            cell.iconImageView.tintColor = myColors.red
        }
        
        return cell
    }
}
