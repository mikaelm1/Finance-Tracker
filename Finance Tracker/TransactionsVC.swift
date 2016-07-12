//
//  TransactionsVC.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/10/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit
import RealmSwift

class TransactionsVC: UIViewController {
    
    private let cellId = "cellId"
    var transactions: Results<Transaction>! = nil
    
    lazy var dismissButton: UIButton = {
        let b = UIButton(type: .System)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("X", forState: .Normal)
        b.addTarget(self, action: #selector(dismissButtonTapped), forControlEvents: .TouchUpInside)
        b.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        b.layer.borderColor = UIColor.whiteColor().CGColor
        b.layer.borderWidth = 2
        b.titleLabel?.font = UIFont.systemFontOfSize(25, weight: 300)
        return b
    }()
    
    let navbarView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.rgb(172, green: 73, blue: 188, alpha: 1)
        return v
    }()
    
    let transactionsCountLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.blackColor()
        l.backgroundColor = UIColor.whiteColor()
        l.textAlignment = .Center
        return l
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.registerClass(TransactionCell.self, forCellWithReuseIdentifier: self.cellId)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.whiteColor()
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TransactionsVC view did load")
        view.backgroundColor = UIColor.whiteColor()
        setupViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        
        transactionsCountLabel.text = "Showing \(transactions.count) Transactions"
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func setupViews() {
        view.addSubview(navbarView)
        view.addSubview(collectionView)
        
        view.addSubview(transactionsCountLabel)
        transactionsCountLabel.topAnchor.constraintEqualToAnchor(navbarView.bottomAnchor).active = true
        transactionsCountLabel.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 0).active = true
        transactionsCountLabel.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: 0).active = true
        transactionsCountLabel.heightAnchor.constraintEqualToConstant(50).active = true
        
        navbarView.addSubview(dismissButton)
        dismissButton.leadingAnchor.constraintEqualToAnchor(navbarView.leadingAnchor, constant: 16).active = true
        dismissButton.bottomAnchor.constraintEqualToAnchor(navbarView.bottomAnchor, constant: -8).active = true
        dismissButton.widthAnchor.constraintEqualToConstant(25).active = true
        dismissButton.heightAnchor.constraintEqualToConstant(25).active = true
        
        navbarView.topAnchor.constraintEqualToAnchor(topLayoutGuide.topAnchor, constant: 0).active = true
        navbarView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 0).active = true
        navbarView.heightAnchor.constraintEqualToConstant(60).active = true
        navbarView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: 0).active = true
        
        collectionView.topAnchor.constraintEqualToAnchor(transactionsCountLabel.bottomAnchor, constant: 0).active = true
        collectionView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 0).active = true
        collectionView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: 0).active = true
        collectionView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.bottomAnchor, constant: 0).active = true
    }
    
    func dismissButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension TransactionsVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! TransactionCell
        let transaction = transactions[indexPath.row]
        cell.configureCell(indexPath.row, transaction: transaction)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.frame.width, 70)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
}
















