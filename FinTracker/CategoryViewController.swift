//
//  CategoryViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 17.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit

protocol CategoryDelegate {
    func getCategory(from cat: String)
}

class CategoryViewController: UIViewController {
    static let shared = CategoryViewController()
    
    var userCategories: FinanceCategory = [:]
    
    var choosingCategory = false
    var delegate: CategoryDelegate?
    
    @IBOutlet weak var categoriesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultCategories.count + userCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category") as! CategoryTableViewCell
        
        let categoryName = getEntryType(from: indexPath.row)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let category = getEntryType(from: indexPath.row)
        print(category)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
