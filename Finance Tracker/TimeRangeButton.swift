//
//  TimeRangeButton.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/8/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class TimeRangeButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupButton() {
        backgroundColor = UIColor.clearColor()
        setTitleColor(Constants.purpleBarColor, forState: .Normal)
        titleLabel?.font = UIFont.boldSystemFontOfSize(20)
    }

}
