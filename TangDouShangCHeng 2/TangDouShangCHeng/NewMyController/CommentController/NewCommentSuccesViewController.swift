//
//  NewCommentSuccesViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2018/3/15.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class NewCommentSuccesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var goodTableView: UITableView!
    
    @IBOutlet weak var goShopBtn: UIButton!
    @IBOutlet weak var goUsedBtn: UIButton!

    @IBOutlet weak var desLabel: UILabel!
    var page = 1
    var goodsData:NSMutableArray = []
    var num:String = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评价成功"
        let leftControl = UIControl(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        leftControl.addTarget(self, action: #selector(back), for: .touchUpInside)
        let imageView  = UIImageView(frame: CGRect(x: 0, y: 13, width: 10, height: 18))
        imageView.image = UIImage(named: "shopBack")
        leftControl.addSubview(imageView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftControl)
        goodTableView.register(UINib(nibName: "NewShopHomeListCell", bundle: nil), forCellReuseIdentifier: "listCell")
        goodTableView.delegate = self
        goodTableView.dataSource = self
        self.getListData()
        desLabel.text = "感谢您的用心评价，\(num)小米已入账户"
        goShopBtn.whenTapped {
            let nav = BaseTabBarViewController()
            UIApplication.shared.keyWindow?.rootViewController = nil
            UIApplication.shared.keyWindow?.rootViewController = nav
        }
        
        goUsedBtn.whenTapped {
            
            if ShareManager.shareInstance().configure.show_qdc_status == "y"{
                self.navigationController?.navigationBar.barTintColor = UIColor.defaultRed()
                self.tabBarController?.tabBar.isHidden = true
                ShareManager.shareInstance().isEnterMK = true
                let entVC = EntTabBarViewController()
                self.navigationController?.pushViewController(entVC, animated: true)
            }else if ShareManager.shareInstance().configure.show_dwc_status == "y"{
                self.navigationController?.navigationBar.barTintColor = UIColor.defaultRed()
                self.tabBarController?.tabBar.isHidden = true
                let rotVC = RotaryViewController(nibName: "RotaryViewController", bundle: nil)
                self.navigationController?.pushViewController(rotVC, animated: true)
            }else{
                let vc = NewChangeViewController(tableViewStyle: .plain)
                
                self.navigationController?.pushViewController(vc!, animated: true)
            }
           
        }
    }
    
    func back() {
        let nav = BaseTabBarViewController()
        UIApplication.shared.keyWindow?.rootViewController = nil
        UIApplication.shared.keyWindow?.rootViewController = nav
    }

    //    MARK:获取猜你喜欢数据
    func getListData() {
        HttpHelper.getHomeListData(withPageNum: String(page), limitNum: "20", success: { (resultDic) in
            //            self.hideRefresh()
            let dict = resultDic! as NSDictionary
            
            let status = dict["status"] as! String
            if status == "0"{
                self.handleloadListResult(resultDic: dict)
            }
        }) { (error) in
            //            self.hideRefresh()
            Tool.showPromptContent("网络出错了", on: self.view)
        }
    }
    
    func handleloadListResult(resultDic:NSDictionary) {
        let dic = resultDic["data"] as! NSDictionary
        
        let goodArray = dic["goodsList"] as! NSArray
        if goodArray.count>0 {
            if goodsData.count>0&&page == 1 {
                self.goodsData.removeAllObjects()
            }
            for dict in goodArray {
                let model = (dict as! NSDictionary).object(by: HomeGoodModel.self) as! HomeGoodModel
                self.goodsData.add(model)
            }
        }
        page+=1
        //        let indexset = NSIndexSet(index: 4)
        //        //        let indexset1 = NSIndexSet(indexesIn: NSRange(location: 3, length: 2))
        self.goodTableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsData.count/2
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! NewShopHomeListCell
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapFuction(_:)))
        tap.numberOfTapsRequired = 1
        cell.leftView.tag = indexPath.row*2
        cell.leftModel = goodsData[indexPath.row*2] as? HomeGoodModel
        cell.leftView.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(cellTapFuction(_:)))
        tap1.numberOfTapsRequired = 1
        cell.rightView.tag = indexPath.row*2+1
        cell.rightModel = goodsData[indexPath.row*2+1] as? HomeGoodModel
        cell.rightView.addGestureRecognizer(tap1)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func cellTapFuction(_ tap:UITapGestureRecognizer)  {
        let goodModel = self.goodsData[(tap.view?.tag)!]
        let vc = NewShopGoodDetailViewController(tableViewStyle: .grouped)
        vc?.goodModel = goodModel as? HomeGoodModel
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 258
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed("HeaderView", owner: nil, options: nil)?.first as! HeaderView
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        view.rightLabel.text = "更多"
        view.leftLabel.text = "其他人再买"
        return view
    }

}
