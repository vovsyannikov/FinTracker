//
//  Entry.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 14.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import Foundation

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
