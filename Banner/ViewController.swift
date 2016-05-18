//
//  ViewController.swift
//  Banner
//
//  Created by chaoyang805 on 16/5/17.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var banner: BannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        banner = BannerView(frame: self.view.frame)
        banner.setBannerImages(["4.jpg","3.jpg","2.jpg","1.jpg","0.jpg"])
        self.view.addSubview(banner)
        
        
        let button = UIButton(type: .System)
        button.setTitle("改变图片", forState: .Normal)
        button.addTarget(self, action: #selector(ViewController.changeBannerImages), forControlEvents: .TouchUpInside)
        button.frame = CGRect(x: 100, y: 100, width: 60, height: 40)
        let addTimerButton = UIButton(type: .System)
        addTimerButton.frame = CGRect(x: 100, y: 200, width: 80, height: 40)
        addTimerButton.setTitle("addTimeInterval", forState: .Normal)
        addTimerButton.addTarget(self, action: #selector(ViewController.addTimeInterval), forControlEvents: .TouchUpInside)
        
        let reduceButton = UIButton(type: .System)
        reduceButton.frame = CGRect(x: 200, y: 200, width: 80, height: 40)
        reduceButton.setTitle("reduceTimeInterval", forState: .Normal)
        reduceButton.addTarget(self, action: #selector(ViewController.reduceTimeInterval), forControlEvents: .TouchUpInside)
        self.view.addSubview(reduceButton)
        self.view.addSubview(addTimerButton)
        self.view.addSubview(button)
    }
    
    var reverse = true
    
    func changeBannerImages() {
        if reverse {
            banner.setBannerImages(["0.jpg","1.jpg","2.jpg","3.jpg"])
            reverse = false
        } else {
            banner.setBannerImages(["4.jpg","3.jpg","2.jpg","1.jpg","0.jpg"])
            reverse = true
        }
    }
    
    func addTimeInterval() {
        banner.autoScrollTimeInterval += 1.0
    }
    
    func reduceTimeInterval() {
        banner.autoScrollTimeInterval -= 1.0
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

