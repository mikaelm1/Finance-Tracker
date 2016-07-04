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
    
    lazy var tableView: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.delegate = self
        t.dataSource = self
        t.registerClass(StatsCell.self, forCellReuseIdentifier: Constants.statsReuseId)
        //t.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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

    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.whiteColor()
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(tableView)
        view.addSubview(seperatorView)
        
        let tableHeight = view.frame.height * 0.4
        
        view.addConstraintsWithFormat("H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat("H:|[v0]|", views: seperatorView)
        view.addConstraintsWithFormat("V:[v0(1)]-1-[v1(\(tableHeight))]|", views: seperatorView, tableView)
    }
    
}

extension StatsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.statsReuseId, forIndexPath: indexPath) as! StatsCell
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.whiteColor()
        } else {
            cell.backgroundColor = UIColor.lightGrayColor()
        }
        return cell
    }
    
}
