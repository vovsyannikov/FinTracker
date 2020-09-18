//
//  Constants.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 18.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import Foundation
import UIKit

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

let myColors: (green: UIColor, red: UIColor) = (
    green: UIColor(red: 0, green: 0.5, blue: 0, alpha: 1),
    red: UIColor(red: 0.75, green: 0, blue: 0, alpha: 1)
)


typealias FinanceCategory = Dictionary<EntryType, UIImage>
let defaultCategories: FinanceCategory = [
    .income: UIImage(systemName: "creditcard.fill")!,
    .house: UIImage(systemName: "house.fill")!,
    .transport: UIImage(systemName: "car.fill")!,
    .food: UIImage(systemName: "cart.fill")!,
    .entertainment: UIImage(systemName: "person.3.fill")!,
    .electronics: UIImage(systemName: "desktopcomputer")!,
    .other: UIImage(systemName: "barcode")!
]

