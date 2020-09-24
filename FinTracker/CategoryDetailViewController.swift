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
    var sortedEntries: [Entry] = []
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var sortingSegControl: UISegmentedControl!
    @IBOutlet weak var periodSegmentControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for entry in allEntries{
            if entry.category == currentCategory.name {
                applicableEntries.append(entry)
            }
        }
        sortedEntries = applicableEntries
        navItem.title = currentCategory.name
    }
    
    @IBAction func changeSorting(_ sender: Any) {
        switch periodSegmentControl.selectedSegmentIndex {
        case 0: sortedEntries = dateSort(applicableEntries, by: .all)
        case 1: sortedEntries = dateSort(applicableEntries, by: .year)
        case 2: sortedEntries = dateSort(applicableEntries, by: .month)
        case 3: sortedEntries = dateSort(applicableEntries, by: .week)
        case 4: sortedEntries = dateSort(applicableEntries, by: .day)
        default: break
        }
        categoriesTableView.reloadData()
    }
    
}

extension CategoryDetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryEntry") as! EntryTableViewCell
        
        let currentEntry = sortedEntries[indexPath.row]
        cell.nameLabel.text = currentEntry.name
        cell.dateLabel.text = currentEntry.myDate.getDate()
        cell.costLabel.text = currentEntry.costString
        cell.setSignImageView(with: currentEntry.type)
        
        return cell
    }
    
    
}
