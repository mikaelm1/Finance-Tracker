//
//  DateHelper.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/5/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import Foundation

struct DateHelper {
    
    static func monthFromDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.stringFromDate(date)
    }
    
    static func randomDateFrom(year year: Int) -> NSDate {
         let userCalender = NSCalendar.currentCalendar()
        let c = NSDateComponents()
        c.year = year
        c.month = Int(arc4random_uniform(12)) + 1
        c.day = Int(arc4random_uniform(28)) + 1
        return userCalender.dateFromComponents(c)!
    }
    
}
