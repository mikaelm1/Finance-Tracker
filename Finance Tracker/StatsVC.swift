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
    
    var transactionsSelected = [Results<Transaction>!]()
    let realm = try! Realm()
    let realmHelper = RealmHelper.sharedInstance
    
    let transactionsController: TransactionsVC = {
        let t = TransactionsVC()
        return t
    }()
    
    lazy var lineChartView: LineChartView = {
        let l = LineChartView()
        l.delegate = self
        l.noDataText = "No data to display"
        l.descriptionText = "Tap node for more info"
        l.backgroundColor = UIColor.rgb(222, green: 237, blue: 200, alpha: 1)
        l.legend.form = .Line
        l.xAxis.labelPosition = .Bottom
        l.xAxis.drawGridLinesEnabled = false
        l.pinchZoomEnabled = true
        l.leftAxis.drawGridLinesEnabled = false
        l.rightAxis.enabled = true
        l.rightAxis.drawGridLinesEnabled = false
        return l
    }()
    
    let choicesContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.clearColor()
        return v
    }()
    
    lazy var timeRangeView: TimeRangeContainer = {
        let tr = TimeRangeContainer()
        tr.statsViewController = self
        return tr
    }()
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Stats ViewDidLoad")
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.rgb(222, green: 237, blue: 200, alpha: 1)
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

        showTransactionsForOneWeek()
        timeRangeView.moveSlidingBar(0)
    }
    
    // MARK: Chart setup
    
    /// Single line chart
    func setChart(dataPoints: [String], values: [Double]) {
        var entries = [ChartDataEntry]()
        for i in 0..<dataPoints.count {
            let entry = ChartDataEntry(value: values[i], xIndex: i)
            entries.append(entry)
        }
        
        let dataSet = LineChartDataSet(yVals: entries, label: "Transactions")
        dataSet.colors = [Constants.purpleBarColor]
        dataSet.circleRadius = 5
        dataSet.lineWidth = 3
        dataSet.drawCircleHoleEnabled = false
        dataSet.circleColors = [Constants.purpleBarColor]
        dataSet.cubicIntensity = 0.05
        
        let data = LineChartData(xVals: dataPoints, dataSets: [dataSet])
        
        lineChartView.data = data
    }
    
    /// Double line chart
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

        view.addSubview(lineChartView)
        view.addSubview(timeRangeView)
        
        view.addConstraintsWithFormat("H:|[v0]|", views: lineChartView)
        view.addConstraintsWithFormat("H:|[v0]|", views: timeRangeView)

        view.addConstraintsWithFormat("V:|-60-[v0][v1(50)]-50-|", views: lineChartView, timeRangeView)
    }
    
    // MARK: Realm loaders
    
    func showTransactionsFor(timeRange: String) {
        switch timeRange {
        case TimeRange.oneWeek.rawValue:
            showTransactionsForOneWeek()
        case TimeRange.oneMonth.rawValue:
            showTransactionsForOneMonth()
        case TimeRange.sixMonths.rawValue:
            showTransactionsForSixMonths()
        case TimeRange.oneYear.rawValue:
            showTransactionsForOneYear()
        default:
            print("Something is wrong. Shouldn't be here.")
        }
    }
    
    func showTransactionsForOneMonth() {
        var values = [Double]()
        transactionsSelected = [Results<Transaction>!]()
        for i in 0...3 {
            let transactions = realmHelper.loadTransactionsWeeksAgo(i)
            var tempTotal: Double = 0
            for t in transactions {
                if t.type == Constants.typeIncome {
                    tempTotal += t.price
                } else {
                    tempTotal -= t.price
                }
            }
            values.append(tempTotal)
            transactionsSelected.append(transactions)
        }
        
        var dates = [NSDate]()
        for i in 0...3 {
            if let d = DateHelper.weeksAgo(i) {
                dates.append(d)
            } else {
                dates.append(NSDate())
            }
        }
        
        var dataPoints = [String]()
        for d in dates {
            let str = DateHelper.getStringDayFromDate(d)
            dataPoints.append(str)
        }
        
        setChart(dataPoints.reverse(), values: values.reverse())
        
    }
    
    func showTransactionsForOneWeek() {
        
        guard let days = DateHelper.getLastSevenDays() else {
            print("Didn't get the days from date helper")
            return
        }
        var values = [Double]()
        transactionsSelected = [Results<Transaction>!]()
        for i in 0...6 {
            var tempTotal: Double = 0
            let transactions = realmHelper.loadTransactionsDaysAgo(i)
            for t in transactions {
                if t.type == Constants.typeIncome {
                   tempTotal += t.price
                } else {
                    tempTotal -= t.price
                }
            }
            values.append(tempTotal)
            transactionsSelected.append(transactions)
        }

        print("Values count: \(values.count)")
        print(days.count)
        setChart(days.reverse(), values: values.reverse())
    }
    
    func showTransactionsForSixMonths() {
        
        var values = [Double]()
        transactionsSelected = [Results<Transaction>!]()
        for i in 0...5 {
            var tempTotal: Double = 0
            let transactions = realmHelper.loadTransactionsMonthsAgo(i)
            for t in transactions {
                if t.type == Constants.typeIncome {
                    tempTotal += t.price
                } else {
                    tempTotal -= t.price
                }
            }
            values.append(tempTotal)
            transactionsSelected.append(transactions)
        }
        
        var dataPoints = ["","","","","",""]
        if let days = DateHelper.getLastSixMonths() {
            dataPoints = days.reverse()
        }
        setChart(dataPoints, values: values.reverse())
    }
    
    func showTransactionsForOneYear() {
        var values = [Double]()
        transactionsSelected = [Results<Transaction>!]()
        var dataPoints = [String]()
        for i in 0.stride(to: 11, by: 3) {
            var tempTotal: Double = 0
            let transactions = realmHelper.loadTransactionsMonthsAgo(i)
            for t in transactions {
                if t.type == Constants.typeIncome {
                    tempTotal += t.price
                } else {
                    tempTotal -= t.price
                }
            }
            values.append(tempTotal)
            transactionsSelected.append(transactions)
            
            if let stringDay = DateHelper.getStringDayFromMonthsAgo(i) {
                dataPoints.append(stringDay)
            } else {
                dataPoints.append("")
            }
        }
        dataPoints = dataPoints.reverse()
        setChart(dataPoints, values: values.reverse())
    }
    
    func loadAllTransactions() {
        //transactions = realm.objects(Transaction)
    }
    
}

extension StatsVC: ChartViewDelegate {
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        print(entry)
//        print(transactionsSelected[entry.xIndex], "\n\n")
//        print(transactionsSelected.count)
        //print(transactionsSelected)
        transactionsController.transactions = transactionsSelected[entry.xIndex]
        
        presentViewController(transactionsController, animated: true, completion: nil)
    }
    
}
