//
//  TimeRangeContainer.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/8/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

enum TimeRange: String {
    case oneWeek = "1W"
    case oneMonth = "1M"
    case sixMonths = "6M"
    case oneYear = "1Y"
}

class TimeRangeContainer: UIView {
    
    private let cellId = "cellId"
    private let cellTitles = [TimeRange.oneWeek, TimeRange.oneMonth, TimeRange.sixMonths, TimeRange.oneYear]
    
    var statsViewController: StatsVC?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.allowsSelection = true 
        cv.backgroundColor = UIColor.clearColor()
        return cv
    }()
    
    let slidingBar: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Constants.purpleBarColor
        return v
    }()

    var slidingBarLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        let selectedItem = NSIndexPath(forItem: 0, inSection: 0)
        collectionView.selectItemAtIndexPath(selectedItem, animated: true, scrollPosition: .None)
        
        setupSlidingBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        collectionView.registerClass(TimeRangeCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        
    }
    
    func setupSlidingBar() {
        addSubview(slidingBar)
        
        slidingBarLeftAnchor = slidingBar.leftAnchor.constraintEqualToAnchor(leftAnchor)
        slidingBarLeftAnchor?.active = true
        slidingBar.bottomAnchor.constraintEqualToAnchor(bottomAnchor, constant: -2).active = true
        slidingBar.widthAnchor.constraintEqualToAnchor(self.widthAnchor, multiplier: 1/4).active = true
        slidingBar.heightAnchor.constraintEqualToConstant(5).active = true
    }

}

extension TimeRangeContainer: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! TimeRangeCell
        cell.choiceLabel.text = cellTitles[indexPath.row].rawValue
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! TimeRangeCell
        cell.choiceLabel.frame.width
        
        let lAnchor = CGFloat(indexPath.item) * frame.width / 4
        slidingBarLeftAnchor?.constant = lAnchor
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseIn, animations: {
            self.layoutIfNeeded()
            }, completion: nil)
        
        let time = cellTitles[indexPath.row].rawValue
        statsViewController?.showTransactionsFor(time)
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(frame.width / 4, frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
}


