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
    
    var transactions: Results<Transaction>!
    
    let lineChartView: LineChartView = {
        let l = LineChartView()
        l.noDataText = "No data to display"
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("Stats viewWillAppear")
        loadTransactions()
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
    
    func monthFromDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.stringFromDate(date)
    }
    
    func loadTransactions() {
        let realm = try! Realm()
        transactions = realm.objects(Transaction)
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
            let month = monthFromDate(item.created)
            if !data.contains(month) {
                data.append(month)
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
        cell.configureCell(indexPath.row, transaction: transaction)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
}
