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
    
    let navbarView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.redColor()
        return v
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
        view.backgroundColor = UIColor.whiteColor()
        setupViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupViews() {
        view.addSubview(navbarView)
        view.addSubview(collectionView)
        
        navbarView.topAnchor.constraintEqualToAnchor(topLayoutGuide.topAnchor, constant: 0).active = true
        navbarView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 0).active = true
        navbarView.heightAnchor.constraintEqualToConstant(60).active = true
        navbarView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: 0).active = true
        
        collectionView.topAnchor.constraintEqualToAnchor(navbarView.bottomAnchor, constant: 0).active = true
        collectionView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 0).active = true
        collectionView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: 0).active = true
        collectionView.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.bottomAnchor, constant: 0).active = true
    }
}

extension TransactionsVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! TransactionCell
        let transaction = transactions[indexPath.row]
        print("Transaction in cell: \(transaction)")
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
















