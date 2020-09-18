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
    
    var userCategories: FinanceCategory = [:]
    
    
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
        func getCategoryName(from index: Int) -> EntryType {
            var result: EntryType?
            switch index {
            case 0: result = .income
            case 1: result = .house
            case 2: result = .transport
            case 3: result = .food
            case 4: result = .entertainment
            case 5: result = .electronics
            case 6: result = .other
            default: break
            }
            return result!
        }
        
        let categoryName = getCategoryName(from: indexPath.row)
        let categoryImage = defaultCategories[categoryName]
        
        cell.nameLabel.text = categoryName.rawValue
        cell.iconImageView.image = categoryImage
        
        if indexPath.row == 0{
            cell.iconImageView.tintColor = myColors.green
        } else {
            cell.iconImageView.tintColor = myColors.red
        }
        
        return cell
    }
}
