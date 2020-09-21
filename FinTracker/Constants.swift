//
//  Constants.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 18.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import Foundation
import UIKit

//MARK: enum SegueIDs
enum SegueIDs: String {
    case createEntry = "CreateEntry"
    case updateEntry = "EntryDetail"
    case selectCategory = "CategorySelection"
    case createNewCategory = "CreateNewCategory"
    case showCategoryDetail = "CategoryDetail"
}

//MARK: enum IconNames
enum IconNames: String, CaseIterable {
    case creditCard = "creditcard.fill"
    case house = "house.fill"
    case transport = "car.fill"
    case food = "cart.fill"
    case entertainment = "person.3.fill"
    case electronics = "desktopcomputer"
    case other = "barcode"
    
    case pen = "pencil"
    case paperPlane = "paperplane.fill"
    case map = "map.fill"
    case envelope = "envelope.fill"
    case phone = "phone.fill"
}

//MARK: getIconName from index
func getIconName(from index: Int) -> String {
    var result: String?
    
    for (i, name) in IconNames.allCases.enumerated(){
        if i == index {
            result = name.rawValue
        }
    }
    
    return result!
}

//MARK: enum EntryType
enum EntryType: String, CaseIterable {
    case income = "Приход"
    
    case house = "Дом"
    case transport = "Транспорт"
    case food = "Еда"
    case entertainment = "Досуг"
    case electronics = "Электроника"
    case other = "Другое"
    
    case outcome = "Расход"
}

//MARK: getEntryType from index
func getEntryType(from index: Int) -> String {
    var result: String?
    
    for (i, type) in EntryType.allCases.enumerated(){
        if i == index {
            result = type.rawValue
        }
    }
    
    return result!
}

//MARK: My color pallete
let myColors: (green: UIColor, red: UIColor) = (
    green: UIColor(red: 0, green: 0.5, blue: 0, alpha: 1),
    red: UIColor(red: 0.75, green: 0, blue: 0, alpha: 1)
)


typealias FinanceCategory = Dictionary<String, IconNames>
let defaultCategories: Dictionary<EntryType, IconNames> = [
    .income: .creditCard,
    .house: .house,
    .transport: .transport,
    .food: .food,
    .entertainment: .entertainment,
    .electronics: .electronics,
    .other: .other
]

