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
        s.tintColor = Constants.incomeColor
        s.addTarget(self, action: #selector(transactionTypeChanged), forControlEvents: .ValueChanged)
        s.selectedSegmentIndex = 0
        return s
    }()
    
    lazy var itemPriceField: UITextField = {
        let t = UITextField()
        t.delegate = self
        t.tag = Constants.priceFieldTag
        t.translatesAutoresizingMaskIntoConstraints = false
        t.keyboardType = .DecimalPad
        t.borderStyle = .None
        t.placeholder = "Enter Amount"
        t.textColor = UIColor.blackColor()
        return t
    }()
    
    lazy var itemNameField: UITextField = {
        let t = UITextField()
        t.delegate = self
        t.tag = Constants.nameFieldTag
        t.translatesAutoresizingMaskIntoConstraints = false
        t.borderStyle = .None
        t.placeholder = "Enter Name"
        t.textColor = UIColor.blackColor()
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
        
        view.backgroundColor = UIColor.whiteColor()
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(transactionTypeSegment)
        view.addSubview(itemPriceField)
        view.addSubview(itemNameField)
        view.addSubview(seperatorView)
        
        view.addConstraintsWithFormat("V:|-80-[v0(35)]-40-[v1(40)]-1-[v2(1)]-10-[v3(40)]", views: transactionTypeSegment, itemNameField, seperatorView, itemPriceField)
        
        view.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: itemNameField)
        view.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: seperatorView)
        view.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: itemPriceField)
        transactionTypeSegment.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 30).active = true
        transactionTypeSegment.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -30).active = true
        
    }
    
    func transactionTypeChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sender.tintColor = Constants.incomeColor
        case 1:
            sender.tintColor = Constants.expenseColor
        default:
            break
        }
    }

}

extension AddItemVC: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        if textField.tag == Constants.priceFieldTag {
            if Int(string) != nil {
                return true
            }
            return false
        }
        return true 
    }
    
}






