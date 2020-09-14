//
//  Entry.swift
//  FinTracker
//
//  Created by Виталий Овсянников on 14.09.2020.
//  Copyright © 2020 Виталий Овсянников. All rights reserved.
//

import Foundation
import RealmSwift

class Entry: Object {
    override var description: String {"\(name): \(cost) \(date)"}
    
    @objc dynamic var name = ""
    @objc dynamic var cost = 0.0
    @objc dynamic var date = Date()
    @objc dynamic var category = ""
    
    func isPositive() -> Bool {
        return cost >= 0
    }
}
