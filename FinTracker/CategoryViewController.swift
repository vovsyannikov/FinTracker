//
//  CategoryViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 17.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit

//MARK: Category Delegate
protocol CategoryDelegate {
    func getCategory(from cat: String)
}

//MARK: MyCategory class
class MyCategory: CustomStringConvertible {
    var name = ""
    var iconName = ""
    var icon: UIImage { UIImage(systemName: iconName)!}
    
    var description: String { "\(name): \(iconName)"}
}

class CategoryViewController: UIViewController {
    
    var choosingCategory = false
    var delegate: CategoryDelegate?
    
    var availibaleCategories: [MyCategory] = []
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var chooseLabel: UILabel!
    @IBOutlet weak var createCategoryButton: UIButton!
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    //MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if choosingCategory {
            createCategoryButton.isHidden.toggle()
            chooseLabel.text = "Выберете категорию"
        } else {
            chooseLabel.text = ""
        }
        
//        func sortCategories() {
//            var tempCategories: [MyCategory] = []
//            var index = choosingCategory ? 1 : 0
//
//            while tempCategories.count < availibaleCategories.count {
//                for cat in availibaleCategories {
//                    if index < 6 {
//                        if cat.name == getEntryType(from: index) {
//                            tempCategories.append(cat)
//                            index += 1
//                        }
//                    } else {
//                        if !tempCategories.contains(cat){
//                            tempCategories.append(cat)
//                        }
//                    }
//                }
//            }
//            availibaleCategories = tempCategories
//        }
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
//            sortCategories()
        }
        
        testLoadCategories()
        print(availibaleCategories)
        
    }
    
    //MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NewCategoryViewController, segue.identifier == SegueIDs.createNewCategory.rawValue {
    
            vc.delegate = self
        } else if let vc = segue.destination as? CategoryDetailViewController, segue.identifier == SegueIDs.showCategoryDetail.rawValue {
            let cell = sender as! MyCategory
            vc.text = cell.name
        }
    }
}

//MARK: ext New Category Delegate
extension CategoryViewController: NewCategoryDelegate{
    func saveNewCategory(_ cat: MyCategory) {
        availibaleCategories.append(cat)
        categoriesTableView.reloadData()
    }
    
    
}

// MARK: ext TableView
extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availibaleCategories.count
    }
    
    //MARK: cellForRowAt
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
    
    //MARK: didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if choosingCategory {
            let cellEntryType = availibaleCategories[indexPath.row].name
            delegate?.getCategory(from: cellEntryType)
            dismiss(animated: true, completion: nil)
        } else {
            let cell = availibaleCategories[indexPath.row]
            performSegue(withIdentifier: SegueIDs.showCategoryDetail.rawValue, sender: cell)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
