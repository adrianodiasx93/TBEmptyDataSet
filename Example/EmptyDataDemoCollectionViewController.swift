//
//  EmptyDataDemoCollectionViewController.swift
//  TBEmptyDataSetExample
//
//  Created by 洪鑫 on 15/11/24.
//  Copyright © 2015年 Teambition. All rights reserved.
//

import UIKit
import TBEmptyDataSet

class EmptyDataDemoCollectionViewController: UICollectionViewController, TBEmptyDataSetDataSource, TBEmptyDataSetDelegate {
    // MARK: - Structs
    private struct CellIdentifier {
        static let reuseIdentifier = "Cell"
    }

    // MARK: - Properties
    var indexPath = NSIndexPath()
    private var isLoading = false

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "CollectionView"
        collectionView!.emptyDataSetDataSource = self
        collectionView!.emptyDataSetDelegate = self
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifier.reuseIdentifier)

        if indexPath.row != 0 {
            loadData(self)
        }
    }

    // MARK: - Helper
    func loadData(sender: AnyObject) {
        isLoading = true
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) { () -> Void in
            self.isLoading = false
            self.collectionView!.reloadData()
        }
    }

    // MARK: - Collection view data source
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 0
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.reuseIdentifier, forIndexPath: indexPath)

        return cell
    }

    // MARK: - TBEmptyDataSet data source
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString? {
        let title = EmptyData.titles[indexPath.row]
        var attributes: [String : AnyObject]?
        if indexPath.row == 1 {
            attributes = [NSFontAttributeName: UIFont.systemFontOfSize(22.0), NSForegroundColorAttributeName: UIColor.grayColor()]
        } else if indexPath.row == 2 {
            attributes = [NSFontAttributeName: UIFont.systemFontOfSize(24.0), NSForegroundColorAttributeName: UIColor.grayColor()]
        }
        return NSAttributedString(string: title, attributes: attributes)
    }

    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString? {
        let description = EmptyData.descriptions[indexPath.row]
        var attributes: [String : AnyObject]?
        if indexPath.row == 1 {
            attributes = [NSFontAttributeName: UIFont.systemFontOfSize(17.0), NSForegroundColorAttributeName: UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1)]
        } else if indexPath.row == 2 {
            attributes = [NSFontAttributeName: UIFont.systemFontOfSize(18.0), NSForegroundColorAttributeName: UIColor.purpleColor()]
        }
        return NSAttributedString(string: description, attributes: attributes)
    }

    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage? {
        return EmptyData.images[indexPath.row]
    }

    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        if let navigationBar = navigationController?.navigationBar {
            return -navigationBar.frame.height * 0.75
        }
        return 0
    }

    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor? {
        return UIColor(white: 0.95, alpha: 1)
    }

    func customViewForEmptyDataSet(scrollView: UIScrollView!) -> UIView? {
        let loadingView: UIView = {
            let loadingImageView = UIImageView(image: UIImage(named: "loading")!)
            let view = UIView(frame: loadingImageView.frame)
            view.addSubview(loadingImageView)

            let animation: CABasicAnimation = {
                let animation = CABasicAnimation(keyPath: "transform")
                animation.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
                animation.toValue = NSValue(CATransform3D: CATransform3DMakeRotation(CGFloat(M_PI_2), 0, 0, 1))
                animation.duration = 0.3
                animation.cumulative = true
                animation.repeatCount = FLT_MAX
                return animation
            }()
            loadingImageView.layer.addAnimation(animation, forKey: "loading")

            return view
        }()

        if isLoading {
            return loadingView
        } else {
            return nil
        }
    }

    // MARK: - TBEmptyDataSet delegate
    func emptyDataSetScrollEnabled(scrollView: UIScrollView!) -> Bool {
        return true
    }

    func emptyDataSetTapEnabled(scrollView: UIScrollView!) -> Bool {
        return true
    }

    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        return true
    }

    func emptyDataSetWillAppear(scrollView: UIScrollView!) {
        print("EmptyDataSet Will Appear!")
    }

    func emptyDataSetDidAppear(scrollView: UIScrollView!) {
        print("EmptyDataSet Did Appear!")
    }

    func emptyDataSetWillDisappear(scrollView: UIScrollView!) {
        print("EmptyDataSet Will Disappear!")
    }

    func emptyDataSetDidDisappear(scrollView: UIScrollView!) {
        print("EmptyDataSet Did Disappear!")
    }

    func emptyDataSetDidTapView(scrollView: UIScrollView!) {
        let alert = UIAlertController(title: nil, message: "Did Tap EmptyDataView!", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}