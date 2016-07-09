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
    let realm = try! Realm()
    let realmHelper = RealmHelper.sharedInstance
    
    lazy var lineChartView: LineChartView = {
        let l = LineChartView()
        l.delegate = self
        l.noDataText = "No data to display"
        l.descriptionText = ""
        l.backgroundColor = UIColor.rgb(222, green: 237, blue: 200, alpha: 1)
        l.legend.form = .Line
        l.xAxis.labelPosition = .Bottom
        l.xAxis.drawGridLinesEnabled = true
        l.pinchZoomEnabled = true
        l.leftAxis.drawGridLinesEnabled = false
        l.rightAxis.enabled = true
        return l
    }()
    
    let barChartView: BarChartView = {
        let b = BarChartView()
        b.noDataText = "No data to display"
        return b
    }()
    
    let choicesContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.clearColor()
        return v
    }()
    
    let oneWeekButton: TimeRangeButton = {
        let b = TimeRangeButton()
        b.setTitle("1W", forState: .Normal)
        b.selected = true 
        return b
    }()
    
    let oneMonthButton: TimeRangeButton = {
        let b = TimeRangeButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("1M", forState: .Normal)
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
        print("Stats viewWillAppear")
        //loadTransactions()
        //loadTransactionsWithinMonth()
        //loadAllTransactions()
        showTransactionsForOneMonth()
        //showTransactionsOneWeekAgo()
        transactions = realm.objects(Transaction)
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
        //view.addSubview(tableView)
        //view.addSubview(seperatorView)
        view.addSubview(lineChartView)
        //view.addSubview(choicesContainer)
        //choicesContainer.addSubview(oneWeekButton)
        //choicesContainer.addSubview(oneMonthButton)
        view.addSubview(timeRangeView)
        
        
        //let tableHeight = view.frame.height * 0.4
        //let chartHeight = view.frame.height - 120
        //let buttonWidth = view.frame.width / 4 - 10
        
        //view.addConstraintsWithFormat("H:|[v0]|", views: tableView)
        //view.addConstraintsWithFormat("H:|[v0]|", views: seperatorView)
        
        view.addConstraintsWithFormat("H:|[v0]|", views: lineChartView)
        view.addConstraintsWithFormat("H:|[v0]|", views: timeRangeView)
        
        //choicesContainer.addConstraintsWithFormat("H:|-5-[v0(\(buttonWidth))]-5-[v1(\(buttonWidth))]", views: oneWeekButton, oneMonthButton)
        //view.addConstraintsWithFormat("V:|-60-[v0(\(chartHeight))]-0-[v1(1)]-1-[v2]-50-|", views: lineChartView, seperatorView, tableView)
        //choicesContainer.addConstraintsWithFormat("V:|[v0]|", views: oneWeekButton)
        //choicesContainer.addConstraintsWithFormat("V:|[v0]|", views: oneMonthButton)
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
        let (oneExpenses, oneIncomes) = realmHelper.loadTransactionsOneWeekAgo()
        var oneTotal: Double = 0
        for expense in oneExpenses {
            oneTotal -= expense.price
        }
        for income in oneIncomes {
            oneTotal += income.price
        }
        print("One Total: \(oneTotal)")
        
        let (twoExpenses, twoIncomes) = realmHelper.loadTransactionsTwoWeeksAgo()
        //print("Two expenses: \(twoExpenses)")
        //print("Two Incomes: \(twoIncomes)")
        var twoTotal: Double = 0
        for expense in twoExpenses {
            twoTotal -= expense.price
        }
        for income in twoIncomes {
            twoTotal += income.price
        }
        print("Two Total: \(twoTotal)")
        
        let (threeExpenses, threeIncomes) = realmHelper.loadTransactionsThreeWeeksAgo()
        //print("Three expenses: \(threeExpenses.count)")
        //print("Three incomes: \(threeIncomes.count)")
        var threeTotal: Double = 0
        for expense in threeExpenses {
            threeTotal -= expense.price
        }
        for income in threeIncomes {
            threeTotal += income.price
        }
        print("Three Total: \(threeTotal)")
        
        let (fourExpenses, fourIncomes) = realmHelper.loadTransactionsFourWeeksAgo()
        print("Four expenses: \(fourExpenses.count)")
        print("Four incomes: \(fourIncomes.count)")
        var fourTotal: Double = 0
        for expense in fourExpenses {
            fourTotal -= expense.price
        }
        for income in fourIncomes {
            fourTotal += income.price
        }
        print("Four Total: \(fourTotal)")
        
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
        
        let values = [oneTotal, twoTotal, threeTotal, fourTotal]
        setChart(dataPoints.reverse(), values: values.reverse())
        
    }
    
    func showTransactionsForOneWeek() {
        guard let days = DateHelper.getLastSevenDays() else {
            print("Didn't get the days from date helper")
            return
        }
        
        var values = [Double]()
        print(days.count)
        
        for i in (1...7).reverse() {
            var tempTotal: Double = 0
            let (exp, inc) = realmHelper.loadTransactionsDaysAgo(i)
            for expense in exp {
                tempTotal -= expense.price
            }
            for income in inc {
                tempTotal += income.price
            }
            values.append(tempTotal)
        }
        
        let (expenses, incomes) = realmHelper.loadTransactionsOneDayAgo()
        var oneTotal: Double = 0
        for expense in expenses {
            oneTotal -= expense.price
        }
        for income in incomes {
            oneTotal += income.price
        }
        values.append(oneTotal)
        
        setChart(days.reverse(), values: values)
    }
    
    func showTransactionsForSixMonths() {
        
        var values = [Double]()
        for i in 1...6 {
            var tempTotal: Double = 0
            let (expenses, incomes) = realmHelper.loadTransactionsMonthsAgo(i)
            for exp in expenses {
                tempTotal -= exp.price
            }
            for inc in incomes {
                tempTotal += inc.price
            }
            values.append(tempTotal)
        }
        
        var dataPoints = ["","","","","",""]
        setChart(dataPoints, values: values.reverse())
    }
    
    func showTransactionsForOneYear() {
        
    }
    
    func loadAllTransactions() {
        transactions = realm.objects(Transaction)
    }
    
    func loadTransactions() {
        let weekAgo = DateHelper.weeksAgo(1)!
        let monthAgo = DateHelper.monthAgo()!
        let today = NSDate()
        print("Week ago: \(weekAgo)")
        print("Today: \(today)")
        let predicate = NSPredicate(format: "created BETWEEN {%@, %@}", monthAgo, today)
        transactions = realm.objects(Transaction).filter(predicate)
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
