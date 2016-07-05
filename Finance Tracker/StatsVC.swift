//
//  StatsVC.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/3/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit
import RealmSwift 

class StatsVC: UIViewController {
    
    var transactions: Results<Transaction>!
    
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
    
    // MARK: Helpers
    
    func setupViews() {
        view.addSubview(tableView)
        view.addSubview(seperatorView)
        
        let tableHeight = view.frame.height * 0.4
        
        view.addConstraintsWithFormat("H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat("H:|[v0]|", views: seperatorView)
        view.addConstraintsWithFormat("V:[v0(1)]-1-[v1(\(tableHeight))]-50-|", views: seperatorView, tableView)
    }
    
    func loadTransactions() {
        let realm = try! Realm()
        transactions = realm.objects(Transaction)
        tableView.reloadData()
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
