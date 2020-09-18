//
//  CategoryViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 17.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    typealias Category = [(name: String, icon: UIImage)]
    
    let defaultCategories: Category = [
        (name: "Дом", icon: UIImage(systemName: "house.fill")!),
        (name: "Транспорт", icon: UIImage(systemName: "car.fill")!),
        (name: "Продукты", icon: UIImage(systemName: "cart.fill")!),
        (name: "Досуг", icon: UIImage(systemName: "person.3.fill")!),
        (name: "Электроника", icon: UIImage(systemName: "desktopcomputer")!),
        (name: "Другое", icon: UIImage(systemName: "barcode")!)
    ]
    var userCategories: Category = []

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
        
        return cell
    }
}
