//
//  TimeRangeCell.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/8/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class TimeRangeCell: UICollectionViewCell {
    
    let choiceLabel: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.blackColor()
        l.textAlignment = .Center
        return l
    }()
    
//    override var highlighted: Bool {
//        didSet {
//            choiceLabel.textColor = highlighted ? Constants.purpleBarColor : UIColor.blackColor()
//        }
//    }
    
    override var selected: Bool {
        didSet {
            choiceLabel.textColor = selected ? Constants.purpleBarColor : UIColor.blackColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = UIColor.clearColor()
        addSubview(choiceLabel)
        
        addConstraintsWithFormat("H:|-10-[v0]-10-|", views: choiceLabel)
        addConstraintsWithFormat("V:|-10-[v0]-10-|", views: choiceLabel)
    }
    
}
