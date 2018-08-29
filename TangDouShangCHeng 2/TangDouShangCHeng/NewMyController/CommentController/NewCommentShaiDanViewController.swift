//
//  NewCommentShaiDanViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2018/3/13.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class NewCommentShaiDanViewController: UIViewController {
    var tableView:UITableView?
    var orderModel:OrderModel?
    var commentView:NewCommentView?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评价晒单"
        let leftControl = UIControl(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        leftControl.addTarget(self, action: #selector(back), for: .touchUpInside)
        let imageView  = UIImageView(frame: CGRect(x: 0, y: 13, width: 10, height: 18))
        imageView.image = UIImage(named: "shopBack")
        leftControl.addSubview(imageView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftControl)
        
        let rightItemControl = UIControl(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        rightItemControl.addTarget(self, action: #selector(rightClick), for: .touchUpInside)
        let label = UILabel(frame: CGRect(x: 0, y: 13, width: 60, height: 18))
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "提交"
        label.font = UIFont(name: "PingFangSC-Regular", size: 17)
        label.textColor = UIColor(fromHexString: "E26650")
        label.textAlignment = .right
        rightItemControl.addSubview(label)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightItemControl)
        
        tableView = UITableView(frame:CGRect(x: 0, y: 0, width: kWidth, height: kHeight))
        tableView?.backgroundColor = UIColor.white
        let nib = Bundle.main.loadNibNamed("NewCommentView", owner: nil, options: nil)
        let afterView = nib?.first as! NewCommentView
        afterView.width = kWidth
        afterView.orderModel = self.orderModel
        self.commentView = afterView
        tableView?.separatorStyle = .none
        tableView?.addSubview(afterView)
        self.view.addSubview(self.tableView!)
        
    }
    
    func rightClick() {
        //        MARK:提交评论数据 publicShaiDanWithUserId
       self.commentView?.addComment()
        
        
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }

}
