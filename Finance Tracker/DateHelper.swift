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
    
}
