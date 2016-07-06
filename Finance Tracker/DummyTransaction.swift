//
//  DummyTransaction.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/6/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import Foundation
import RealmSwift

class DummyTransaction: Object {
    
    dynamic var transactionId = NSUUID().UUIDString
    dynamic var name = ""
    dynamic var price: Double = 0.0
    dynamic var created = NSDate()
    dynamic var type = ""
    
    override class func primaryKey() -> String? {
        return "transactionId"
    }
    
    convenience init(name: String, price: Double, type: String, date: NSDate) {
        self.init()
        self.name = name
        self.price = price
        self.type = type
        self.created = date 
    }
    
}
