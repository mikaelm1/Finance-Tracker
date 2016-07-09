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
    
    func loadAllTransactions() -> (expenses: Results<Transaction>, incomes: Results<Transaction>) {
        let expenses = realm.objects(Transaction)
        let incomes = realm.objects(Transaction)
        return (expenses, incomes)
    }
    
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
    
    func loadTransactionsMonthsAgo(months: Int) -> (expenses: Results<Transaction>, incomes: Results<Transaction>)  {
        guard let monthsAgo = DateHelper.dateFromMonthsAgo(-months), let toMonthsAgo = DateHelper.dateFromMonthsAgo(-months + 1) else {
            return loadAllTransactions()
        }
        print("Months Ago: \(monthsAgo)")
        print("ToMonthsAgo: \(toMonthsAgo)")
        let expensePredicate = NSPredicate(format: "created Between {%@, %@} AND type = %@", monthsAgo, toMonthsAgo, Constants.typeExpense)
        let expenseTransactions = realm.objects(Transaction).filter(expensePredicate)
        let incomePredicate = NSPredicate(format: "created Between {%@, %@} AND type = %@", monthsAgo, toMonthsAgo, Constants.typeIncome)
        let incomeTransactions = realm.objects(Transaction).filter(incomePredicate)
        
        return (expenseTransactions, incomeTransactions)
    }
    
    func loadTransactionsOneWeekAgo() -> (expenses: Results<Transaction>, incomes: Results<Transaction>) {
        let weekAgo = DateHelper.weeksAgo(1)!
        let expensePredicate = NSPredicate(format: "created BETWEEN {%@, %@} AND type = %@", weekAgo, NSDate(), Constants.typeExpense)
        let expenseTransactions = realm.objects(Transaction).filter(expensePredicate)
        let incomePredicate = NSPredicate(format: "created BETWEEN {%@, %@} AND type = %@", weekAgo, NSDate(), Constants.typeIncome)
        let incomeTransactions = realm.objects(Transaction).filter(incomePredicate)

        return (expenseTransactions, incomeTransactions)
    }
    
    /// Get transactions for today
    func loadTransactionsOneDayAgo() -> (expenses: Results<Transaction>, incomes: Results<Transaction>) {
        guard let oneDayAgo = DateHelper.dateFromDaysAgo(1) else {
            print("Didn't get the date")
            let incomes = realm.objects(Transaction)
            let expenses = realm.objects(Transaction)
            return (expenses, incomes)
        }
        print("OneDayAgo: \(oneDayAgo)")
        let expensePredicate = NSPredicate(format: "created Between {%@, %@} AND type = %@", oneDayAgo, NSDate(), Constants.typeExpense)
        let expenseTransactions = realm.objects(Transaction).filter(expensePredicate)
        let incomePredicate = NSPredicate(format: "created Between {%@, %@} AND type = %@", oneDayAgo, NSDate(), Constants.typeIncome)
        let incomeTransactions = realm.objects(Transaction).filter(incomePredicate)
        
        return (expenseTransactions, incomeTransactions)
    }
    
    /// Get transactions for specific date: 1<=days<=7
    func loadTransactionsDaysAgo(days: Int) -> (expenses: Results<Transaction>, incomes: Results<Transaction>) {
        guard let daysAgo = DateHelper.dateFromDaysAgo(days), let toDaysAgo = DateHelper.dateFromDaysAgo(days - 1) else {
            print("Didn't get the days")
            return loadTransactionsOneDayAgo()
        }
        print("DaysAgo: \(daysAgo)")
        print("ToDaysAgo: \(toDaysAgo)")
        let expensePredicate = NSPredicate(format: "created Between {%@, %@} AND type = %@", daysAgo, toDaysAgo, Constants.typeExpense)
        let expenseTransactions = realm.objects(Transaction).filter(expensePredicate)
        let incomePredicate = NSPredicate(format: "created Between {%@, %@} AND type = %@", daysAgo, toDaysAgo, Constants.typeIncome)
        let incomeTransactions = realm.objects(Transaction).filter(incomePredicate)
        
        return (expenseTransactions, incomeTransactions)
    }
    
    func loadTransactionsTwoWeeksAgo() -> (expenses: Results<Transaction>, incomes: Results<Transaction>) {
        
        let twoWeeksAgo = DateHelper.weeksAgo(2)!
        let expensePredicate = NSPredicate(format: "created BETWEEN {%@, %@} AND type = %@", twoWeeksAgo, NSDate(), Constants.typeExpense)
        let expenseTransactions = realm.objects(Transaction).filter(expensePredicate)
        let incomePredicate = NSPredicate(format: "created BETWEEN {%@, %@} AND type = %@", twoWeeksAgo, NSDate(), Constants.typeIncome)
        let incomeTransactions = realm.objects(Transaction).filter(incomePredicate)

        return (expenseTransactions, incomeTransactions)
    }
    
    func loadTransactionsThreeWeeksAgo() -> (expenses: Results<Transaction>, incomes: Results<Transaction>) {
        let threeWeeksAgo = DateHelper.weeksAgo(3)!
        let expensePredicate = NSPredicate(format: "created BETWEEN {%@, %@} AND type = %@", threeWeeksAgo, NSDate(), Constants.typeExpense)
        let expenseTransactions = realm.objects(Transaction).filter(expensePredicate)
        let incomePredicate = NSPredicate(format: "created BETWEEN {%@, %@} AND type = %@", threeWeeksAgo, NSDate(), Constants.typeIncome)
        let incomeTransactions = realm.objects(Transaction).filter(incomePredicate)
        return (expenseTransactions, incomeTransactions)
    }
    
    func loadTransactionsFourWeeksAgo() -> (expenses: Results<Transaction>, incomes: Results<Transaction>) {
        let fourWeeksAgo = DateHelper.weeksAgo(4)!
        let expensePredicate = NSPredicate(format: "created BETWEEN {%@, %@} AND type = %@", fourWeeksAgo, NSDate(), Constants.typeExpense)
        let expenseTransactions = realm.objects(Transaction).filter(expensePredicate)
        let incomePredicate = NSPredicate(format: "created BETWEEN {%@, %@} AND type = %@", fourWeeksAgo, NSDate(), Constants.typeIncome)
        let incomeTransactions = realm.objects(Transaction).filter(incomePredicate)
        return (expenseTransactions, incomeTransactions)
    }
    
}
