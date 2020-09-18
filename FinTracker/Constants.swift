//
//  Constants.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 18.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import Foundation
import UIKit

let myColors: (green: UIColor, red: UIColor) = (
    green: UIColor(red: 0, green: 0.5, blue: 0, alpha: 1),
    red: UIColor(red: 0.75, green: 0, blue: 0, alpha: 1)
)


typealias FinanceCategory = [(name: String, icon: UIImage)]
let defaultCategories: FinanceCategory = [
    (name: "Приход", icon: UIImage(systemName: "creditcard.fill")!),
    (name: "Дом", icon: UIImage(systemName: "house.fill")!),
    (name: "Транспорт", icon: UIImage(systemName: "car.fill")!),
    (name: "Продукты", icon: UIImage(systemName: "cart.fill")!),
    (name: "Досуг", icon: UIImage(systemName: "person.3.fill")!),
    (name: "Электроника", icon: UIImage(systemName: "desktopcomputer")!),
    (name: "Другое", icon: UIImage(systemName: "barcode")!)
]

