//
//  DateHelper.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/5/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import Foundation

struct DateHelper {
    
    //static let sharedInstance = DateHelper()
    
    static func getLastSixMonths() -> [String]? {
        var days = [NSDate]()
        let calendar = NSCalendar.currentCalendar()
        for i in 0...5 {
            guard let day = calendar.dateByAddingUnit(.Month, value: -i, toDate: NSDate(), options: NSCalendarOptions()) else {
                return nil
            }
            days.append(day)
        }
        var stringDays = [String]()
        for day in days {
            let stringDay = getStringDayFromDate(day)
            stringDays.append(stringDay)
        }
        return stringDays
    }
    
    static func getLastSevenDays() -> [String]? {
        var days = [NSDate]()
        let calender = NSCalendar.currentCalendar()
        for i in 0...6 {
            guard let day = calender.dateByAddingUnit(.Day, value: -i, toDate: NSDate(), options: NSCalendarOptions()) else {
                return nil
            }
            days.append(day)
        }
        var stringDays = [String]()
        for day in days {
            let stringDay = dayOfWeekFromDate(day)
            stringDays.append(stringDay)
        }
        return stringDays
    }
    
    static func getStringDayFromDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.stringFromDate(date)
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
    
    static func dateFromDaysAgo(days: Int) -> NSDate? {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -days, toDate: NSDate(), options: NSCalendarOptions())
    }
    
    /// Inputting a paramter of "1" returns the date for one week ago
    static func weeksAgo(weeks: Int) -> NSDate? {
        return NSCalendar.currentCalendar().dateByAddingUnit(.WeekOfYear, value: -weeks, toDate: NSDate(), options: NSCalendarOptions())
    }
    
    static func monthAgo() -> NSDate? {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -1, toDate: NSDate(), options: NSCalendarOptions())
    }
    
    static func dateFromMonthsAgo(month: Int) -> NSDate? {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: month, toDate: NSDate(), options: NSCalendarOptions())
    }
    
    static func threeMonthsAgo() -> NSDate? {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -3, toDate: NSDate(), options: NSCalendarOptions())
    }
    
}
