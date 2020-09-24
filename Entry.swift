//
//  Entry.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 14.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import UIKit
import Foundation
import CoreData

struct MyDate{
    var day = 00
    var month = 00
    var year = 0000
    
    init(from dt: Date){
        var dateString = ""
        var index = 0
        for c in dt.description{
            if c != "-" && c != " " {
                dateString.append(c)
            } else {
                if index == 0{
                    self.year = Int(dateString)!
                    dateString = ""
                    index += 1
                } else if index == 1{
                    self.month = Int(dateString)!
                    dateString = ""
                    index += 1
                } else {
                    self.day = Int(dateString)!
                    dateString = ""
                    break
                }
            }
        }
    }
    
    // Получение презентации даты. Для ближайщих двух дней: "Сегодня" и "Завтра", для отсальных дд/мм
    func getDate() -> String{
        var result = ""
        let currentDate = MyDate(from: Date(timeIntervalSinceNow: 0))
        
        
        let dayDistance = self.day - currentDate.day
        let monthDistance = self.month - currentDate.month
        let yearDistance = self.year - currentDate.year
        
        
        if yearDistance == 0 && dayDistance == 0 && monthDistance == 0{
                result = "Сегодня"
            } else if yearDistance == 0 && monthDistance == 0 && dayDistance == 1 {
                result = "Завтра"
            } else if yearDistance == 0 && monthDistance == 0 && dayDistance == -1 {
                result = "Вчера"
            } else {
            if self.day >= 10{
                result += "\(self.day)/"
            } else {
                result += "0\(self.day)/"
            }
            
            if self.month >= 10{
                result += "\(self.month)"
            } else {
                result += "0\(self.month)"
            }
            if yearDistance != 0{
                result += "/\(self.year)"
            }
        }
        
        return result
    }
    
}

var allEntries: [Entry] = []
func createData(for entry: Entry) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let entryEntity = NSEntityDescription.entity(forEntityName: MyCoreDataAttributes.entryEntityName.rawValue, in: managedContext)!
    
    let task = NSManagedObject(entity: entryEntity, insertInto: managedContext)
    task.setValue(entry.name, forKey: MyCoreDataAttributes.entName.rawValue)
    task.setValue(entry.cost, forKey: MyCoreDataAttributes.cost.rawValue)
    task.setValue(entry.category, forKey: MyCoreDataAttributes.category.rawValue)
    task.setValue(entry.date, forKey: MyCoreDataAttributes.date.rawValue)
    
    do {
        try managedContext.save()
    } catch let error {
        print("Error \(error)")
    }
}
func retrieveData() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: MyCoreDataAttributes.entryEntityName.rawValue)
    
    do {
        let result = try managedContext.fetch(fetchRequest)
        for data in result as! [NSManagedObject] {
            
            let newEntry = Entry()
            newEntry.name = data.value(forKey: MyCoreDataAttributes.entName.rawValue) as! String
            newEntry.cost = data.value(forKey: MyCoreDataAttributes.cost.rawValue) as! Double
            newEntry.category = data.value(forKey: MyCoreDataAttributes.category.rawValue) as! String
            newEntry.date = data.value(forKey: MyCoreDataAttributes.date.rawValue) as! Date
            
            print(newEntry)
            allEntries.append(newEntry)
        }
        
    } catch let error {
        print("Error \(error)")
    }
}
func deleteData(_ entry: Entry) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let deleteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: MyCoreDataAttributes.entryEntityName.rawValue)
    deleteRequest.predicate = NSPredicate(format: "\(MyCoreDataAttributes.entName.rawValue) = %@", entry.name)
    
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
    for (i, en) in allEntries.enumerated() {
        if en == entry {
            indexToDelete = i
        }
    }
    allEntries.remove(at: indexToDelete!)
}

class Entry: CustomStringConvertible {
    var description: String {"\(name): \(type.rawValue) \(cost) \(myDate.getDate())"}
    
    var name = ""
    
    var cost = 0.0
    var costString: String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        
        let costNumber = NSNumber(value: cost >= 0 ? cost : -cost)
        let result = formatter.string(from: costNumber)
        
        return result!
    }
    
    var date = Date()
    var myDate: MyDate { .init(from: date) }
    
    var type: EntryType { isPositive() ? .income : .outcome }
    var typeString: String { type.rawValue }
    var category = ""
    
    func isPositive() -> Bool {
        return cost >= 0
    }

}

func == (left: Entry, right: Entry) -> Bool {
    var result = false
    
    if left.name == right.name &&
        left.myDate.getDate() == right.myDate.getDate() &&
        left.category == right.category &&
        left.cost == right.cost
    {
        result = true
    }
    
    return result
}
