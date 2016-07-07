//
//  StatsVC.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/3/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class StatsVC: UIViewController {
    
    var transactions: Results<DummyTransaction>!
    let realm = try! Realm()
    let realmHelper = RealmHelper.sharedInstance
    
    lazy var lineChartView: LineChartView = {
        let l = LineChartView()
        l.delegate = self
        l.noDataText = "No data to display"
        l.descriptionText = ""
        l.legend.form = .Line
        l.xAxis.labelPosition = .Bottom
        l.xAxis.drawGridLinesEnabled = true
        l.pinchZoomEnabled = true
        l.leftAxis.drawGridLinesEnabled = false
        l.rightAxis.enabled = false
        return l
    }()
    
    let barChartView: BarChartView = {
        let b = BarChartView()
        b.noDataText = "No data to display"
        return b
    }()
    
    lazy var tableView: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.delegate = self
        t.dataSource = self
        t.registerClass(StatsCell.self, forCellReuseIdentifier: Constants.statsReuseId)
        //t.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        t.estimatedRowHeight = 50
        t.separatorStyle = .None
        t.backgroundColor = UIColor.whiteColor()
        return t
    }()
    
    let seperatorView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.darkGrayColor()
        return v
    }()
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Stats ViewDidLoad")
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.whiteColor()
        setupViews()
        
        //TODO: Temporary. Remove!
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(deletaAllTransactions(_:)))
    }
    
    // TODO: Temp func
    func deletaAllTransactions(sender: UIBarButtonItem) {
//        try! realm.write({ 
//            realm.deleteAll()
//            tableView.reloadData()
//        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("Stats viewWillAppear")
        //loadTransactions()
        //loadTransactionsWithinMonth()
        //loadAllTransactions()
        showTransactionsWithinMonth()
        transactions = realm.objects(DummyTransaction)
    }
    
    // MARK: Chart setup
    
    func setData() {
        let income1 = ChartDataEntry(value: 200, xIndex: 0)
        let income2 = ChartDataEntry(value: 300, xIndex: 1)
        let income3 = ChartDataEntry(value: 100, xIndex: 2)
        let dataSet = LineChartDataSet(yVals: [income1, income2, income3], label: "Incomes")
        dataSet.colors = [UIColor.greenColor()]
        dataSet.circleColors = [UIColor.redColor()]
        
        let incomes = LineChartData(xVals: ["Mon", "Wed", "Thu"], dataSets: [dataSet])

        lineChartView.animate(xAxisDuration: 1, yAxisDuration: 2, easingOption: .EaseInBounce)
        lineChartView.xAxis.labelPosition = .Bottom
        lineChartView.xAxis.axisMinValue = 0
        lineChartView.pinchZoomEnabled = true
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.data = incomes
    }
    
    func setChart(dataPoints: [String], incomeValues: [Double], expenseValues: [Double]) {
        
        var incomeEntries = [ChartDataEntry]()
        var expenseEntries = [ChartDataEntry]()
        
        for i in 0..<incomeValues.count {
            let entry = ChartDataEntry(value: incomeValues[i], xIndex: i)
            incomeEntries.append(entry)
        }
        for i in 0..<expenseValues.count {
            let entry = ChartDataEntry(value: expenseValues[i], xIndex: i)
            expenseEntries.append(entry)
        }
        
        let incomeSet = LineChartDataSet(yVals: incomeEntries, label: "Income")
        incomeSet.colors = [Constants.incomeColor]
        let expenseSet = LineChartDataSet(yVals: expenseEntries, label: "Expense")
        expenseSet.colors = [Constants.expenseColor]
        
        
        let data = LineChartData(xVals: dataPoints, dataSets: [incomeSet, expenseSet])
        
        lineChartView.data = data
    }
    
    // MARK: Helpers
    
    func setupViews() {
        view.addSubview(tableView)
        view.addSubview(seperatorView)
        view.addSubview(lineChartView)
        
        //let tableHeight = view.frame.height * 0.4
        let chartHeight = view.frame.height * 0.6
        
        view.addConstraintsWithFormat("H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat("H:|[v0]|", views: seperatorView)
        view.addConstraintsWithFormat("H:|[v0]|", views: lineChartView)
        view.addConstraintsWithFormat("V:|-70-[v0(\(chartHeight))]-1-[v1(1)]-1-[v2]-50-|", views: lineChartView, seperatorView, tableView)
    }
    
    // MARK: Realm loaders
    
    func showTransactionsWithinMonth() {
        let (incomes, expenses) = realmHelper.loadTransactionsOneMonthAgo()
        print(incomes)
        print(expenses)
    }
    
    func loadAllTransactions() {
        
        transactions = realm.objects(DummyTransaction)
        
        let expensePredicate = NSPredicate(format: "type = %@", Constants.typeExpense)
        let predicate2 = NSPredicate(format: "type = %@", Constants.typeIncome)
        let expenseTransactions = realm.objects(DummyTransaction).filter(expensePredicate)
        let incomeTransactions = realm.objects(DummyTransaction).filter(predicate2)
        //print("Income Transactions: \(incomeTransactions)\n\n")
        //print("Expense Transactions: \(expenseTransactions)")
    }
    
    func loadTransactions() {
        let weekAgo = DateHelper.weekAgo()!
        let monthAgo = DateHelper.monthAgo()!
        let today = NSDate()
        print("Week ago: \(weekAgo)")
        print("Today: \(today)")
        let predicate = NSPredicate(format: "created BETWEEN {%@, %@}", monthAgo, today)
        transactions = realm.objects(DummyTransaction).filter(predicate)
        print("Transactions: \(transactions)")
        tableView.reloadData()
        var data = [String]()
        var incomes = [Double]()
        var expenses = [Double]()
        for item in transactions {
            if item.type == Constants.typeIncome {
                incomes.append(item.price)
            } else {
                expenses.append(item.price)
            }
            //let month = DateHelper.monthFromDate(item.created)
            let day = DateHelper.dayOfWeekFromDate(item.created)
            if !data.contains(day) {
                data.append(day)
            }
        }
        setChart(data, incomeValues: incomes, expenseValues: expenses)
    }
    
}

extension StatsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let transaction = transactions[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.statsReuseId, forIndexPath: indexPath) as! StatsCell
        cell.backgroundColor = UIColor.redColor()
        //cell.configureCell(indexPath.row, transaction: transaction)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
}

extension StatsVC: ChartViewDelegate {
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print(entry)
        print(dataSetIndex)
        print(highlight)
    }
    
}
