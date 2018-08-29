//
//  ShopCarBuySucessViewController.swift
//  TangDouShangCHeng
//
//  Created by 黎应明 on 2018/7/3.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class ShopCarBuySucessViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var lookRecordBtn: UIButton!
    @IBOutlet weak var moneyLabel: UILabel!
  
    var leftArr:[String] = [
        "占天时地利人和",
        "四海财源聚宝地",
        "四海来财生意旺",
        "高居米豆财兴旺",
       " 门迎福路发鸿福",
        "生意兴隆好运旺旺",
        "福伴鸿运蒸蒸上",
        "八路进宝",
        "好运迎进八方宝",
        "喜居宝地千年旺",
        "今日赌运吉冲天",
        "天泰地泰三阳泰",
        "金玉满堂人财旺",
        "四海财源聚宝地",
        "年年过节年年富",
        "生意兴东南西北进宝",
        "虎啸龙吟展宏图",
        "一脚踢出穷鬼去"]
    var rightArr:[String] = [
             "取九州四海财宝",
             "九洲鸿运进门庭",
             "三江进宝财源广",
             "福照家门富生辉",
              "店有财神广进财",
             "财源广进天天发",
              "财随春雨滚滚来",
                   "四方招财",
             "米豆送来四季福",
              "福照家门万事兴",
             "明日四海皆臣服",
             "运兴人兴天地兴",
              "荣华富贵好运长",
            "九洲鸿运进门庭",
             "月月发财月月成",
           "鸿运开春夏秋冬发财",
              "盘马弯弓创新功",
             "双手迎进财神来"]
   var goodArray:[CarBuyScuessModel]?
   open var modelDic:NSDictionary?{
        didSet{
            var modelArr:[CarBuyScuessModel] = []
            let array = modelDic!["results"] as! NSArray
            for dic in array{
                let model = (dic as! NSDictionary).object(by: CarBuyScuessModel.self) as! CarBuyScuessModel
                if(model.fight_sucuss == "1"){
                    modelArr.append(model)
                }
               
            }
             self.goodArray = modelArr
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购买成功"
//        self.myTableView.layer.borderWidth = 1
//        self.myTableView.layer.borderColor = UIColor.orange.cgColor
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        self.myTableView.separatorStyle = .none
//        self.myTableView.showsHorizontalScrollIndicator = false
//        self.myTableView.showsVerticalScrollIndicator = false
        self.lookRecordBtn.layer.masksToBounds = true
        self.lookRecordBtn.layer.cornerRadius = self.lookRecordBtn.frame.size.height/2
        
        let money = String(modelDic!["all_price"] as! Int)
        self.moneyLabel.text = "已使用小米：\(money)小米"
        self.myTableView.register( UINib(nibName: "CarScuessCell", bundle: nil), forCellReuseIdentifier: "carCell")
        
        lookRecordBtn.whenTapped {
            let vc = DuoBaoRecordViewController(nibName: "DuoBaoRecordViewController", bundle: nil)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
 
        let arc = Int(arc4random()%UInt32(leftArr.count))
        leftLabel.text = leftArr[arc]
        rightLabel.text = rightArr[arc]
 
        let turnFadeInAnimation = CABasicAnimation(keyPath: "transform.rotation")
        turnFadeInAnimation.fromValue = 0
        turnFadeInAnimation.toValue =  Double.pi*2
        turnFadeInAnimation.duration = 4
        turnFadeInAnimation.repeatCount = 20
        turnFadeInAnimation.beginTime = CACurrentMediaTime() + 0.5
        turnFadeInAnimation.fillMode = kCAFillModeForwards
        turnFadeInAnimation.autoreverses = false
        turnFadeInAnimation.isRemovedOnCompletion = false
        bgImageView.layer.add(turnFadeInAnimation, forKey: "turnFadeInAnimation")
        
        let leftControl = UIControl(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        leftControl.addTarget(self, action: #selector(back), for: .touchUpInside)
        let imageView  = UIImageView(frame: CGRect(x: 0, y: 13, width: 10, height: 18))
        imageView.image = UIImage(named: "new_back")
        leftControl.addSubview(imageView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftControl)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    func back() {
        self.navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (goodArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carCell", for: indexPath) as! CarScuessCell
        let model = self.goodArray![indexPath.row]
        cell.goodImageView.sd_setImage(with: URL(string: model.good_header!), placeholderImage: nil)
        cell.goodNameLabel.text = model.good_name
        cell.goodPriLabel.text = "期号：\(model.good_period!)--参与人次：\(model.fight_num!)"
//        cell.goodBuyNumLabel.text = ""
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
