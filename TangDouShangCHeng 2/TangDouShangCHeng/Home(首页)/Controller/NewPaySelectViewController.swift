//
//  NewPaySelectViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/11/30.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit
@objc(paySelectDelegate)
protocol paySelectDelegate {
    func zfbPay()
    func zxPay()
    func abPay()
    func wxPay()
    func mustPay()
    
}
@objc(NewPaySelectViewController)
class NewPaySelectViewController: UIViewController {
    var paySelectVC:PaySelectedController?
    var payDelegate:paySelectDelegate?

    var mustPayMoney:String?{
        didSet{
           self.createHeader()
        }
    }
    
    func createHeader(){
        let headrView = UIView(frame: CGRect(x: 0, y: 15, width: UIScreen.main.bounds.size.width, height: 50))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: headrView.frame.width/2-20, height: 50))
        label.text = "请选择付款方式"
        label.font = UIFont.systemFont(ofSize: 14)
        headrView.addSubview(label)
        
        let str = "\(self.mustPayMoney!)"
        let moneyLabel = UILabel(frame: CGRect(x:  headrView.frame.width/2, y: 0, width:  headrView.frame.width/2-20, height: 50))
        moneyLabel.textAlignment = .right
        moneyLabel.textColor = UIColor.red
        moneyLabel.text = str
        moneyLabel.font = UIFont.systemFont(ofSize: 14)
        headrView.addSubview(moneyLabel)
        headrView.backgroundColor = UIColor.white
        self.view.addSubview(headrView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择支付方式"
        self.view.backgroundColor = UIColor(hexString: "f7f7f7")
        let selectVC = PaySelectedController(nibName: "PaySelectedController", bundle: nil)
        self.view.addSubview(selectVC.tableView)
        self.addChildViewController(selectVC)
        selectVC.tableView.top = 64
        paySelectVC = selectVC
        
       
        let btn = UIButton(frame: CGRect(x: 50, y:  64+ShareManager.shareInstance().configureArray.count*44+30, width: Int(UIScreen.main.bounds.size.width-100), height: 50))
       
        btn.backgroundColor = ShareManager.shareInstance().isInYlc ? UIColor.defaultRed():UIColor(fromHexString: "5ad485")
        btn.setBackgroundImage(UIImage.init(named: "nav"), for: .normal);
        btn.setTitle("确定", for: .normal)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 25
        btn.addTarget(self, action: #selector(self.paySelect), for: .touchUpInside)
        self.view.addSubview(btn)
        
    }

    func paySelect() {

        for data in ShareManager.shareInstance().configureArray{
            let dic = data as! PaySelectedData
            if dic.isSelected{
                print("(dic.pay_channer_desc",dic.pay_channer_desc)
                if (dic.pay_channer_desc == "alipay"){
                    self.payDelegate?.zfbPay()
                }
                if (dic.pay_channer_desc == "weixin_zhongxin"){
                    self.payDelegate?.zxPay()
                }
                if (dic.pay_channer_desc == "iapppay_h5"){
                    self.payDelegate?.abPay()
                }
                if (dic.pay_channer_desc == "wechat_pay"){
                    self.payDelegate?.wxPay()
                }
                
                if (dic.pay_channer_desc == "alipay_zhongxin"){
                    self.payDelegate?.wxPay()
                }
                
                if (dic.pay_channer_desc == "onechanel"){
                    self.payDelegate?.mustPay()
                }
                
            }
        }
        
    }
 
}

