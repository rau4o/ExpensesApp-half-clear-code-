//
//  EntityModel.swift
//  myExpensesApp
//
//  Created by rau4o on 4/30/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import Foundation
import RealmSwift

class EntityModel: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var cash: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var mainCash: Int = 1200
    
    convenience init(name: String, cash: String, type: String, mainCash: Int) {
        self.init()
        self.name = name
        self.cash = cash
        self.type = type
        self.mainCash = mainCash
    }
}
