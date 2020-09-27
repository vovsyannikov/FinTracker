//
//  MyCategory.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 26.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import Foundation
import UIKit
import CoreData


let defaultCategories: [(name: EntryType, iconName: IconNames)] = [
    (.income, .creditCard),
    (.house, .house),
    (.transport, .transport),
    (.food, .food),
    (.entertainment, .entertainment),
    (.electronics, .electronics),
    (.other, .other)
]

var availibaleCategories: [MyCategory] = []

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


func createCategoryData(for cat: MyCategory) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let catEntity = NSEntityDescription.entity(forEntityName: MyCoreDataAttributes.categoryEntityName.rawValue, in: managedContext)!
    
    let task = NSManagedObject(entity: catEntity, insertInto: managedContext)
    task.setValue(cat.name, forKey: MyCoreDataAttributes.name.rawValue)
    task.setValue(cat.iconName, forKey: MyCoreDataAttributes.iconName.rawValue)
    
    availibaleCategories.append(cat)
    
    do {
        try managedContext.save()
    } catch let error {
        print("Error \(error)")
    }
}
func retrieveCategoryData() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: MyCoreDataAttributes.categoryEntityName.rawValue)
    
    func defaultCategoryInit(){
        for cat in defaultCategories {
            let newCat = MyCategory()
            newCat.name = cat.name.rawValue
            newCat.iconName = cat.iconName.rawValue
            availibaleCategories.append(newCat)
        }
    }
    
    do {
        let result = try managedContext.fetch(fetchRequest)
        for data in result as! [NSManagedObject] {
            
            let newCategory = MyCategory()
            newCategory.name = data.value(forKey: MyCoreDataAttributes.name.rawValue) as! String
            newCategory.iconName = data.value(forKey: MyCoreDataAttributes.iconName.rawValue) as! String
            
            if availibaleCategories.count == 0 { defaultCategoryInit() }
            availibaleCategories.append(newCategory)
        }
        
    } catch let error {
        print("Error \(error)")
    }
}
func deleteCategoryData(_ cat: MyCategory) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let deleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: MyCoreDataAttributes.categoryEntityName.rawValue)
    deleteRequest.predicate = NSPredicate(format: "\(MyCoreDataAttributes.name.rawValue) = %@", cat.name)
    
    do {
        let deleteResult = try managedContext.fetch(deleteRequest)
        for (i, res) in deleteResult.enumerated() {
            print(i, res)
        }
        
        let objectToDelete = deleteResult[0] as! NSManagedObject
        managedContext.delete(objectToDelete)
        
        do {
            try managedContext.save()
        } catch let error {
            print("Error\(error)")
        }
        
    } catch let error {
        print("Error\(error)")
    }
    
    var indexToDelete: Int?
    for (i, en) in availibaleCategories.enumerated() {
        if en == cat {
            indexToDelete = i
        }
    }
    availibaleCategories.remove(at: indexToDelete!)
}
