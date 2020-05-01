//
//  RealmService.swift
//  myExpensesApp
//
//  Created by rau4o on 4/30/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import RealmSwift
import UIKit

class RealmService {
    
    private init() {}
    
    static let shared = RealmService()
//    weak var delegate: update?
    
    var realm = try! Realm()
    
    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
//                delegate?.updateTableView()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
//                delegate?.updateTableView()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}


