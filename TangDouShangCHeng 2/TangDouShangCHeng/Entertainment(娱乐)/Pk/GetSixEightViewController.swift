//
//  GetSixEightViewController.swift
//  TangDouShangCHeng
//
//  Created by 黎应明 on 2018/7/26.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class GetSixEightViewController: UITableViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    var page = 0
    @IBOutlet weak var upCollectionView: UICollectionView!
    
    var goodsData:[GoodsListInfo] = []
    var imageData:[String] = []
    @IBOutlet weak var goodScrollView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var goodCollectionView: UICollectionView!
    var timer:Timer?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTabelViewRefresh()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer=nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
       
        self.tableView.frame = CGRect(x: 0, y: 0, width: kWidth, height: kHeight)

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (kWidth-20)/2, height: 200)
        self.goodCollectionView.collectionViewLayout = layout
     
        self.goodCollectionView.backgroundColor = UIColor.clear
        self.goodCollectionView.showsHorizontalScrollIndicator = false
        self.goodCollectionView.showsVerticalScrollIndicator = false
        self.goodCollectionView.register(GoodsListCollectionViewCell.self, forCellWithReuseIdentifier: "goodCell")
        self.goodCollectionView.delegate = self
        self.goodCollectionView.dataSource = self
        
        headerView.width *= kWidth/375.0
       
        if kHeight == 812.0 {
           headerView.height += 144
             self.tableView.contentOffset = CGPoint(x: 0, y: -44)
        }else{
           headerView.height *= kWidth/375.0
        }
        
        self.tableView.tableHeaderView = headerView
        
        
       
    }
    
    func initTimer() {
         timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector:#selector(getListData), userInfo: nil, repeats: true)
    }

    @IBAction func rulerClick(_ sender: Any) {
        
        let vc = SixRulerViewController()
        vc.view.backgroundColor = UIColor.clear
        //设置model的样式
        vc.modalPresentationStyle = .custom
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(vc, animated: true, completion: nil)
    }
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //    MARK:获取猜你喜欢数据
    func getListData() {
        HttpHelper.getPKGoodsListWithOrder_(by_name: "now_people", order_by_rule: "desc", pageNum: "\(page)", limitNum: "0", success: { (resultDic) in
            self.hideRefresh()
            let dict = resultDic! as NSDictionary
            let status = dict["status"] as! String
            if status == "0"{
                self.handleloadListResult(resultDic: dict)
            }
        }) { (error) in
            self.hideRefresh()
            Tool.showPromptContent("网络出错了", on: self.view)
        }

    }
    
    func handleloadListResult(resultDic:NSDictionary) {
        let dic = resultDic["data"] as! NSDictionary
//        print("getPKGoodsListWithOrder_",dic)
        
        let goodArray = dic["goodsList"] as! NSArray
        if goodArray.count>0 {
            if goodsData.count>0&&page == 1 {
                self.goodsData.removeAll()
            }
            for dict in goodArray {
                let model = (dict as! NSDictionary).object(by: GoodsListInfo.self) as! GoodsListInfo
                self.goodsData.append(model)
//                self.imageData.append(model.good_header)
            }
        }
//        page+=1
        
        if timer == nil {
            self.initTimer()
        }else{
            print("????????????")
        }
        self.goodCollectionView.reloadData()
        
//        self.upCollectionView.reloadData()
    }
    
    
    
    //    MARK: - 上下刷新
    func setTabelViewRefresh() {
        weak var weakSelf = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.timer?.invalidate()
            self.timer=nil
            weakSelf?.getListData()
        })
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        weakSelf?.tableView.mj_header.isAutomaticallyChangeAlpha = true
        weakSelf?.tableView.mj_header.beginRefreshing()
        //        上拉刷新
        weakSelf?.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            
            self.hideRefresh()
        })
    
    }
    
    func hideRefresh() {
        if self.tableView.mj_footer.isRefreshing {
            self.tableView.mj_footer.endRefreshing()
        }
        if self.tableView.mj_header.isRefreshing {
            self.tableView.mj_header.endRefreshing()
            //            self.show = 1
        }
        
    }
    
   

    //    MARK:collectionDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.goodsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let info = self.goodsData[indexPath.row]
//        if collectionView == upCollectionView {
//           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upCell", for: indexPath) as! SixUpCell
//            cell.goodImageView.sd_setImage(with:  URL(string: info.good_header), placeholderImage: UIImage(named: "defaultImage"))
//            cell.goodNameLabel.text = info.good_name
//            cell.labelWidth.constant = cell.prollView.frame.size.width * CGFloat(Double(info.progress)!/100.0)
//            cell.joinBtn.tag = indexPath.row
//            cell.joinBtn.addTarget(self, action: #selector(gobuyVc(btn:)), for:.touchUpInside)
//            return cell
//        }else{
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "goodCell", for: indexPath) as! GoodsListCollectionViewCell
      
        cell.processView.layer.masksToBounds = true
        cell.processView.layer.cornerRadius = cell.processView.frame.size.height/2
        
       
        
        cell.processLabelWidth.constant = cell.processView.frame.size.width * CGFloat(Double(info.progress)!/100.0)
       
         cell.photoImage.sd_setImage(with:  URL(string: info.good_header), placeholderImage: UIImage(named: "defaultImage"))
         cell.titleLabel.text = info.good_name
         cell.addButton.tag = indexPath.row
         cell.addButton.addTarget(self, action: #selector(gobuyVc(btn:)), for:.touchUpInside)
         cell.priceButton.isHidden = true
        
        return cell;
//    }
}
    
    func gobuyVc(btn:UIButton) {
        
        let info = self.goodsData[btn.tag]
        let vc = GoodsDetailInfoViewController(nibName: "GoodsDetailInfoViewController", bundle: nil)
        vc.goodId = info.id
        vc.is_sixeight = "Y"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info = self.goodsData[indexPath.row]
       let vc = GoodsDetailInfoViewController(nibName: "GoodsDetailInfoViewController", bundle: nil)
        vc.goodId = info.id
        vc.is_sixeight = "Y"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    //MARK:tableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
