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
    
    func loadTransactionsOneMonthAgo() -> (expenses: Results<Transaction>, incomes: Results<Transaction>) {
        let monthAgo = DateHelper.monthAgo()!
        let today = NSDate()
        let expensePredicate = NSPredicate(format: "created BETWEEN {%@, %@} AND type = %@", monthAgo, today, Constants.typeExpense)
        let predicate2 = NSPredicate(format: "created BETWEEN {%@, %@} AND type = %@", monthAgo, today, Constants.typeIncome)
        let expenseTransactions = realm.objects(Transaction).filter(expensePredicate)
        let incomeTransactions = realm.objects(Transaction).filter(predicate2)
        //print("Income Transactions: \(incomeTransactions)")
        //print("Expense Transactions: \(expenseTransactions)")
        //print("Transactions: \(transactions)")
        return (expenseTransactions, incomeTransactions)
        
    }
    
    func loadTransactionsOneWeekAgo() {
        let weekAgo = DateHelper.weekAgo()!
        let expensePredicate = NSPredicate(format: "created BETWEEN {%@, %@} AND type = %@", weekAgo, NSDate(), Constants.typeExpense)
        let expenseTransactions = realm.objects(Transaction).filter(expensePredicate)
        let incomePredicate = NSPredicate(format: "created BETWEEN {%@, %@} AND type = %@", weekAgo, NSDate(), Constants.typeIncome)
        let incomeTransactions = realm.objects(Transaction).filter(incomePredicate)
        
        var total: Double = 0
        for expense in expenseTransactions {
            total -= expense.price
        }
        for income in incomeTransactions {
            total += income.price
        }
        print("Total Balance: \(total)")
    }
    
    func loadTransactionsTwoWeeksAgo() {
        
    }
    
}