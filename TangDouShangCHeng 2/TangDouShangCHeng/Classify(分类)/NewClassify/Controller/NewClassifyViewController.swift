//
//  NewClassifyViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2018/3/27.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit
class NewClassifyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    var leftTableView:UITableView?
    var rifhtCollection:UICollectionView?
    var leftArr:[Any] = []
    var selectTag = 0
    var dataArrary:NSMutableArray?
    var page = 1
    var searchBar:MySearchBar?
    var show = 0
    var searchView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataArrary = NSMutableArray()
        self.createSearchBar()
        if Tool.islogin(){
            leftArr = ShareManager.shareInstance().classifyData.reversed()
        }else{
            leftArr = [];
        }
        
        let idArray:[String] = ["100209","100210","100214","100211","100214"];
        let nameArray:[String] = ["手机","电脑","零食","坚果","音响"]
        if leftArr.count == 0{
            for (i,name) in nameArray.enumerated(){
                let model = GoodTypeModel()
                model.id = idArray[i]
                model.goods_type_name = name
                model.goods_type_header = ""
                model.remark = ""
                leftArr.append(model)
            }
        }
        self.createLeftTableView()
        self.createCollectionView()
        self.setTabelViewRefresh()
    }
    
    
    func createSearchBar(){
        var sy:CGFloat = 0
        if kHeight == 812.0 {
            sy = 24
        }else{
            sy = 10
        }
        let searchView = UIView(frame: CGRect(x: 0, y: sy, width: kWidth, height: 44))
        searchView.backgroundColor = UIColor.clear
        self.searchBar = MySearchBar(frame: CGRect(x: 5, y: 8, width: kWidth-55, height: 36))
        searchView.addSubview(searchBar!)
//        self.searchBar?.isUserInteractionEnabled = false
        self.searchBar?.placeholder = ""
        self.searchBar?.delegate = self
        // 去除 searchBar 上下两条黑线
        let barimg = self.searchBar?.subviews.first?.subviews.first
        barimg?.layer.borderWidth = 1
        barimg?.layer.borderColor = UIColor.clear.cgColor
        self.searchBar?.backgroundColor = UIColor.clear
        self.searchBar?.barTintColor = UIColor.white
        
        
        let searchField = self.searchBar?.value(forKey: "_searchField") as! UITextField
        searchField.backgroundColor = UIColor.white
        searchField.font = UIFont.systemFont(ofSize: 12)
        searchField.layer.masksToBounds = true
        searchField.layer.cornerRadius = 15
        searchField.layer.borderWidth = 1
        searchField.layer.borderColor = UIColor(fromHexString: "e6e6e6").cgColor
        let chatView = UIView(frame: CGRect(x: kWidth-20-30, y: 0, width: 50, height: 44))
        let btn = UIButton(frame: CGRect(x:0, y:5, width: 30, height: 30))
        btn.setImage(UIImage(named:"chat-black"), for: .normal)
        
//        btn.whenTapped {
//            let vc  = XiaoXiViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        chatView.addSubview(btn)
      
        searchView.addSubview(chatView)
        self.navigationItem.titleView = searchView
        self.searchView = searchView
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let vc = LLSearchResultViewController()
        vc.historyArray = ["iPhone","oppo","vivo","mac","ipad","江中猴姑米稀"]
        vc.hotArray = ["apple","哈哈哈","23456"]

//        let magicMove = MagicMoveTransition()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

    }

    
    
    
    func getTableData() {
        HttpHelper.getHttpWithUrlStr(URL_HomeBasics, success: { (data) in
            let dict = data! as NSDictionary
            let status = dict["status"] as! String
            if status == "0"{
                self.loadTableData(dict: dict)
            }
        }) { (error) in
        Tool.showPromptContent("网络出错了")
        }
    }
    
    func loadTableData(dict:NSDictionary) {
        let dic = dict["data"] as! NSDictionary
        let tabArr = dic["goodsTypeList"] as! NSArray
        print("loadTableData>>>>>>>>",dic)
        if tabArr.count > 0 {
            var dataArr:[Any] = []
            for dataDic in tabArr{
                let modelDic = dataDic as! NSDictionary
                let model = modelDic.object(by: GoodTypeModel.self) as! GoodTypeModel
                dataArr.append(model)
            }
            self.leftArr = dataArr
            ShareManager.shareInstance().classifyData = dataArr
        }
        self.leftTableView?.reloadData()
    }

    
    func getCollectionData() {
        let model = leftArr[selectTag] as! GoodTypeModel
        HttpHelper.getSearchIDData(withID: model.id, pageNum: "\(self.page)", limitNum: "20", success: { (data) in
            let dict = data! as NSDictionary
           self.hideRefresh()
            let status = dict["status"] as! String
            if status == "0"{
                self.loadCollectionData(dict: dict)
            }
        }) { (error) in
           self.hideRefresh()
        }
    }

    
//    func getCollectionData() {
//        let model = leftArr[selectTag] as! GoodTypeModel
//        HttpHelper.getSearchKeyData(withKeyWord: model.goods_type_name,success: { (data) in
//            let dict = data! as NSDictionary
//            self.hideRefresh()
//            let status = dict["status"] as! String
//            if status == "0"{
//                self.loadCollectionData(dict: dict)
//            }
//        }) { (error) in
//            self.hideRefresh()
//        }
//    }
    func loadCollectionData(dict:NSDictionary) {
        let dic = dict["data"] as! NSDictionary
        print("getCollectionData",dic)
        let collArr = dic["goodsTypeList"] as! NSArray
        if page == 1{
            self.dataArrary?.removeAllObjects()
        }
        if collArr.count > 0 {
            
            for dataDic in collArr{
                
                let modelDic = dataDic as? NSDictionary
                if modelDic != nil{
                    let model = modelDic?.object(by: HomeGoodModel.self) as! HomeGoodModel
                    self.dataArrary?.add(model)
                    
                }
            }
            
        }
        self.page += 1
        self.rifhtCollection?.reloadData()
    }
    
    func createLeftTableView() {
        self.leftTableView = UITableView(frame: CGRect(x: 0, y: 0, width: 96, height:kHeight-64-44))
        leftTableView?.backgroundColor = UIColor(fromHexString: "f7f7f7")
        self.leftTableView?.delegate = self
        self.leftTableView?.dataSource = self
        self.leftTableView?.separatorStyle = .none
        self.leftTableView?.register(UINib(nibName: "LeftTableCell", bundle: nil)
, forCellReuseIdentifier: "tabCell")
        self.view.addSubview(self.leftTableView!)
    }
    
    func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let width = (kWidth-96)/2
        layout.itemSize = CGSize(width: width, height: 248)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
       
        self.rifhtCollection = UICollectionView(frame:CGRect(x: 96, y: 0, width: kWidth-96, height: kHeight-64-44), collectionViewLayout: layout)
        self.rifhtCollection?.backgroundColor = UIColor.white
        self.rifhtCollection?.dataSource = self
        self.rifhtCollection?.delegate = self
        self.rifhtCollection?.register(UINib(nibName: "NewShopCollectionCell", bundle: nil)
, forCellWithReuseIdentifier: "collCell")
        self.view.addSubview(self.rifhtCollection!)
    }
   
    //    MARK:tableDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leftArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tabCell", for: indexPath) as! LeftTableCell
        let model = leftArr[indexPath.row] as! GoodTypeModel
//        let model = dict.object(by: GoodTypeModel.self) as! GoodTypeModel
        cell.titleLabel.text = model.goods_type_name
        cell.selectionStyle = .none
        if indexPath.row == 0&&selectTag == 0 {
            cell.flageLabel.isHidden = false
            cell.titleLabel.textColor = UIColor.red
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for cell  in tableView.visibleCells {
            let leftCell = cell as! LeftTableCell
            if leftCell.isSelected{
                leftCell.flageLabel.isHidden = false
                leftCell.titleLabel.textColor = UIColor.red
                leftCell.backgroundColor = UIColor.white
                leftCell.titleLabel.backgroundColor = UIColor.white
            }else{
                leftCell.flageLabel.isHidden = true
                leftCell.titleLabel.textColor = UIColor(fromHexString: "333333")
                leftCell.backgroundColor = UIColor(fromHexString: "f7f7f7")
                leftCell.titleLabel.backgroundColor = UIColor(fromHexString: "f7f7f7")
            }
        }
        self.selectTag = indexPath.row

         let model = leftArr[indexPath.row] as! GoodTypeModel
        print("leftArr[indexPath.row] as! GoodTypeModel",model.id)
        self.setTabelViewRefresh()

    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
   
    
    //    MARK:collectionDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataArrary?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath) as! NewShopCollectionCell
        let model = dataArrary![indexPath.row] as! HomeGoodModel
        cell.goodModel = model
//        cell.titleLabel.text = "\(indexPath.row+self.selectTag)"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArrary![indexPath.row] as! HomeGoodModel
        let vc = GoodDetailViewController(tableViewStyle: .grouped)
        vc?.goodModel = model

        self.navigationController?.hh_pushViewController(vc!, style:AnimationStyleRippleEffect)
        

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    //    MARK: - 上下刷新
    func setTabelViewRefresh() {
        weak var weakSelf = self
        self.rifhtCollection?.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
//            weakSelf?.getShowData()
            weakSelf?.getCollectionData()
        })
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        weakSelf?.rifhtCollection?.mj_header.isAutomaticallyChangeAlpha = true
        weakSelf?.rifhtCollection?.mj_header.beginRefreshing()
        //        上拉刷新
        weakSelf?.rifhtCollection?.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            weakSelf?.getCollectionData()
            self.hideRefresh()
        })
        weakSelf?.rifhtCollection?.mj_footer.isHidden = true
        
    }
    
    func hideRefresh() {
        if (self.rifhtCollection?.mj_footer.isRefreshing)! {
            self.rifhtCollection?.mj_footer.endRefreshing()
        }
        if (self.rifhtCollection?.mj_header.isRefreshing)! {
            self.rifhtCollection?.mj_header.endRefreshing()
            //            self.show = 1
        }
        
    }
    
   
}
