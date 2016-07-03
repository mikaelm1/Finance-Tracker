//
//  CustomTabBarController.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/3/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statsController = UIViewController()
        statsController.view.backgroundColor = UIColor.redColor()
        
        viewControllers = [statsController]
    }

}
