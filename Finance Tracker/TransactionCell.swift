//
//  StatsCell.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/4/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

protocol TransactionCellDelegate {
    func didDeleteTransaction(transaction: Transaction)
}

class TransactionCell: UICollectionViewCell {
    
    // MARK: Properties
    
    var delegate: TransactionCellDelegate? = nil
    var transaction: Transaction!
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Name"
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont.systemFontOfSize(14)
        l.textColor = UIColor.blackColor()
        l.minimumScaleFactor = 0.7
        return l
    }()
    
    let dateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont.systemFontOfSize(10)
        l.textColor = UIColor.darkGrayColor()
        l.minimumScaleFactor = 0.7
        return l
    }()

    let priceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont.systemFontOfSize(20, weight: 200)
        l.textColor = Constants.incomeColor
        l.textAlignment = .Right
        l.minimumScaleFactor = 0.7
        return l
    }()
    
    lazy var deleteButton: UIButton = {
        let b = UIButton(type: .System)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.cornerRadius = 17
        b.layer.masksToBounds = true
        b.setTitle("X", forState: .Normal)
        b.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        b.backgroundColor = UIColor.clearColor()
        b.addTarget(self, action: #selector(deleteTransaction), forControlEvents: .TouchUpInside)
        return b
    }()
    
    // MARK: Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Helpers
    
    func setupViews() {
        addSubview(nameLabel)
        addSubview(dateLabel)
        addSubview(priceLabel)
        addSubview(deleteButton)
        
        deleteButton.leadingAnchor.constraintEqualToAnchor(leadingAnchor, constant: 10).active = true
        deleteButton.centerYAnchor.constraintEqualToAnchor(centerYAnchor, constant: 0).active = true
        deleteButton.heightAnchor.constraintEqualToConstant(34).active = true
        deleteButton.widthAnchor.constraintEqualToConstant(34).active = true
        
        nameLabel.leadingAnchor.constraintEqualToAnchor(deleteButton.trailingAnchor, constant: 10).active = true
        nameLabel.topAnchor.constraintEqualToAnchor(topAnchor, constant: 4).active = true
        nameLabel.widthAnchor.constraintEqualToAnchor(widthAnchor, multiplier: 0.5).active = true
        nameLabel.heightAnchor.constraintEqualToConstant(35).active = true
        
        dateLabel.leadingAnchor.constraintEqualToAnchor(deleteButton.trailingAnchor, constant: 10).active = true
        dateLabel.topAnchor.constraintEqualToAnchor(nameLabel.bottomAnchor, constant: 0).active = true
        dateLabel.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: 0).active = true
        dateLabel.widthAnchor.constraintEqualToAnchor(nameLabel.widthAnchor, multiplier: 0.5).active = true
        
        priceLabel.trailingAnchor.constraintEqualToAnchor(trailingAnchor, constant: -10).active = true
        priceLabel.widthAnchor.constraintEqualToConstant(80).active = true
        priceLabel.heightAnchor.constraintEqualToConstant(50).active = true
        priceLabel.centerYAnchor.constraintEqualToAnchor(centerYAnchor, constant: 0).active = true
        
    }
    
    func configureCell(indexPath: Int, transaction: Transaction) {
        
        self.transaction = transaction
        //deleteButton.layer.cornerRadius = deleteButton.frame.width / 2
        nameLabel.text = transaction.name
        let stringDate = stringFromDate(transaction.created)
        dateLabel.text = stringDate
        priceLabel.text = "$\(Int(transaction.price))"
        if transaction.type == Constants.typeExpense {
            priceLabel.textColor = Constants.expenseColor
            deleteButton.backgroundColor = Constants.expenseColor
        } else {
            priceLabel.textColor = Constants.incomeColor
            deleteButton.backgroundColor = Constants.incomeColor
        }
        
        if indexPath % 2 == 0 || indexPath == 0 {
            backgroundColor = UIColor.rgb(250, green: 250, blue: 250, alpha: 1)
        } else {
            backgroundColor = UIColor.whiteColor()
            
        }
    }
    
    func stringFromDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        let stringDate = formatter.stringFromDate(date)
        return stringDate
    }
    
    func deleteTransaction(sender: UIButton) {
        delegate?.didDeleteTransaction(transaction)
    }

}
