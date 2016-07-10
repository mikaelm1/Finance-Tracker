//
//  StatsCell.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/4/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class TransactionCell: UICollectionViewCell {
    
    // MARK: Properties
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Name"
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont.systemFontOfSize(14)
        l.textColor = UIColor.darkGrayColor()
        l.minimumScaleFactor = 0.7
        return l
    }()
    
    let dateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont.systemFontOfSize(10)
        l.textColor = UIColor.lightGrayColor()
        l.text = "Date"
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
        l.text = "$ 100"
        l.minimumScaleFactor = 0.7
        return l
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
        
        addConstraintsWithFormat("H:|-5-[v0]", views: nameLabel)
        
        addConstraintsWithFormat("V:|-5-[v0]", views: nameLabel)
        
        dateLabel.topAnchor.constraintEqualToAnchor(nameLabel.bottomAnchor, constant: 5).active = true
        dateLabel.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -5).active = true
        dateLabel.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 5).active = true
        
        priceLabel.trailingAnchor.constraintEqualToAnchor(self.trailingAnchor, constant: -5).active = true
        priceLabel.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 5).active = true
        NSLayoutConstraint(item: priceLabel, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 0.3, constant: 0).active = true
        NSLayoutConstraint(item: priceLabel, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 0.7, constant: 0).active = true
    }
    
    func configureCell(indexPath: Int, transaction: Transaction) {
        
        nameLabel.text = transaction.name
        let stringDate = stringFromDate(transaction.created)
        dateLabel.text = stringDate
        priceLabel.text = "$\(Int(transaction.price))"
        if transaction.type == Constants.typeExpense {
            priceLabel.textColor = Constants.expenseColor
        } else {
            priceLabel.textColor = Constants.incomeColor
        }
        
        if indexPath % 2 == 0 || indexPath == 0 {
            backgroundColor = UIColor.lightGrayColor()
            dateLabel.textColor = UIColor.whiteColor()
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

}







