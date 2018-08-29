//
//  SclesViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2018/2/28.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class SclesViewController: BaseTableViewController {
    var flageLabel:UILabel?
    var flageCenterX:CGFloat = 0
    var leftCenterX:CGFloat = 0
    var rightCenterX:CGFloat = 0
    var page = 0
    var dataArray:NSMutableArray = []
    
    var btnSelectTag = 0
    var orderModels:[OrderModel] = []
    
    var flageTag:Int?{
        didSet{
            self.moveFlageLabel()
        }
    }
    var typeArray:NSMutableArray?{
        didSet{
//            self.getData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "退货售后"
        self.createHeaderView()
        self.tableView.frame = CGRect(x: 0, y: 30, width: kWidth, height: kHeight-30)
        self.flageTag = 0
//        self.getData()
        self.setTabelViewRefresh()
    }
    
    func createHeaderView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 30))
        let leftBtn = UIButton(frame: CGRect(x: 0, y: 0, width: kWidth/2, height: 30))
        leftBtn.setTitle("售后申请", for: .normal)
        leftBtn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        leftBtn.setTitleColor(UIColor(fromHexString: "666666"), for: .normal)
        self.leftCenterX = leftBtn.center.x
        self.flageCenterX = leftBtn.center.x
        leftBtn.whenTapped {
            self.flageCenterX = leftBtn.center.x
            self.flageTag = 0
            self.page = 1
//            self.tableView.reloadData()
            self.getData()
            
        }
        
        let rightBtn = UIButton(frame: CGRect(x: kWidth/2, y: 0, width: kWidth/2, height: 30))
        rightBtn.setTitleColor(UIColor(fromHexString: "666666"), for: .normal)
        rightBtn.setTitle("申请记录", for: .normal)
        rightBtn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        self.rightCenterX = rightBtn.center.x
        rightBtn.whenTapped {
            self.flageCenterX = rightBtn.center.x
            self.flageTag = 1
            self.page = 1
//            self.tableView.reloadData()
            self.getData()
            
        }
        let label = UILabel(frame: CGRect(x: 0, y: 28, width: 60, height: 2))
            label.center.x = leftBtn.center.x
        label.backgroundColor = UIColor.red
        self.flageLabel = label
        
        let lineLabel = UILabel(frame: CGRect(x: 0, y: 30, width: kWidth, height: 1))
        lineLabel.backgroundColor = UIColor(fromHexString: "F4F4F4")
        
        headerView.addSubview(lineLabel)
        headerView.addSubview(leftBtn)
        headerView.addSubview(rightBtn)
        headerView.addSubview(label)
        self.view.addSubview(headerView)
    }
    
    func moveFlageLabel() {
//        UIView.animate(withDuration: 0.1) {
            self.flageLabel?.center.x = self.flageCenterX
//        }
    }
    
    
    func getData() {
        weak var weakSelf = self
        var type = ""
        if self.flageTag == 0 {
            type = "可售后"
        }else{
            type = "申请记录"
        }
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
       print("handleloadResult",dic)
        let orderArr = dic["orderList"] as! NSArray
        if orderArr.count>0 {
            if orderModels.count>0&&page  == 1{
                orderModels.removeAll()
            }
        }else {
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
//     weakSelf?.tableView.mj_footer.isAutomaticallyHidden = true
     
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
        return self.orderModels.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let nib = Bundle.main.loadNibNamed("SimGoodCell", owner: nil, options: nil)
        let cell = nib?.first as! SimGoodCell
        cell.goodNumLabel.isHidden = true
        cell.goodColorLabel.isHidden = true
        cell.orderModel = self.orderModels[indexPath.section]
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 47
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 47))
        view.backgroundColor = UIColor.white
        let leftLabel = UILabel(frame: CGRect(x: 20, y: 20, width: kWidth/2-20, height: 17))
        let model = self.orderModels[section]
        if self.flageTag == 0 {
            leftLabel.text = "订单编号：\(model.order_num!)"
        }else{
            leftLabel.text = "服务单号：473847842"
        }
        leftLabel.textColor = UIColor(fromHexString: "666666")
        leftLabel.font = UIFont(name: "PingFangSC-Regular", size: 12)
        view.addSubview(leftLabel)
        
        let rightLabel = UILabel(frame: CGRect(x: kWidth/2, y: 20, width: kWidth/2-20, height: 17))
        if self.flageTag == 0 {
             rightLabel.text = "下单时间：\(model.create_time!)"
             rightLabel.textColor = UIColor(fromHexString: "#666666")
        }else{
             rightLabel.text = model.retoure_type
             rightLabel.textColor = UIColor(fromHexString: "E26650")
        }
       
        rightLabel.textAlignment = .right
//        rightLabel.textColor = UIColor(fromHexString: "666666")
        rightLabel.font = UIFont(name: "PingFangSC-Regular", size: 12)
        view.addSubview(rightLabel)
        
        let lineLabel = UILabel(frame: CGRect(x: 20, y: 47, width: kWidth-40, height: 1))
        lineLabel.backgroundColor = UIColor(fromHexString: "F4F4F4")
        view.addSubview(lineLabel)
        return view
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 70))
        view.backgroundColor = UIColor.white
        let model = self.orderModels[section]
        if self.flageTag == 0 {
           
            let headlineLabel = UILabel(frame: CGRect(x: 20, y: 0, width: kWidth-40, height: 1))
            headlineLabel.backgroundColor = UIColor(fromHexString: "F4F4F4")
            view.addSubview(headlineLabel)
            let applybtn = UIButton(frame: CGRect(x: kWidth-20-80, y: 10, width: 80, height: 30))
            applybtn.layer.masksToBounds = true
            applybtn.layer.cornerRadius = 3
            applybtn.layer.borderColor = UIColor(fromHexString: "#E26650").cgColor
            applybtn.layer.borderWidth = 1
            applybtn.setTitle("申请售后", for: .normal)
            applybtn.whenTapped({
                let vc = AfterSalesViewController()
                vc.orderModel = model
                self.navigationController?.pushViewController(vc, animated: true)
            })
            applybtn.setTitleColor(UIColor(fromHexString: "#E26650"), for: .normal)
            applybtn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)
            view.addSubview(applybtn)
        }else{
            let grView = UIView()
            if model.status == "已受理"{
                grView.frame = CGRect(x: 20, y: 0, width: kWidth-40, height: 56)
                let address = UILabel(frame: CGRect(x: 78, y: 30, width: 100, height: 20))
                address.text = "点击查看地址"
                address.whenTapped({
                    let addremodel = AfterAddressModel()
                    addremodel.name = model.consignee_name
                    addremodel.tell = model.consignee_tel
                    addremodel.address = model.consignee_address
                   
                    let vc = ResaveAddressViewController(nibName: "ResaveAddressViewController", bundle: nil)
                    vc.addressModel = addremodel
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                address.textColor = UIColor(fromHexString: "1F74D0")
                address.font = UIFont(name: "PingFangSC-Regular", size: 12)
                grView.addSubview(address)
            }else{
                grView.frame = CGRect(x: 20, y: 0, width: kWidth-40, height: 34)
            }
            grView.backgroundColor = UIColor(fromHexString: "F8F8F8")
            grView.alpha = 0.7
            grView.layer.masksToBounds = true
            grView.layer.cornerRadius = 3
            
            let statueLabel = UILabel(frame: CGRect(x: 10, y: (grView.size.height-20)/2, width: 50, height: 20))
            statueLabel.text = model.status
            statueLabel.textColor = UIColor(fromHexString: "1EAE1F")
            statueLabel.font = UIFont(name: "PingFangSC-Regular", size: 12)
            grView.addSubview(statueLabel)
            let line = UILabel(frame: CGRect(x: 66, y: (grView.size.height-14)/2, width: 1, height: 14))
            line.backgroundColor = UIColor(fromHexString: "999999")
             grView.addSubview(line)
            
            let titleLabel = UILabel(frame: CGRect(x: 78, y: 7, width: kWidth-40-78, height: 20))
            titleLabel.text = "您的服务单\(model.id!)\(model.status!)"
            titleLabel.font = UIFont(name: "PingFangSC-Regular", size: 12)
           
            grView.addSubview(titleLabel)
            
           
            
            view.addSubview(grView)
        }
       
        let lineLabel = UILabel(frame: CGRect(x: 0, y: 60, width: kWidth, height: 10))
        lineLabel.backgroundColor = UIColor(fromHexString: "F8F6F6")
        view.addSubview(lineLabel)
        return view
    }
    
    
    
    
    

}
