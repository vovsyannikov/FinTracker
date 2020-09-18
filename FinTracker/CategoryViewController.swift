//
//  CategoryViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 17.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit
import RealmSwift

protocol CategoryDelegate {
    func getCategory(from cat: String)
}

class MyCategory: Object {
    @objc dynamic var name = ""
    @objc dynamic var iconName = ""
    var icon: UIImage { UIImage(systemName: iconName)!}
    
    override var description: String { "\(name): \(iconName)"}
}

class CategoryViewController: UIViewController {
    let realm = try! Realm()
    
    var choosingCategory = false
    var delegate: CategoryDelegate?
    
    var availibaleCategories: [MyCategory] = []
    
    @IBOutlet weak var categoriesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        func sortCategories() {
            var tempCategories: [MyCategory] = []
            var index = choosingCategory ? 1 : 0
            while tempCategories.count < availibaleCategories.count {
                for cat in availibaleCategories {
                    if index > 6 { break }
                    if cat.name == getEntryType(from: index).rawValue {
                        print(index, tempCategories)
                        tempCategories.append(cat)
                        index += 1
                    }
                }
            }
            availibaleCategories = tempCategories
        }
        func testLoadCategories() {
            func newItem(_ item: (key: EntryType, value: IconNames), at index: inout Int) -> MyCategory {
                let newCategory = MyCategory()
                
                newCategory.name = item.key.rawValue
                newCategory.iconName = item.value.rawValue
                
                return newCategory
            }
            var index = 0
            for cat in defaultCategories {
                if choosingCategory {
                    if cat.key == .income { continue }
                }
                availibaleCategories.append(newItem(cat, at: &index))
            }
            sortCategories()
        }
        testLoadCategories()
    }
    
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availibaleCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category") as! CategoryTableViewCell
        
        let categoryName = availibaleCategories[indexPath.row].name
        let categoryImage = availibaleCategories[indexPath.row].icon
        
        cell.nameLabel.text = categoryName
        cell.iconImageView.image = categoryImage
        
        if categoryName == EntryType.income.rawValue{
            cell.iconImageView.tintColor = myColors.green
        } else {
            cell.iconImageView.tintColor = myColors.red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category") as! CategoryTableViewCell
        if choosingCategory {
            
            let cellEntryType = availibaleCategories[indexPath.row].name
            delegate?.getCategory(from: cellEntryType)
            dismiss(animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
