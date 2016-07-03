//
//  AddItemVC.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/3/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController {
    
    lazy var transactionTypeSegment: UISegmentedControl = {
        let items = ["Income", "Expense"]
        let s = UISegmentedControl(items: items)
        s.translatesAutoresizingMaskIntoConstraints = false
        s.tintColor = UIColor.greenColor()
        s.addTarget(self, action: #selector(transactionTypeChanged), forControlEvents: .ValueChanged)
        s.selectedSegmentIndex = 0
        return s
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(transactionTypeSegment)
        
        view.addConstraintsWithFormat("V:|-80-[v0(35)]", views: transactionTypeSegment)
        transactionTypeSegment.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 30).active = true
        transactionTypeSegment.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -30).active = true
        
    }
    
    func transactionTypeChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sender.tintColor = UIColor.greenColor()
        case 1:
            sender.tintColor = UIColor.redColor()
        default:
            break
        }
    }

}


