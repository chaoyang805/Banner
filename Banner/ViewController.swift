//
//  ViewController.swift
//  Banner
//
//  Created by chaoyang805 on 16/5/17.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, JKBannerView1Delegate {

    var banner: BannerView!
    var banner2: JKBannerView1!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        banner2 = JKBannerView1(imagesNamed: ["4.jpg","3.jpg","2.jpg","1.jpg","0.jpg"], frame: self.view.bounds)
        banner2.delegate = self
        self.view.addSubview(banner2!)

        let button = UIButton(type: .system)
        button.setTitle("改变图片", for: UIControlState())
        button.addTarget(self, action: #selector(ViewController.changeBannerImages), for: .touchUpInside)
        button.frame = CGRect(x: 100, y: 100, width: 60, height: 40)
        button.sizeToFit()
        self.view.addSubview(button)
        
        let addTimerButton = UIButton(type: .system)
        addTimerButton.frame = CGRect(x: 80, y: 200, width: 80, height: 40)
        addTimerButton.setTitle("addTimeInterval", for: UIControlState())
        addTimerButton.addTarget(self, action: #selector(ViewController.addTimeInterval), for: .touchUpInside)
        addTimerButton.sizeToFit()
        self.view.addSubview(addTimerButton)

        let reduceButton = UIButton(type: .system)
        reduceButton.frame = CGRect(x: 200, y: 200, width: 80, height: 40)
        reduceButton.setTitle("reduceTimeInterval", for: UIControlState())
        reduceButton.addTarget(self, action: #selector(ViewController.reduceTimeInterval), for: .touchUpInside)
        reduceButton.sizeToFit()
        self.view.addSubview(reduceButton)
        
    }
    
    var reverse = true
    
    func changeBannerImages() {
        if reverse {
            banner2.images = [
                UIImage(named: "0.jpg")!,
                UIImage(named: "1.jpg")!,
                UIImage(named: "2.jpg")!,
                UIImage(named: "3.jpg")!
            ]
            reverse = false
        } else {

            banner2.images = [
                UIImage(named: "4.jpg")!,
                UIImage(named: "3.jpg")!,
                UIImage(named: "2.jpg")!,
                UIImage(named: "1.jpg")!,
                UIImage(named: "0.jpg")!
            ]
            reverse = true
        }
    }
    
    func addTimeInterval() {
        banner2.autoScrollTimeInterval += 1.0
        
    }
    
    func reduceTimeInterval() {
        banner2.autoScrollTimeInterval -= 1.0
    }
    
    // MARK: JKBannerViewDelegate
    
    func bannerView(_ bannerView: JKBannerView1!, tappedAt index: UInt) {
        NSLog("tapped index \(index)")
    }
    
    

}

