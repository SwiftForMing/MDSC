//
//  NewChangeViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2018/2/24.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class NewChangeViewController: BaseTableViewController {

    var rideoCell:QuanWanKXCell?
    var banncerCell:BannerTableViewCell?
    var bannerArray:NSMutableArray = []
    var radioArray:NSMutableArray = []
    var isBannerTwo:Bool = false
    var bannerListFlag:String?
    var page = 0
    var goodsData:NSMutableArray = []
    var goodsModel:NSMutableArray = []
    var beanLabel:UILabel?
    var bgImage:UIImageView?
    var addImg:UIImageView?
    var isEnt = false
    //    var popView:PopView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController?.navigationBar.barTintColor = UIColor.white
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //注册cell
        self.title = "兑换好物"
        
        let leftControl = UIControl(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        leftControl.addTarget(self, action: #selector(back), for: .touchUpInside)
        let imageView  = UIImageView(frame: CGRect(x: 0, y: 13, width: 10, height: 18))
       
        if isEnt {
             imageView.image = UIImage(named: "new_back")
        }else{
             imageView.image = UIImage(named: "shopBack")
        }
        leftControl.addSubview(imageView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftControl)
        
        let rightItemControl = UIControl(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        rightItemControl.addTarget(self, action: #selector(self.delayMethod), for: .touchUpInside)
        let label = UILabel(frame: CGRect(x: 0, y: 13, width: 60, height: 18))
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "兑换列表"
        if isEnt {
            label.textColor = UIColor.white
        }else{
            label.textColor = UIColor.black
        }
        
        label.textAlignment = .right
        rightItemControl.addSubview(label)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightItemControl)
    
        self.tableView.frame = CGRect(x: 0, y: 0, width: kWidth, height: kHeight)
        self.tableView.backgroundColor = UIColor(fromHexString: "F8F6F6")
        tableView.register(UINib(nibName: "NewShopHomeListCell", bundle: nil), forCellReuseIdentifier: "listCell")
        tableView.register(UINib(nibName: "BannerTableViewCell", bundle: nil), forCellReuseIdentifier: "bannerCell")
        tableView.register(BannerTableViewCell.self, forCellReuseIdentifier: "bannerCell")
        
        tableView.register(UINib(nibName: "SelectCell", bundle: nil), forCellReuseIdentifier: "selectCell")
        
        tableView.register(UINib(nibName: "RecommendedCell", bundle: nil), forCellReuseIdentifier: "recommendedCell")
        tableView.register(UINib(nibName: "QuanWanKXCell", bundle: nil), forCellReuseIdentifier: "kxCell")
        
        self.setTabelViewRefresh()
        
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
   
    
    
    func getBeanGood() {
        HttpHelper.getQuanBeanDate(withPageNum: "\(page)", limitNum: "20", success: { (data) in
            self.hideRefresh()
            let dict = data! as NSDictionary
            let status = dict["status"] as! String
            if status == "0"{
                self.handleloadListResult(resultDic: dict)
            }
        }) { (error) in
            Tool.showPromptContent(error)
        }
    }
    
    func handleloadListResult(resultDic:NSDictionary) {
        
        let dic = resultDic["data"] as! NSDictionary
        
        print("handleloadListResult.........",dic)
        let goodArray = dic["beanGoodsList"] as! NSArray
        if goodArray.count>0 {
            if goodsData.count>0&&page == 1 {
                self.goodsData.removeAllObjects()
                self.goodsModel.removeAllObjects()
            }
            for dict in goodArray {
                let model = (dict as! NSDictionary).object(by: GoodsFightModel.self) as! GoodsFightModel
                self.goodsData.add(model)
                let goodmodel = (dict as! NSDictionary).object(by: HomeGoodModel.self) as! HomeGoodModel
                goodmodel.id = model.good_id
                self.goodsModel.add(goodmodel)
            }
        }
        page+=1
//        let indexset = NSIndexSet(index: 3)
        self.tableView.reloadData()
        
    }
    
    
    
    //    MARK: - 上下刷新
    func setTabelViewRefresh() {
        weak var weakSelf = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            weakSelf?.getBeanGood()
        })
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        weakSelf?.tableView.mj_header.isAutomaticallyChangeAlpha = true
        weakSelf?.tableView.mj_header.beginRefreshing()
        //        上拉刷新
        weakSelf?.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            weakSelf?.getBeanGood()
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
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.goodsData.count%2 == 0{
            return self.goodsData.count/2
        }else{
            return (self.goodsData.count/2)+1
        }
    }
   
    
   
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! NewShopHomeListCell
            cell.selectionStyle = .none
            let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapFuction(_:)))
            tap.numberOfTapsRequired = 1
            cell.leftView.tag = indexPath.row*2
            cell.leftFightModel = self.goodsData[indexPath.row*2] as? GoodsFightModel
            cell.leftView.addGestureRecognizer(tap)
            //当数据为单数是隐藏右边View
            if ((indexPath.row*2)==self.goodsData.count-1 && !((self.goodsData.count%2)==0)){
                cell.rightView.isHidden = true
            }else{
                cell.rightView.isHidden = false
                let tap1 = UITapGestureRecognizer(target: self, action: #selector(cellTapFuction(_:)))
                tap1.numberOfTapsRequired = 1
                cell.rightView.tag = indexPath.row*2+1
                cell.rightFightModel = self.goodsData[indexPath.row*2+1] as? GoodsFightModel
                cell.rightView.addGestureRecognizer(tap1)
            }
            
            return cell
        
    }
    
    func cellTapFuction(_ tap:UITapGestureRecognizer)  {
        let model = self.goodsData[(tap.view?.tag)!] as! GoodsFightModel
        let goodmodel = self.goodsModel[(tap.view?.tag)!] as! HomeGoodModel
        self.purchase(fightModel:model,goodModel: goodmodel)
    }
    
    
    
    func purchase(fightModel model:GoodsFightModel,goodModel goodmodel:HomeGoodModel) {
//        if !Tool.islogin() {
//            Tool.loginWith(animated: true, viewController: nil)
//            return
//        }
//
//        let userInfo = ShareManager.shareInstance().userinfo
//        let remainerThriceCoin = Int32((userInfo?.user_money)!)
//        let neededThriceCoin = model.remainderCoin()
        
//        if neededThriceCoin>remainerThriceCoin {
//            let message = "小米余额不足，购买总需\(neededThriceCoin)小米～"
//            let alert = UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "好的")
//            alert.show()
//            return;
//        }
//        weak var weakSelf = self
//
//        if model.extra_money == "0" {
//            let message = "确认兑换，总需\(neededThriceCoin)小米～"
//            let alert = UIAlertController(title: "确认兑换", message: message, preferredStyle: UIAlertControllerStyle.alert)
//
//            let alertConfirm = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (alertConfirm) -> Void in
//                // 点击确定时
//                weak var weakSelf = self
//                HttpHelper.purchase(withThriceCoin: model.id, goodsID: model.good_id, thriceCoin: Int32(model.good_single_price)!, success: { (data) in
//                    let dict = data! as NSDictionary
//                    let status = dict["status"] as! String
//                    let desc = dict["desc"] as! String
//                    if (status == "0"){
//                        Tool.showPromptContent("兑换成功", on: weakSelf?.view)
//                        self.setTabelViewRefresh()
//                        Tool.getUserInfo()
//                        self.perform(#selector(self.delayMethod), with: nil, afterDelay: 1.0)
//                    }else{
//                        Tool.showPromptContent(desc, on: weakSelf?.view)
//                    }
//                }) { (error) in
//                    Tool.showPromptContent("兑换失败")
//                }
//            }
//            alert.addAction(alertConfirm)
//            let cancle = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (cancle) -> Void in
//
//            }
//            alert.addAction(cancle)
//            // 提示框弹出
//            present(alert, animated: true) { () -> Void in
//
//            }
    
//        }else{
//            let vc = DoneChangeViewController(nibName: "DoneChangeViewController", bundle: nil)
//            vc.model = model
//            vc.goodModel = goodmodel
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        
    }
    
    
    func delayMethod(){
        
//        let vc = ZJRecordViewController(nibName: "ZJRecordViewController", bundle: nil)
//        vc.is_happybean_goods = "1"
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 248
    }
   
    
    
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = UIView()
//        if section == 2 {
//            view.frame = CGRect(x: 0, y: 0, width: kWidth, height: 10)
//            view.backgroundColor = UIColor(fromHexString: "F8F6F6")
//
//        }else{
//            view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//
//        }
//        return view
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let view = Bundle.main.loadNibNamed("HeaderView", owner: nil, options: nil)?.first as! HeaderView
//        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
//        view.rightLabel.text = ""
//        if section == 3 {
//            view.leftLabel.text = "兑换好物"
//        }
//
//
//        return view
//    }
//
   
  
    

}
