//
//  BannerView.swift
//  Banner
//
//  Created by chaoyang805 on 16/5/17.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

public class BannerView: UIView, UIScrollViewDelegate  {
    
    
    private var timer: NSTimer!
    private let MinimumTimeInterval = 1.5
    
    public var autoScroll = true
    
    public var autoScrollTimeInterval = 1.5 {
        didSet {
            if autoScrollTimeInterval < MinimumTimeInterval {
                autoScrollTimeInterval = MinimumTimeInterval
            }
            if autoScroll {
                self.stopTimer()
                self.startTimer()
            }
        }
    }
    
    public var pageControlEnabled = true
    public var pageIndicatorColor = UIColor.whiteColor()
    public var currentPageIndicatorColor = UIColor.blueColor()
    
    private var pageControl: UIPageControl!
    private func loadPageControl() -> UIPageControl{
        let pageControlHeight: CGFloat = 50
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: self.height - 50, width: self.width, height: pageControlHeight))
        pageControl.numberOfPages = self.images.count - 2
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.redColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blueColor()
        return pageControl
    }
    
    private var scrollView: UIScrollView!
    
    private func loadScrollView() -> UIScrollView {
        let _scrollView = UIScrollView(frame: self.frame)
        
        for (index, imageName) in self.images.enumerate() {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.frame = CGRectMake(CGFloat(index) * self.width, self.frame.origin.y, self.width, self.height)
            imageView.contentMode = .ScaleAspectFill
            imageView.userInteractionEnabled = true
            imageView.clipsToBounds = true
            _scrollView.addSubview(imageView)
        }
        
        _scrollView.userInteractionEnabled = true
        _scrollView.delegate = self
        _scrollView.pagingEnabled = true
        _scrollView.scrollEnabled = true
        _scrollView.showsHorizontalScrollIndicator = false
        _scrollView.showsVerticalScrollIndicator = false
        _scrollView.contentSize = CGSize(width: self.width * CGFloat(self.images.count), height: self.height)
        _scrollView.contentOffset = CGPoint(x: self.width, y: 0)
        return _scrollView
    }
    
    private var images: [String] {
        didSet {
            for subView in self.subviews {
                subView.removeFromSuperview()
            }
            self.scrollView = loadScrollView()
            self.addSubview(scrollView)
            if pageControlEnabled {
                self.pageControl = loadPageControl()
                self.addSubview(pageControl)
            }
            if autoScroll {
                self.startTimer()
            }
        }
    }
    
    private func startTimer() {
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(autoScrollTimeInterval, target: self, selector: #selector(BannerView.scrollToNextPage), userInfo: nil, repeats: true)
        }
    }
    
    private func stopTimer() {
        timer.invalidate()
        timer = nil
    }
    
    @objc private func scrollToNextPage() {
        let currentOffset = self.scrollView.contentOffset
        let nextOffset = CGPoint(x: currentOffset.x + width, y: 0)

        self.scrollView.setContentOffset(nextOffset, animated: true)
        if let pageControl = self.pageControl {
            pageControl.currentPage = (pageControl.currentPage + 1) % (self.images.count - 2)
        }
    }

    private var width: CGFloat {
        return self.frame.width
    }
    
    private var height: CGFloat {
        return self.frame.height
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.images = []
        super.init(coder: aDecoder)
       
    }

    override public init(frame: CGRect) {
        self.images = []
        super.init(frame: frame)
    }
    
    public func setBannerImages(imagesArray: [String]) {
        var tempArray = [String]()
        tempArray.append(imagesArray.last!)
        tempArray.appendContentsOf(imagesArray)
        tempArray.append(imagesArray.first!)
        self.images = tempArray
    }
    
    // MARK: UIScrollViewDelegate
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        if offsetX == 0 {
            scrollView.contentOffset = CGPoint(x: width * CGFloat(images.count - 2), y: 0)
        } else if offsetX == CGFloat(images.count - 1) * width {
            scrollView.contentOffset = CGPoint(x: width, y: 0)
        }
        
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

        let currentPage = scrollView.contentOffset.x / width - 0.5
        if let pageControl = self.pageControl {
            pageControl.currentPage = Int(currentPage)
        }
        
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.stopTimer()
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.startTimer()
    }
    
}
