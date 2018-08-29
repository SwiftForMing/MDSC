//
//  NewShopMyOrderViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/28.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewShopMyOrderViewController: BaseTableViewController {

    var allBtn:UIButton?
    var waitPayBtn:UIButton?
    var waitSendBtn:UIButton?
    var sendBtn:UIButton?
    var commentBtn:UIButton?
    
    var flagLabel:UILabel?
    var flagLabelX:CGFloat = 0
    var flagLabelW:CGFloat = 0
    var btnSelectTag:Int?
    var orderModels:[OrderModel] = []
    var popView:PopView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的订单"
        self.createStatusView()
        self.tableView.frame = CGRect(x: 0, y: 37, width: kWidth, height: kHeight-40)
        self.tableView.backgroundColor = UIColor(fromHexString: "F8F6F6")
        self.setTabelViewRefresh()
    }

    func createStatusView()  {
        let headeView = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 33))
        headeView.backgroundColor = UIColor.white
        flagLabelW = (kWidth-120)/5
        flagLabelX = 20
        let y:CGFloat = 5
        let allBtn = UIButton(frame: CGRect(x: flagLabelX, y: y, width: flagLabelW, height: 23))
        allBtn.setTitle("全部", for: .normal)
        allBtn.setTitleColor(UIColor(fromHexString: "666666"), for: .normal)
        allBtn.setTitleColor(UIColor(fromHexString: "333333"), for: .selected)
        allBtn.isSelected = true
        allBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        allBtn.whenTapped {
            //MARK:点击未使用btn跳转方法
            self.btnSelectTag = 0
            self.selectLabelWith(tag: self.btnSelectTag!)
           
        }
        self.allBtn = allBtn
        let label = UILabel(frame: CGRect(x: flagLabelX+5, y: 32, width: flagLabelW-10, height: 2))
       
        label.backgroundColor = UIColor(fromHexString: "E26650")
        headeView.addSubview(label)
        self.flagLabel = label
        self.selectLabelWith(tag: btnSelectTag!)
        headeView.addSubview(allBtn)
        
        flagLabelX = CGFloat(20*2)+flagLabelW
        
        let waitPayBtn = UIButton(frame: CGRect(x: flagLabelX, y: y, width: flagLabelW, height: 23))
        waitPayBtn.setTitle("待付款", for: .normal)
        waitPayBtn.setTitleColor(UIColor(fromHexString: "666666"), for: .normal)
        waitPayBtn.setTitleColor(UIColor(fromHexString: "333333"), for: .selected)
        waitPayBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        waitPayBtn.whenTapped {
            //MARK:点击已使用btn跳转方法
            self.btnSelectTag = 1
            self.selectLabelWith(tag: self.btnSelectTag!)
            
        }
        self.waitPayBtn = waitPayBtn
        headeView.addSubview(waitPayBtn)
        
        flagLabelX = CGFloat(20*3)+2*flagLabelW
        let waitSendBtn = UIButton(frame: CGRect(x: flagLabelX, y: y, width: flagLabelW, height: 23))
        waitSendBtn.setTitle("待发货", for: .normal)
        waitSendBtn.setTitleColor(UIColor(fromHexString: "666666"), for: .normal)
        waitSendBtn.setTitleColor(UIColor(fromHexString: "333333"), for: .selected)
        waitSendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        waitSendBtn.whenTapped {
            //MARK:点击已过期btn跳转方法
            self.btnSelectTag = 2
            self.selectLabelWith(tag: self.btnSelectTag!)
        }
        self.waitSendBtn = waitSendBtn
        headeView.addSubview(waitSendBtn)
        flagLabelX = CGFloat(20*4)+3*flagLabelW
        let sendBtn = UIButton(frame: CGRect(x: flagLabelX, y: y, width: flagLabelW, height: 23))
        sendBtn.setTitle("已发货", for: .normal)
        sendBtn.setTitleColor(UIColor(fromHexString: "666666"), for: .normal)
        sendBtn.setTitleColor(UIColor(fromHexString: "333333"), for: .selected)
        sendBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        sendBtn.whenTapped {
            //MARK:点击已转让btn跳转方法
            self.btnSelectTag = 3
            self.selectLabelWith(tag: self.btnSelectTag!)
        }
        
        self.sendBtn = sendBtn
        headeView.addSubview(sendBtn)
         flagLabelX = CGFloat(20*5)+4*flagLabelW
        let commentBtn = UIButton(frame: CGRect(x: flagLabelX, y: y, width: flagLabelW, height: 23))
        commentBtn.setTitle("待评价", for: .normal)
        commentBtn.setTitleColor(UIColor(fromHexString: "666666"), for: .normal)
        commentBtn.setTitleColor(UIColor(fromHexString: "333333"), for: .selected)
        commentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        commentBtn.whenTapped {
            //MARK:点击已转让btn跳转方法
            self.btnSelectTag = 4
            self.selectLabelWith(tag: self.btnSelectTag!)
           
        }
        self.commentBtn = commentBtn
        headeView.addSubview(commentBtn)
        
        self.view.addSubview(headeView)
        
    }
   
    func selectLabelWith(tag: Int) {
        self.cancelBtnSelect(tag: tag)
        let x = CGFloat(20)+(20+flagLabelW)*CGFloat(tag)
        UIView.animate(withDuration: 0.1, animations: {
            self.flagLabel?.frame = CGRect(x: x+5, y: 32, width: self.flagLabelW-10, height: 2)
        }, completion: nil)
        
        //        MARK:获取网络数据然后刷新请求
//        self.orderModels.removeAll()
        self.setTabelViewRefresh()
    }
    
    func cancelBtnSelect(tag:Int) {
        allBtn?.isSelected = false
        waitPayBtn?.isSelected = false
        waitSendBtn?.isSelected = false
        sendBtn?.isSelected = false
        commentBtn?.isSelected = false
        
        if tag == 0 {
            allBtn?.isSelected = true
        }
        if tag == 1 {
            waitPayBtn?.isSelected = true
        }
        if tag == 2 {
            waitSendBtn?.isSelected = true
           
        }
        if tag == 3 {
            sendBtn?.isSelected = true
        }
        if tag == 4 {
            commentBtn?.isSelected = true
        }
        
        
        
    }
    
    var status = ["全部","待付款","待发货","已发货","待评价"]
    var page = 1
    func getData() {
        let type = status[self.btnSelectTag!]
        weak var weakSelf = self
        HttpHelper.getMyorderLiset(withUserID: ShareManager.shareInstance().userinfo.id, type: type, pageNum: "\(page)", limitNum: "10", success: { (data) in
            weakSelf?.hideRefresh()
            let dict = data! as NSDictionary
            let status = dict["status"] as! String
            let desc = dict["desc"] as! String
            if (status == "0"){
                weakSelf?.handleloadResult(dict: dict)
            }else{
              Tool.showPromptContent(desc, on: weakSelf?.view)
            }
        }) { (error) in
            Tool.showPromptContent("网络连接失败", on: weakSelf?.view)
        }
    }
    
    func handleloadResult(dict:NSDictionary) {
        let dic = dict["data"] as! NSDictionary
        let orderArr = dic["orderList"] as! NSArray
        if orderArr.count>0 {
            if orderModels.count>0&&page  == 1{
                orderModels.removeAll()
            }
        }else {
            Tool.showPromptContent("暂无数据哦亲！😊")
            if (page == 1){
              orderModels.removeAll()
            }
        }
        
        for orderDic in orderArr {
            let orderDict = orderDic as! NSDictionary
            let model = orderDict.object(by: OrderModel.self) as! OrderModel
            self.orderModels.append(model)
        }
        page += 1
        self.tableView.reloadData()
    }
 
    
    //    MARK: - 上下刷新
    func setTabelViewRefresh() {
        weak var weakSelf = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            weakSelf?.getData()
           
        })
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        weakSelf?.tableView.mj_header.isAutomaticallyChangeAlpha = true
        weakSelf?.tableView.mj_header.beginRefreshing()
        //        上拉刷新
        weakSelf?.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
             weakSelf?.getData()
        })
//        weakSelf?.tableView.mj_footer.isAutomaticallyHidden = true
        
    }
    
    func hideRefresh() {
        if self.tableView.mj_footer.isRefreshing {
            self.tableView.mj_footer.endRefreshing()
        }
        if self.tableView.mj_header.isRefreshing {
            self.tableView.mj_header.endRefreshing()
        }
        
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return orderModels.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib = Bundle.main.loadNibNamed("SimGoodCell", owner: nil, options: nil)
        let cell = nib?.first as! SimGoodCell
        cell.orderModel = self.orderModels[indexPath.section]
        cell.goodNumLabel.isHidden = true
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 54))
        view.backgroundColor = UIColor.white
    
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: kWidth, height: 10))
        label.backgroundColor = UIColor(fromHexString: "F8F6F6")
        view.addSubview(label)
        
        let statuLabel = UILabel(frame: CGRect(x: 20, y: 15, width: kWidth-40, height: 30))
        statuLabel.textAlignment = .right
        let model = orderModels[section]
        if (model.pay_status == "未支付"){
           statuLabel.text = "待付款"
        }else if (model.status==status[3]&&model.confirm_good=="y"){
           statuLabel.text = "交易完成"
        }else {
           statuLabel.text = model.status
        }
        statuLabel.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(statuLabel)
        
        let line = UILabel(frame: CGRect(x: 20, y: 53, width: kWidth-40, height: 1))
        line.backgroundColor = UIColor(fromHexString: "f4f4f4")
        view.addSubview(line)
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  54
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let model = orderModels[section]

        if (model.status==status[2]&&model.pay_status == "未支付"||model.status==status[1]) {
            let nib = Bundle.main.loadNibNamed("NewShopOrderFooterView", owner: nil, options: nil)
            let view = nib?.first as! NewShopOrderFooterView
            view.cancelPayBtn.setTitle("支付", for: .normal)
            //支付
            view.cancelPayBtn.whenTapped {
                self.popView = PopView(frame: self.view.frame)
                let height = ShareManager.shareInstance().configureArray.count * 55 + 100
                let fram = CGRect(x: 0, y: 0, width: Int(kWidth), height: height)
//                let showView = RePayView(frame: fram, model: model.setHomeGoodMode(), propertys: model.propertys, price: model.pay_money,type:"b",order_id:model.id,buyNum:"1")
//                showView.delegate = self
//                self.popView?.showInView(self.view, withChirdView: showView,moveVaule:0)
            }
            //取消订单
            view.cancelOrderBtn.whenTapped({
                self.deleteOrCancanOrder(withOrder: model.id, withType: "c",withTip:"取消订单成功")
            })
            
            view.priceNumLabel.text = "实付：¥ \(model.pay_money!)"
           return view
        }
        if (model.status==status[2]) {
            let nib = Bundle.main.loadNibNamed("NewShopOrderFooterView", owner: nil, options: nil)
            let view = nib?.first as! NewShopOrderFooterView
            view.cancelPayBtn.setTitle("提醒发货", for: .normal)
            //提醒发货
            view.cancelPayBtn.whenTapped {
                self.deleteOrCancanOrder(withOrder: model.id, withType: "remind",withTip:"提醒发货成功")
            }
            //取消订单
            view.cancelOrderBtn.whenTapped({
                self.deleteOrCancanOrder(withOrder: model.id, withType: "c",withTip:"取消订单成功")
            })
            
            view.priceNumLabel.text = "实付：¥ \(model.pay_money!)"
           return view
        }
        if (model.status==status[3]&&model.confirm_good=="n") {
            let nib = Bundle.main.loadNibNamed("NewShopOrderFooterView", owner: nil, options: nil)
            let view = nib?.first as! NewShopOrderFooterView
            view.cancelPayBtn.setTitle("确认收货", for: .normal)
            view.cancelOrderBtn.setTitle("查看物流", for: .normal)
            view.cancelPayBtn.whenTapped {
                //取消订单
                self.deleteOrCancanOrder(withOrder: model.id, withType: "done",withTip:"确认成功")
            }
            view.priceNumLabel.isHidden = true
            return view
        }
        if (model.status==status[3]&&model.confirm_good=="y"||model.status=="换货") {
            let nib = Bundle.main.loadNibNamed("NewShopOverOrderView", owner: nil, options: nil)
            let view = nib?.first as! NewShopOverOrderView
            view.cancelOrderBtn.whenTapped {
                 self.deleteOrCancanOrder(withOrder: model.id, withType: "d",withTip:"删除订单成功")
            }
            view.commentBtn.whenTapped({
//                评价物流
                 let vc = NewCommentShaiDanViewController()
                vc.orderModel = model
                self.navigationController?.pushViewController(vc, animated: true)
            })
            
            view.lookLogisticBtn.whenTapped({
                
            })
             return view
        }else{
          let footerView = UIView()
           return footerView
        }
        
    }
    
    func disView() {
        self.popView?.disMissView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let mdoel = orderModels[indexPath.section]
        
       
    }
    
    /*
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 1, animations: {
            view.layer.transform = CATransform3DMakeScale(1, 1, 1)
            
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 1, animations: {
            view.layer.transform = CATransform3DMakeScale(1, 1, 1)
            
        })
    }
    //cell动画
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 1, animations: {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
            
        })
    }
    
    */
//    MARK:删除火取消订单
    func deleteOrCancanOrder(withOrder order_id:String,withType type:String,withTip tip:String) {
//        let user_id  = ShareManager.shareInstance().userinfo.id
//        weak var weakSelf = self
//        HttpHelper.cancelOrder(withOrder_id: order_id, user_id: user_id, type: type, success: { (data) in
//
//            let dict = data! as NSDictionary
//            let status = dict["status"] as! String
//            let desc = dict["desc"] as! String
//            if (status == "0"){
//                Tool.showPromptContent(tip, on: weakSelf?.view)
//                self.perform(#selector(self.setTabelViewRefresh), with: nil, afterDelay: 1.0)
//
//            }else{
//                Tool.showPromptContent(desc, on: weakSelf?.view)
//            }
//        }) { (error) in
//            Tool.showPromptContent(error)
//        }
//
//
    }
}
