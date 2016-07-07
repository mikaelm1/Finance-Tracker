//
//  DateHelper.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/5/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import Foundation

struct DateHelper {
    
    static let sharedInstance = DateHelper()
    
    func getLastSevenDays() -> [NSDate]? {
        var days = [NSDate]()
        let calender = NSCalendar.currentCalendar()
        for i in 1...7 {
            guard let day = calender.dateByAddingUnit(.Day, value: -i, toDate: NSDate(), options: NSCalendarOptions()) else {
                return nil
            }
            days.append(day)
        }
        return days 
    }
    
    static func monthFromDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.stringFromDate(date)
    }
    
    static func dayOfWeekFromDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.stringFromDate(date)
    }
    
    static func randomDateFrom(year year: Int) -> NSDate {
        let userCalender = NSCalendar.currentCalendar()
        let c = NSDateComponents()
        c.year = year
        c.month = Int(arc4random_uniform(6)) + 1
        c.day = Int(arc4random_uniform(28)) + 1
        return userCalender.dateFromComponents(c)!
    }
    
    static func weekAgo() -> NSDate? {
        return NSCalendar.currentCalendar().dateByAddingUnit(.WeekOfYear, value: -1, toDate: NSDate(), options: NSCalendarOptions())
    }
    
    static func twoWeeksAgo() -> NSDate? {
        return NSCalendar.currentCalendar().dateByAddingUnit(.WeekOfYear, value: -2, toDate: NSDate(), options: NSCalendarOptions())
    }
    
    static func threeWeeksAgo() -> NSDate? {
        return NSCalendar.currentCalendar().dateByAddingUnit(.WeekOfYear, value: -3, toDate: NSDate(), options: NSCalendarOptions())
    }
    
    static func fourWeeksAgo() -> NSDate? {
        return NSCalendar.currentCalendar().dateByAddingUnit(.WeekOfYear, value: -4, toDate: NSDate(), options: NSCalendarOptions())
    }
    
    static func monthAgo() -> NSDate? {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -1, toDate: NSDate(), options: NSCalendarOptions())
    }
    
    static func threeMonthsAgo() -> NSDate? {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -3, toDate: NSDate(), options: NSCalendarOptions())
    }
    
}
