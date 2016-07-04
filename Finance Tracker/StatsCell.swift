//
//  StatsCell.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/4/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class StatsCell: UITableViewCell {
    
    let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.adjustsFontSizeToFitWidth = true
        l.font = UIFont.systemFontOfSize(14)
        l.textColor = UIColor.darkGrayColor()
        l.text = "Name of transaction"
        l.minimumScaleFactor = 0.7
        return l
    }()
    
    func configureCell(indexPath: Int) {
        if indexPath % 2 == 0 {
            backgroundColor = UIColor.lightGrayColor()
        } else {
            backgroundColor = UIColor.whiteColor()
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        addSubview(nameLabel)
        
        addConstraintsWithFormat("H:|-5-[v0]", views: nameLabel)
        
        addConstraintsWithFormat("V:|-5-[v0]", views: nameLabel)
    }

}
