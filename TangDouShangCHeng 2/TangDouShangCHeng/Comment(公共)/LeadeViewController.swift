//
//  LeadeViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2018/2/6.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class LeadeViewController: UIViewController,UIScrollViewDelegate {

    var scrollerView:UIScrollView?
    var kwidth = UIScreen.main.bounds.size.width
    var changx:CGFloat = -UIScreen.main.bounds.size.width
    var timer:Timer?
    var flag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollerView = UIScrollView(frame: self.view.frame)
        self.scrollerView?.backgroundColor = UIColor.white
        self.scrollerView?.isPagingEnabled = true
        self.scrollerView?.delegate = self
        
        self.scrollerView?.contentSize = CGSize(width: self.view.frame.size.width*3, height: self.view.frame.size.height)
        for i in 0..<3 {
            let img = UIImageView(frame: CGRect(x: CGFloat(i)*self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            img.image = UIImage(named: "\(i+1)")
            img.contentMode = .scaleAspectFit
            self.scrollerView?.addSubview(img)
            
        }
        
//        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(nextgo), userInfo: nil, repeats: true)
        self.view.addSubview(self.scrollerView!)
    }
    
    
    @objc func nextgo() {
        if flag == 2 {
            self.timer?.invalidate()
            self.timer = nil
            self.perform(#selector(into), with: nil, afterDelay: 1.5)
            return
        }
        flag += 1
        changx+=kwidth
        self.scrollerView?.setContentOffset(CGPoint(x:changx, y: 0), animated: true)
        
    }
    
    func into() {
        let tabVC = BaseTabBarViewController()
       UIApplication.shared.keyWindow?.rootViewController = tabVC
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView){
//        self.timer?.invalidate()
//        self.timer = nil
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        changx+=(scrollerView?.contentOffset.x)!
        if scrollerView?.contentOffset.x == kWidth*2 {
            self.perform(#selector(into), with: nil, afterDelay: 1.5)
        }else{
//            self.flag = 1
//            timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(nextgo), userInfo: nil, repeats: true)
            
        }
    }
}
