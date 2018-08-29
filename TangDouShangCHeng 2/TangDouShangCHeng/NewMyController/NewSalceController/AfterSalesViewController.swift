//
//  AfterSalesViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2018/2/27.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class AfterSalesViewController: UIViewController {
    var scollerView:UIScrollView?
    var orderModel:OrderModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "售后服务"
        let leftControl = UIControl(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        leftControl.addTarget(self, action: #selector(back), for: .touchUpInside)
        let imageView  = UIImageView(frame: CGRect(x: 0, y: 13, width: 10, height: 18))
        imageView.image = UIImage(named: "shopBack")
        leftControl.addSubview(imageView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftControl)
        
        scollerView = UIScrollView(frame: self.view.frame)
        scollerView?.backgroundColor = UIColor.white
        let nib = Bundle.main.loadNibNamed("AfterSclesView", owner: nil, options: nil)
        let afterView = nib?.first as! AfterSclesView
        afterView.width = kWidth
        scollerView?.addSubview(afterView)
        afterView.model = orderModel
        scollerView?.contentSize = CGSize(width: afterView.frame.size.width, height: (afterView.frame.size.height*(kWidth/375)-50))
        self.view.addSubview(self.scollerView!)
        
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }

   

}
