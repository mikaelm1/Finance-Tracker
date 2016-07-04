//
//  ColorExtensions.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/4/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat?) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha == nil ? 1: alpha!)
    }
}
