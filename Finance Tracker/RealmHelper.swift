//
//  RealmHelper.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/7/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmHelper {
    
    static let sharedInstance = RealmHelper()
    private let realm = try! Realm()
    
    func loadAllTransactions() -> Results<Transaction> {
        return realm.objects(Transaction)
    }
    
    func loadTransactionsOneMonthAgo() -> Results<Transaction> {
        let monthAgo = DateHelper.monthAgo()!
        let today = NSDate()
        let predicate = NSPredicate(format: "created BETWEEN {%@, %@}", monthAgo, today)
        let transactions = realm.objects(Transaction).filter(predicate)
        //print("Income Transactions: \(incomeTransactions)")
        //print("Expense Transactions: \(expenseTransactions)")
        //print("Transactions: \(transactions)")
        return transactions
        
    }
    
    func loadTransactionsMonthsAgo(months: Int) -> Results<Transaction> {
        guard let monthsAgo = DateHelper.dateFromMonthsAgo(months), let toMonthsAgo = DateHelper.dateFromMonthsAgo(months + 1) else {
            return loadAllTransactions()
        }
        print("Months Ago: \(monthsAgo)")
        print("ToMonthsAgo: \(toMonthsAgo)")
        let predicate = NSPredicate(format: "created Between {%@, %@}", toMonthsAgo, monthsAgo)
        let transactions = realm.objects(Transaction).filter(predicate)
        return transactions
    }
    
    func loadTransactionsOneWeekAgo() -> Results<Transaction> {
        let weekAgo = DateHelper.weeksAgo(1)!
        let predicate = NSPredicate(format: "created BETWEEN {%@, %@}", weekAgo, NSDate())
        let transactions = realm.objects(Transaction).filter(predicate)
        return transactions
    }
    
    /// Get transactions for specific date: 0<=days<=6
    func loadTransactionsDaysAgo(days: Int) -> Results<Transaction> {
        guard var daysAgo = DateHelper.dateFromDaysAgo(days), let toDaysAgo = DateHelper.dateFromDaysAgo(days + 1) else {
            print("Didn't get the days")
            return realm.objects(Transaction)
        }
        print("DaysAgo: \(daysAgo)")
        print("ToDaysAgo: \(toDaysAgo)")
        if days == 0 {
            daysAgo = NSDate()
        }
        let predicate = NSPredicate(format: "created Between {%@, %@}", toDaysAgo, daysAgo)
        let transactions = realm.objects(Transaction).filter(predicate)
        return transactions
    }
    
    func loadTransactionsWeeksAgo(weeks: Int) -> Results<Transaction> {
        guard let weeksAgo = DateHelper.weeksAgo(weeks), let toWeeksAgo = DateHelper.weeksAgo(weeks + 1) else {
            print("Didn't get the dates")
            return realm.objects(Transaction)
        }
        print("Weeks Ago: \(weeksAgo)")
        print("To WeeksAgo: \(toWeeksAgo)")
        let predicate = NSPredicate(format: "created BETWEEN {%@, %@}", toWeeksAgo, weeksAgo)
        let transactions = realm.objects(Transaction).filter(predicate)
        return transactions
    }
    
}
