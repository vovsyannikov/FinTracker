//
//  CategoryDetailViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 21.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit

class CategoryDetailViewController: UIViewController {
    
    var currentCategory = MyCategory()
    var applicableEntries: [Entry] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var sortingSegControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for entry in allEntries{
            if entry.category == currentCategory.name {
                applicableEntries.append(entry)
            }
        }
        print(applicableEntries)
        titleLabel.text = currentCategory.name
    }
    

}

extension CategoryDetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applicableEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryEntry") as! EntryTableViewCell
        
        let currentEntry = applicableEntries[indexPath.row]
        print("Cell \(currentEntry)")
        cell.nameLabel.text = currentEntry.name
        cell.dateLabel.text = currentEntry.myDate.getDate()
        cell.costLabel.text = currentEntry.costString
        cell.setSignImageView(with: currentEntry.type)
        
        
        return cell
    }
    
    
}
