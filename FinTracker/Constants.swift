//
//  Constants.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 18.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import Foundation
import UIKit

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

func getIconName(from index: Int) -> IconNames {
    var result: IconNames?
    
    switch index {
    case 0:  result = .creditCard
    case 1:  result = .house
    case 2:  result = .transport
    case 3:  result = .food
    case 4:  result = .entertainment
    case 5:  result = .electronics
    case 6:  result = .other
        
    case 7:  result = .pen
    case 8:  result = .paperPlane
    case 9:  result = .map
    case 10: result = .envelope
    case 11: result = .phone
        
    default: break
    }
    
    return result!
}

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

func getEntryType(from index: Int) -> EntryType {
    var result: EntryType?
    switch index {
    case 0: result = .income
    case 1: result = .house
    case 2: result = .transport
    case 3: result = .food
    case 4: result = .entertainment
    case 5: result = .electronics
    case 6: result = .other
    default: break
    }
    return result!
}

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

