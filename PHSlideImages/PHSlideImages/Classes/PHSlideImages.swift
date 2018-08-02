//
//  PHSlideImages.swift
//  PHSlideImages
//
//  Created by phuongpro Imac on 8/2/18.
//  Copyright © 2018 phuongpro. All rights reserved.
//

import UIKit

public struct PHSlide {
    public var image: UIImage?
    public var title: String?
    public var description: String?
    
    public init(image: UIImage, title: String?, description: String?) {
        self.image = image
        self.title = title
        self.description = description
    }
}

final public class PHSlideImages: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public var data: [PHSlide] = [] {
        didSet {
            self.collectionView.reloadData()
            self.layoutIfNeeded()
        }
    }
    
    public var showPagination: Bool = true
    public var numberPages: Int = 3 {
        didSet {
            pageControl.numberOfPages = numberPages
        }
    }
    public var currentPagePh: Int = 1 {
        didSet {
            pageControl.currentPage = currentPagePh
        }
    }
//    public var numberOfPagesPagination: Int = 3
//    public var currentPage: Int = 0
    
    
    public var scrollDirection: UICollectionViewScrollDirection = .horizontal
    
    lazy var pageControl : UIPageControl = {
        let control = UIPageControl()
        control.hidesForSinglePage = true
        control.pageIndicatorTintColor = .lightGray
        control.currentPageIndicatorTintColor = UIColor(red:0.20, green:0.60, blue:0.86, alpha:1.0)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
       let cv = UICollectionView()
        
        cv.clipsToBounds = true
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.bounces = false
        cv.isPagingEnabled = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    private lazy var tapGesture : UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(tap:)))
        return tap
    }()

    fileprivate let cellId = "PHSlideCell"
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.register(PHSlideImagesCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    fileprivate func setupLayout() {
        self.backgroundColor = .clear
        self.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
            ])
        collectionView.addGestureRecognizer(tapGesture)
        if showPagination {
            self.addSubview(pageControl)
            NSLayoutConstraint(item: pageControl, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 20).isActive = true
            NSLayoutConstraint(item: pageControl, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -20).isActive = true
            NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -5).isActive = true
            NSLayoutConstraint(item: pageControl, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 25).isActive = true
            self.bringSubview(toFront: pageControl)
        }
    }
    
    
    @objc private func tapGestureHandler(tap: UITapGestureRecognizer?) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint) ?? IndexPath(item: 0, section: 0)
        let index = visibleIndexPath.item
        
        if index == (data.count - 1) {
            let indexPathToShow = IndexPath(item: 0, section: 0)
            self.collectionView.selectItem(at: indexPathToShow, animated: true, scrollPosition: .centeredHorizontally)
        } else {
            let indexPathToShow = IndexPath(item: (index + 1), section: 0)
            self.collectionView.selectItem(at: indexPathToShow, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    // CONTROL AUTOMATIC
    private var timer : Timer = Timer()
    public var interval : Double?
    
    public func start() {
        timer = Timer.scheduledTimer(timeInterval: interval ?? 1.0, target: self, selector: #selector(tapGestureHandler(tap:)), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    public func stop() {
        timer.invalidate()
    }
    
    // -------------- return current indexpath collection view ------ //
    public func selectedIndexPath() -> IndexPath? {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return collectionView.indexPathForItem(at: visiblePoint)
    }

}

// ----------------------- Extension ----------------------- //
extension PHSlideImages {
    
    // MARK --- COLLECTIONVIEW ----
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PHSlideImagesCollectionViewCell
        //        cell.slide = self.slides[indexPath.item]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return size
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // MARK SCROLLVIEW
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}










