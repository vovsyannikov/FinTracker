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

class CategoryViewController: UIViewController {
    
    var choosingCategory = false
    var delegate: CategoryDelegate?
    var categoriesToShow: [MyCategory] = []
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var createCategoryButton: UIButton!
    
    @IBOutlet weak var categoriesTableView: UITableView!
    
    //MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if categoriesToShow.count == 0 {
            retrieveCategoryData()
        }
        switch choosingCategory {
        case true: categoriesToShow = choosingCategoriesLoader()
        case false: categoriesToShow = availibaleCategories
        }
        
        print(categoriesToShow)
    }
    
    func choosingCategoriesLoader() -> [MyCategory]{
        var result: [MyCategory] = []
        
        for cat in availibaleCategories.dropFirst() {
            result.append(cat)
        }
        
        return result
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
        createCategoryData(for: cat)
        categoriesTableView.reloadData()
    }
    
    
}

// MARK: ext TableView
extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesToShow.count
    }
    
    //MARK: cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category") as! CategoryTableViewCell
        
        let categoryName = categoriesToShow[indexPath.row].name
        let categoryImage = categoriesToShow[indexPath.row].icon
        
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
            let cellEntryType = categoriesToShow[indexPath.row].name
            delegate?.getCategory(from: cellEntryType)
            dismiss(animated: true, completion: nil)
        } else {
            let cell = categoriesToShow[indexPath.row]
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
                
                deleteCategoryData(availibaleCategories[indexPath.row])
                
                self.categoriesTableView.beginUpdates()
                self.categoriesTableView.deleteRows(at: [indexPath], with: .automatic)
                self.categoriesTableView.endUpdates()

                self.categoriesTableView.reloadData()
            }
        }

    }
}
