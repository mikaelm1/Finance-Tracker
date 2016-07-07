//
//  AddItemVC.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/3/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit
import RealmSwift

class AddItemVC: UIViewController {
    
    // MARK: Properties
    
    var transactionType = Constants.typeIncome
    
    let realm = try! Realm()
    
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
    
    lazy var addItemButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.cornerRadius = 2
        b.backgroundColor = Constants.incomeColor
        b.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        b.setTitle("Add", forState: .Normal)
        b.addTarget(self, action: #selector(addItemButtonTapped), forControlEvents: .TouchUpInside)
        return b
    }()
    
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Realm: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        view.backgroundColor = UIColor.whiteColor()
        setupViews()
        
        // TODO: Temp. Remove.
        //createDummyData()
    }
    
    func createDummyData() {
        let expenses = Array(count: 20, repeatedValue: "Expense")
        let incomes = Array(count: 20, repeatedValue: "Income")
        var expenseDates = [NSDate]()
        var incomeDates = [NSDate]()
        for _ in 0..<expenses.count {
            let d = DateHelper.randomDateFrom(year: 2016)
            expenseDates.append(d)
            print("D: \(d)")
            let d2 = DateHelper.randomDateFrom(year: 2016)
            incomeDates.append(d2)
            print("D2: \(d2)")
        }
        
        //var dummyTransactions = [DummyTransaction]()
        for i in 0..<incomes.count {
            let expensedt = DummyTransaction(name: "Expense", price: Double(i * 20 + 10), type: Constants.typeExpense, date: expenseDates[i])
            let incomedt = DummyTransaction(name: "Income", price: Double(i * 10 + 30), type: Constants.typeIncome, date: incomeDates[i])
            try! realm.write({
                realm.add(expensedt)
                realm.add(incomedt)
            })
        }
        
    }
    
    // MARK: Views
    
    func setupViews() {
        view.addSubview(transactionTypeSegment)
        view.addSubview(itemPriceField)
        view.addSubview(itemNameField)
        itemNameField.becomeFirstResponder()
        view.addSubview(seperatorView)
        view.addSubview(addItemButton)
        
        view.addConstraintsWithFormat("V:|-80-[v0(35)]-40-[v1(40)]-1-[v2(1)]-10-[v3(40)]-10-[v4(30)]", views: transactionTypeSegment, itemNameField, seperatorView, itemPriceField, addItemButton)
        
        view.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: itemNameField)
        view.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: seperatorView)
        view.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: itemPriceField)
        view.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: addItemButton)
        transactionTypeSegment.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 30).active = true
        transactionTypeSegment.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: -30).active = true
        
    }
    
    func transactionTypeChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sender.tintColor = Constants.incomeColor
            addItemButton.backgroundColor = Constants.incomeColor
            transactionType = Constants.typeIncome
        case 1:
            sender.tintColor = Constants.expenseColor
            addItemButton.backgroundColor = Constants.expenseColor
            transactionType = Constants.typeExpense
        default:
            break
        }
    }
    
    // MARK: Helpers
    
    func clearFields() {
        itemNameField.text = ""
        itemPriceField.text = ""
        itemNameField.becomeFirstResponder()
    }
    
    func getItemName() -> String? {
        if let name = itemNameField.text where name != "" {
            return name
        }
        return nil
    }
    
    func getItemPrice() -> Double? {
        guard let priceString = itemPriceField.text else {
            return nil
        }
        if let price = Double(priceString) {
            return price
        }
        return nil
    }
    
    // MARK: Actions
    
    func addItemButtonTapped(sender: UIButton) {
        let realm = try! Realm()
        if let name = getItemName(), let price = getItemPrice() {
            let item = Transaction(name: name, price: price, type: transactionType, date: nil)
            try! realm.write({
                realm.add(item)
            })
            // TODO: Change the button colors
            SweetAlert().showAlert("Transaction Added!", subTitle: "Would you like to add another transaction?", style: AlertStyle.Success, buttonTitle: "Yes", buttonColor: UIColor.blueColor(), otherButtonTitle: "No", otherButtonColor: UIColor.redColor(), action: { (isOtherButton) in
                if isOtherButton {
                    // Yes tapped
                    self.clearFields()
                } else {
                    // No tapped 
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tabBarController?.selectedIndex = 0
                    })
                }
            })
        } else {
            SweetAlert().showAlert("Incomplete", subTitle: "Please enter a name and price for the transaction.", style: AlertStyle.Error)
        }
    }

}

extension AddItemVC: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        if textField.tag == Constants.priceFieldTag {
            if Int(string) != nil || string == "" {
                return true
            }
            return false
        }
        return true
    }
    
}






