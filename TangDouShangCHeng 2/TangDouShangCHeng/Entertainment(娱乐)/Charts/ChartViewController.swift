//
//  ChartViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/11/2.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class ChartViewController: BaseTableViewController,ChartDelegate,SelectGoodsNumViewControllerDelegate {
   
    
    var startBtn:UIButton?
    var stopBtn:UIButton?
    var payBtn:UIButton?
    var showChart:Bool?
    var lookNum = 20
    var buyNum = 10
    var timer:Timer?
    var model:GoodsFightModel?
    var first:Bool = true
    var isSixEight:String?
    
//    var selfTitle:String = "走势图"
    
    public var isBuyNum:Bool = true
    
    public var good_fight_id:String?{
        didSet{
            self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(refreshNowNum), userInfo: nil, repeats: true)
            
        }
    }
    var dataArray:[ChartWinListModel] = []
    public var goodModel:GoodsDetailInfo?{
        didSet{
            self.getData()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
        self.timer = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        showChart = true
//        self.title = self.selfTitle
        //注册cell
        self.tableView.register(UINib(nibName: "ChartGoodCell", bundle: nil), forCellReuseIdentifier: "goodCell")
        self.tableView.register(UINib(nibName: "ChartCell", bundle: nil), forCellReuseIdentifier: "chartCell")
        self.tableView.register(UINib(nibName: "ChartListCell", bundle: nil), forCellReuseIdentifier: "chartListCell")
        self.tableView.register(UINib(nibName: "WinChartListCell", bundle: nil), forCellReuseIdentifier: "winChartListCell")
        self.tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-54)
        self.createFooter()
      
    }
    
    func refreshNowNum() {
        HttpHelper.getChartGoodsInfoDat(self.good_fight_id, success: { (data) in
            let dic = data! as NSDictionary
            let status:String = dic["status"]! as! String
            if status == "0"{
//                 print("data",data)
                 let dict = dic["data"] as! NSDictionary
                  let now = dict["now_people"] as! String
//                print("lalalalala",now);
                if self.goodModel?.now_people == now{
                    
                }else{
                    if now == "-1"||now == self.goodModel?.need_people{
                        
                        self.timer?.invalidate()
                        self.timer = nil
                    }
                    self.goodModel?.now_people = dict["now_people"] as! String
               
                  let inset = NSIndexSet(indexesIn:  NSMakeRange(1, 3))
                    self.tableView.reloadSections(inset as IndexSet, with: .automatic)
                }
                
            }
        }) { (error) in
             print(error?.description as Any)
        }
    }
    
    func getData() {
        HttpHelper.trendChartGoods(goodModel?.good_id, success: { (data) in
            let dic = data! as NSDictionary
            let status:String = dic["status"]! as! String
            if status == "0"{

                let dicArr = dic["data"] as! NSArray
                for dic in dicArr{
                    print("dic",dic)
                    let model = (dic as! NSDictionary).object(by: ChartWinListModel.self)  as! ChartWinListModel
                    model.need_people = self.goodModel?.need_people
//                    self.loadDuoBaoNum(good_id: model.goods_fight_id!, user_id: model.win_user_id!)
                    self.dataArray.append(model)
                }
            }else{
                Tool.showPromptContent("暂无数据", on: self.view)
            }
            self.tableView.reloadData()
           
            
        }) { (error) in
            print(error?.description as Any)
        }
    }
    
    func loadDuoBaoNum(good_id:String,user_id:String) {
        HttpHelper.loadDuoBaoLuckNum(withGoodsId: good_id, user_id: user_id, success: { (data) in
            let dict = data! as NSDictionary
            print("loadDuoBaoNum",dict)
        }) { (error) in
            
        }
    }
    
    func createFooter() {
        let footerView = UIView()
        
//        if #available(iOS 11.0, *) {
//            footerView.frame =  CGRect(x: 0, y: self.view.frame.size.height-50-64-40, width:UIScreen.main.bounds.width , height:50)
//        } else {
             footerView.frame =  CGRect(x: 0, y: self.view.frame.size.height-50-64, width:UIScreen.main.bounds.width , height:50)
//        }
        startBtn = UIButton(frame: CGRect(x: 0, y: 0, width: footerView.size.width/3, height: 50))
        startBtn?.backgroundColor = UIColor(fromHexString: "999999")
        startBtn?.alpha = 0.7
        startBtn?.setTitle("开启监控", for: .normal)
        startBtn?.isUserInteractionEnabled = false
        startBtn?.addTarget(self, action: #selector(startFunc), for: .touchUpInside)
        startBtn?.setTitleColor(UIColor.white, for: .normal)
        footerView.addSubview(startBtn!)
        
        stopBtn = UIButton(frame: CGRect(x: footerView.size.width/3, y: 0, width: footerView.size.width/3, height: 50))
//        stopBtn?.isUserInteractionEnabled = false
        stopBtn?.alpha = 0.8
        stopBtn?.backgroundColor = UIColor(fromHexString: "F18E7C")
        stopBtn?.setTitle("停止监控", for: .normal)
        stopBtn?.setTitleColor(UIColor.white, for: .normal)
        stopBtn?.addTarget(self, action: #selector(stopFunc), for: .touchUpInside)
        footerView.addSubview(stopBtn!)
        
        payBtn = UIButton(frame: CGRect(x: 2*footerView.size.width/3, y: 0, width: footerView.size.width/3, height: 50))
        payBtn?.backgroundColor = UIColor(fromHexString: "ED533B")
        payBtn?.setTitleColor(UIColor.white, for: .normal)
        payBtn?.setTitle("立即下单", for: .normal)
        payBtn?.addTarget(self, action: #selector(payBtnFunc), for: .touchUpInside)
        footerView.addSubview(payBtn!)
        self.view.addSubview(footerView)
    }
    
    func startFunc() {
        stopBtn?.isUserInteractionEnabled = true
        stopBtn?.backgroundColor = UIColor(fromHexString: "F18E7C")
        startBtn?.isUserInteractionEnabled = false
        startBtn?.backgroundColor = UIColor(fromHexString: "999999")
        self.timer?.fire()
        self.showChart = true
        self.tableView.reloadData()
        
    }
    func stopFunc() {
        startBtn?.isUserInteractionEnabled = true
        startBtn?.backgroundColor = UIColor(fromHexString: "F18E7C")
        stopBtn?.isUserInteractionEnabled = false
        stopBtn?.backgroundColor = UIColor(fromHexString: "999999")
        self.showChart = false
        self.timer?.invalidate()
        self.tableView.reloadData()
        
    }
    func payBtnFunc(){
        if !Tool.islogin() {
            Tool.loginWith(animated: true, viewController: nil)
            return
        }
        
        if isSixEight == "Y"||(self.goodModel?.good_name.contains("PK"))! {
            let num = Int32(Int32((self.goodModel?.need_people)!)!/3)
            self.selectGoodsNum(num, goodsInfo: self.goodModel)
        }else{
        let vc = SelectGoodsNumViewController(nibName: "SelectGoodsNumViewController", bundle: nil)
        vc.delegate = self
        self.goodModel?.buyNum = Int32(self.buyNum);
        vc.reloadDetailInfoOnce(self.goodModel)
        self.definesPresentationContext = true
        vc.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        if(self.navigationController?.viewControllers.first?.isKind(of: PayResultViewController.self))!{
            self.navigationController?.present(vc, animated: true, completion: nil)
        }else{
            let rootVC = UIApplication.shared.keyWindow?.rootViewController
            rootVC?.present(vc, animated: true, completion: nil)
            
        }
        }
        
    }
    
    func selectGoodsNum(_ num: Int32, goodsInfo: GoodsDetailInfo!) {

        let data = goodsInfo.dictionary()
        let dict = NSMutableDictionary(dictionary: data!)
        dict.setValue(num, forKey: "Crowdfunding")
        dict.setValue((goodsInfo.good_single_price as NSString).intValue, forKey: "price")
        
        let vc = EntOrderViewController.create(withData: dict as! [AnyHashable : Any])
        self.navigationController?.pushViewController(vc!, animated: true)
//        let magicMove = MagicMoveTransition()
//        self.navigationController?.pushViewController(vc, animated: true, transition: magicMove)
    }
    
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != 3 {
            return 1
        }else{
            return 1
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "goodCell", for: indexPath) as! ChartGoodCell
            cell.goodHeaderimage.sd_setImage(with:URL(string: (self.goodModel?.good_header)!) , completed: nil)
            cell.goodNameLabel.text = self.goodModel?.good_name
            let str = (self.goodModel?.need_people)!
            cell.needNumLabel.text = "总需：\(str)次"
            cell.selectionStyle = .none
            return cell
            
        }else if indexPath.section == 1{
        let cell = tableView.dequeueReusableCell(withIdentifier: "chartCell", for: indexPath) as! ChartCell
        cell.selectionStyle = .none
            
            if dataArray.count>0{
            cell.isBuyNum = self.isBuyNum
            cell.goodModel = self.goodModel
            let model = dataArray.first
                let lastStr:NSString = "第\((model?.good_period)!)期：\((model?.nick_name)!)购买了\((model?.buy_time)!) 次" as NSString
                let last:NSString = "\((model?.buy_time)!) " as NSString
                let attributeLast = NSMutableAttributedString.init(string: lastStr as String)
                attributeLast.addAttributes([NSForegroundColorAttributeName: UIColor.red], range:lastStr.range(of: last as String))
            cell.lastDesLabel.attributedText = attributeLast
            }
            cell.delegate = self
            cell.chartModels = dataArray
            cell.good_fight_id = self.good_fight_id
            cell.lookNum = lookNum
            if first{
                first = false
                if ((goodModel?.need_people)! as NSString).integerValue > 1000{
                    buyNum = Int32(100) < (self.goodModel?.remainderCount())! ? 100 :
                        Int((self.goodModel?.remainderCount())!)
                }else{
                    buyNum = Int32(10) < (self.goodModel?.remainderCount())! ? 10 :
                        Int((self.goodModel?.remainderCount())!)
                }
            }
           
            if(goodModel?.good_name.hasPrefix("PK"))!{
                buyNum = Int((goodModel?.need_people)!)!/3
                
            }
            
            cell.buyNum = buyNum
            cell.isShowChart = self.showChart!
            
            cell.joinLabel.whenTapped({
               let vc = ChartRelistViewController()
                vc.goodId = self.good_fight_id
                vc.goodsDetailInfo = self.goodModel
                self.navigationController?.pushViewController(vc, animated: true)

            })
            return cell
            
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "chartListCell", for: indexPath) as! ChartListCell
            cell.selectionStyle = .none
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "winChartListCell", for: indexPath) as! WinChartListCell
            cell.selectionStyle = .none
            if self.showChart!{
                var listModel:[ChartWinListModel] = []
                for (i,item) in self.dataArray.enumerated(){
                    if i < lookNum{
                       listModel.append(item)
                    }
                }
                cell.listModel = listModel
            }else{
                cell.listModel = []
            }
            return cell
        }
    }
    
    //MARK: - ChartDelegate
    func sendBuyNum(num: Int) {
        print("buynum\(num)")
        self.buyNum = num
        if Int32(num) == self.goodModel?.remainderCount() {
             Tool.showPromptContent("已经达到可购买最大值", on: self.view)
        }
        self.tableView.reloadData()
    }
    
    func sendChartNum(num: Int) {
       
        lookNum = num
        if num == 30 {
            Tool.showPromptContent("已经达到监控最大值", on: self.view)
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
    }
    
    func startTimer() {
          self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(refreshNowNum), userInfo: nil, repeats: true)
    }
   
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       
            return 0
    }
    
   override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 140
        }else if indexPath.section == 1{
            return 544
        }else if indexPath.section == 2{
            return 25
        }else{
            return 250
        }
    }
    
   
   
    
}
