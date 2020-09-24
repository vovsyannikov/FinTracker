//
//  CategoryViewController.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 17.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit
import CoreData

//MARK: Category Delegate
protocol CategoryDelegate {
    func getCategory(from cat: String)
}

var availibaleCategories: [MyCategory] = []

//MARK: MyCategory class
class MyCategory: CustomStringConvertible {
    var name = ""
    var iconName = ""
    var icon: UIImage { UIImage(systemName: iconName)!}
    
    var description: String { "\(name): \(iconName)"}
    
    static func == (left: MyCategory, right: MyCategory) -> Bool {
        var result = false
        
        if left.name == right.name &&
            left.iconName == right.iconName {
            result = true
        }
        
        return result
    }
}

class CategoryViewController: UIViewController {
    
    var choosingCategory = false
    var delegate: CategoryDelegate?
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var createCategoryButton: UIButton!
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    //MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func sortCategories() {
            var tempCategories: [MyCategory] = []
            var index = choosingCategory ? 1 : 0
            
            func doesContain(_ cat: MyCategory, in categories: [MyCategory]) -> Bool {
                for el in categories {
                    if el == cat {
                        return true
                    }
                }
                return false
            }
            
            while tempCategories.count < availibaleCategories.count {
                for cat in availibaleCategories {
                    if index < 6 {
                        if cat.name == getEntryType(from: index) {
                            tempCategories.append(cat)
                            index += 1
                        }
                    } else {
                        if !doesContain(cat, in: tempCategories){
                            tempCategories.append(cat)
                        }
                    }
                }
            }
            availibaleCategories = tempCategories
        }
        func loadDefCategories() {
            func newItem(_ item: (key: EntryType, value: IconNames)) -> MyCategory {
                let newCategory = MyCategory()
                
                newCategory.name = item.key.rawValue
                newCategory.iconName = item.value.rawValue
                
                return newCategory
            }
            
            for cat in defaultCategories {
                if choosingCategory {
                    if cat.key == .income { continue }
                }
                availibaleCategories.append(newItem(cat))
            }
            sortCategories()
        }
        
        loadDefCategories()
        print(availibaleCategories)
        
    }
    
    //MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NewCategoryViewController, segue.identifier == SegueIDs.createNewCategory.rawValue {
            
            vc.delegate = self
        } else if let vc = segue.destination as? CategoryDetailViewController, segue.identifier == SegueIDs.showCategoryDetail.rawValue {
            let cell = sender as! MyCategory
            vc.currentCategory = cell
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{

            let error = UIAlertController(title: "Ошибка", message: "Нельзя удалить основную категорию", preferredStyle: .alert)
            error.addAction(UIAlertAction(
                                title: "OK",
                                style: .cancel,
                                handler: nil))
            if indexPath.row < 7 {
                self.present(error, animated: true, completion: nil)
            } else {
                self.categoriesTableView.beginUpdates()
                self.categoriesTableView.deleteRows(at: [indexPath], with: .automatic)
                self.categoriesTableView.endUpdates()

                self.categoriesTableView.reloadData()
            }
        }

    }
}
