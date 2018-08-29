//
//  NewShopHomeViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/13.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewShopHomeViewController: BaseTableViewController,CycleScrollViewDelegate,CycleScrollViewDataSource,NewBaseCollectionDelegate,UISearchBarDelegate {
    
    var banncerCell:BannerTableViewCell?
    var bannerArray:NSMutableArray = []
    var isBannerTwo:Bool = false
    var bannerListFlag:String?
    var page = 0
    
    var goodsData:NSMutableArray = []
    var recommendDataArray:NSMutableArray = []
    
    var leftReModel:RecommendModel?
    var rightReModel:RecommendModel?
    var secondArray:NSMutableArray = []
    var searchBar:MySearchBar?
    var show = 0
    var searchView:UIView?
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //注册cell
        self.title = "首页"
        self.hidenLeftBarButton()
        self.tableView.backgroundColor = UIColor.white
        self.createSearchBar()
        var ty:CGFloat = 0
        if kHeight == 812.0 {
            ty = -44
        }else{
            ty = -20
        }
        
        self.tableView.frame = CGRect(x: 0, y: ty, width: kWidth, height: kHeight-30)
        tableView.register(UINib(nibName: "NewShopHomeListCell", bundle: nil), forCellReuseIdentifier: "listCell")
        tableView.register(UINib(nibName: "BannerTableViewCell", bundle: nil), forCellReuseIdentifier: "bannerCell")
        tableView.register(BannerTableViewCell.self, forCellReuseIdentifier: "bannerCell")

        tableView.register(UINib(nibName: "SelectCell", bundle: nil), forCellReuseIdentifier: "selectCell")
        
        tableView.register(UINib(nibName: "RecommendedCell", bundle: nil), forCellReuseIdentifier: "recommendedCell")
//        self.getShowData()
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
        let chatView = UIView(frame: CGRect(x: kWidth-20-30, y: 12, width: 50, height: 44))
        let btn = UIButton(frame: CGRect(x: 10, y: 0, width: 18, height: 18))
//        btn.centerY = (self.searchBar?.centerY)!
        btn.setImage(UIImage(named:"chat"), for: .normal)
        chatView.whenTapped {
//         let vc  = XiaoXiViewController()
//          self.navigationController?.pushViewController(vc, animated: true)
        }
        chatView.addSubview(btn)
        let label = UILabel(frame: CGRect(x: 6, y: 18, width: 25, height: 10))
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "消息"
        chatView.addSubview(label)
        searchView.addSubview(chatView)
        self.view.addSubview(searchView)
        self.searchView = searchView
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        self.searchBar?.showsCancelButton = true
//        searchBar.becomeFirstResponder()
        searchBar.resignFirstResponder()
        let vc = LLSearchResultViewController()
        vc.historyArray = ["iPhone","oppo","vivo","mac","ipad","江中猴姑米稀"]
        vc.hotArray = ["apple","哈哈哈","23456"]
        self.navigationController?.pushViewController(vc, animated: true)
//        let magicMove = MagicMoveTransition()
//        self.navigationController?.pushViewController(vc, animated: true, transition: magicMove)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }


    
    func getShowData() {
        weak var weakSelf = self
        
        HttpHelper.getHttpWithUrlStr(URL_HomeBasics, success: { (data) in
            self.hideRefresh()
            let dict = data! as NSDictionary
            
            let status = dict["status"] as! String
            if status == "0"{
                weakSelf?.handleloadResult(dict: dict)
                
            }
        }) { (error) in
            self.hideRefresh()
            Tool.showPromptContent(error, on: weakSelf?.view)

        }
        
    }

    func handleloadResult(dict:NSDictionary) {
        let data = dict["data"] as! NSDictionary
        let goodsArray = data["goodsTypeList"] as? NSArray
        let typeArray:NSMutableArray = []
        if ((goodsArray != nil))&&(goodsArray!.count) > 0 {
            for dic in goodsArray!{
                let dict = dic as! NSDictionary
                let model = dict.object(by: GoodTypeModel.self) as! GoodTypeModel
                typeArray.add(model)
            }
            ShareManager.shareInstance().classifyData = typeArray as! [Any]
        }else{
            ShareManager.shareInstance().classifyData = []
        }
       
        let banArray = data["advertisementList"] as? NSArray

        if ((banArray != nil))&&(banArray!.count) > 0 {
            if bannerArray.count>0{
                bannerArray.removeAllObjects()
            }
            for dic in banArray!{
                let info = (dic as! NSDictionary).object(by:BannerInfo.self) as! BannerInfo

                bannerArray.add(info)
            }
            if bannerArray.count == 2{
                isBannerTwo = true
                bannerArray.add(bannerArray[0])
                bannerArray.add(bannerArray[1])
            }
            
        }
        
        let recommendArray = data["conponsRecommend"] as? NSArray
        if (recommendArray?.count)!>0 {
            if recommendDataArray.count>0{
                self.recommendDataArray.removeAllObjects()
            }
            for dict in recommendArray! {
                let model = (dict as! NSDictionary).object(by: HomeGoodModel.self) as! HomeGoodModel
                self.recommendDataArray.add(model)
            }
        }
        

        if self.secondArray.count > 0{
            self.secondArray.removeAllObjects()
        }
        let leftDict = data["phonesWithHand"] as! NSDictionary
        let leftModel = leftDict.object(by: RecommendModel.self) as! RecommendModel
        self.leftReModel = leftModel
         self.secondArray.add(leftModel)
        
        let rightDict = data["conponsWithHand"] as! NSDictionary
        let rightModel = rightDict.object(by: RecommendModel.self) as! RecommendModel
        self.rightReModel = rightModel
        
        self.secondArray.add(rightModel)
    
        self.bannerListDidChange(array:bannerArray)
        self.tableView.reloadData()
    }
    
    func bannerListDidChange(array:NSArray) {
        var str = ""
        for info in array {
            let dic = info as! BannerInfo
            let identify = dic.id
//            print("identify",identify!)
            if (identify! as NSString).length>0{
                str = str + identify!
            }
        }
        
        if bannerListFlag == nil||bannerListFlag == str {
            bannerListFlag = str
//            print("str>>>>>>>",str)
            banncerCell?.bannerView.reloadData()
        }
            
        }
    
    //    MARK:获取猜你喜欢数据
    func getListData() {
        HttpHelper.getHomeListData(withPageNum: String(page), limitNum: "0", success: { (resultDic) in
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
        print("handleloadListResult",dic)
       
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
        let indexset = NSIndexSet(index: 4)
        self.tableView.reloadSections(indexset as IndexSet, with: .automatic)
//        self.tableView.reloadData()
    }
   
    
    
    //    MARK: - 上下刷新
    func setTabelViewRefresh() {
        weak var weakSelf = self
        self.tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            weakSelf?.getShowData()
            weakSelf?.getListData()
        })
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        weakSelf?.tableView.mj_header.isAutomaticallyChangeAlpha = true
        weakSelf?.tableView.mj_header.beginRefreshing()
//        上拉刷新
        weakSelf?.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {

            self.hideRefresh()
        })
//        weakSelf?.tableView.mj_footer.isHidden = true
        
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1{
            return 1
        }else if section == 2{
            return self.secondArray.count/2
        }else if section == 4{
            if self.goodsData.count%2 == 0{
                return self.goodsData.count/2
            }else{
                return (self.goodsData.count/2)+1
            }
        }else{
            return self.recommendDataArray.count
        }
    }
    //    MARK:banner点击方法
    func tapBanner(_ tap:UITapGestureRecognizer) {
        let cell = self.banncerCell
        
        let info = bannerArray[(cell?.pageController.currentPage)!] as! BannerInfo
//        print("info",info.id)
        // 跳转邀请好友
        if (info.id == "109") {
//            let vc = InviteViewController(nibName: "InviteViewController", bundle: nil)
//            // 邀请好友
//            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        if (info.id == "105") {
//            let vc = FreeGoTableViewController(nibName: "FreeGoTableViewController", bundle: nil)
//            // 邀请好友
//            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        
        if (info.id == "129") {
            self.navigationController?.navigationBar.barTintColor = UIColor.defaultRed()
            self.tabBarController?.tabBar.isHidden = true
            let rotVC = RotaryViewController(nibName: "RotaryViewController", bundle: nil)
            self.navigationController?.pushViewController(rotVC, animated: true)
//            let magicMove = MagicMoveTransition()
//            self.navigationController?.pushViewController(rotVC, animated: true, transition: magicMove)
            return
        }
        
        if(info.is_jump == "y")
        {
            if(info.image_url.count > 0||info.content_txt.count > 0){
//                let vc = SafariViewController(nibName: "SafariViewController", bundle:nil)
//                vc.title = info.title
//                vc.urlStr = info.url
//                self.navigationController?.pushViewController(vc, animated: true)
            }else{
//                let vc = AdvertisementViewController()
//                vc.image_url = info.image_url as NSString
//                vc.content_txt = info.content_txt as NSString
//                vc.h5UrlStr = info.url
//                vc.myTitle = info.title as NSString
//                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
       
    }
    
    //    MARK:BanncerDelegate
    func cycleScrollView(_ cycleScrollView: CycleScrollView!, viewAtPage page: Int) -> UIView! {

        if cycleScrollView.tag == 100 {
            let imageView = UIImageView()
//            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            let info = bannerArray[page] as! BannerInfo
            let url = info.header
            let urls = URL(string: url!)
            imageView.sd_setImage(with: urls, placeholderImage: nil)
            return imageView
        }else{
             let imageView = UIImageView()
            return imageView
        }
    }
    
    func numberOfViews(in cycleScrollView: CycleScrollView!) -> Int {
        if (cycleScrollView.tag == 100) {
             let cell = self.banncerCell
            if (isBannerTwo) {
                (cell)?.pageController.numberOfPages = 2
            }else{
                (cell)?.pageController.numberOfPages = bannerArray.count
            }
            
            if(bannerArray.count==1){
                cell?.pageController.isHidden = true
            }
            
            return  bannerArray.count
        }else{
            return 1
        }
    }
    
    func cycleScrollView(_ cycleScrollView: CycleScrollView!, didScrollView index: Int32) {
        if (cycleScrollView.tag == 100) {
             let cell = self.banncerCell
            if (isBannerTwo)
            {
                cell?.pageController.currentPage = Int(index%2)
            }else{
                cell?.pageController.currentPage = Int(index)
            }
        }
    }
    
    
    func frame(of cycleScrollView: CycleScrollView!) -> CGRect {
        if (cycleScrollView.tag == 100) {

            return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*0.632)
        }else{
            return CGRect(x:0,y:0,width:UIScreen.main.bounds.width-46,height:20);
        }
    }
        
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell:BannerTableViewCell? = nil

            cell = tableView.dequeueReusableCell(withIdentifier: "BannerTableViewCell") as? BannerTableViewCell
            if cell == nil{
                let nib = Bundle.main.loadNibNamed("BannerTableViewCell", owner: nil, options: nil)
                cell = nib?.first as? BannerTableViewCell
                cell?.bannerView.delegate = self
                cell?.bannerView.dataSource = self
                cell?.bannerView.autoScrollAble = true
                cell?.bannerView.tag = 100
                cell?.bannerView.direction = CycleDirectionLandscape
                //             objc_setAssociatedObject(cell.bannerView, "cell", cell, OBJC_ASSOCIATION_ASSIGN);
                objc_setAssociatedObject(cell?.bannerView, "cell", cell, .OBJC_ASSOCIATION_ASSIGN)
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapBanner(_:)))
                tap.numberOfTapsRequired = 1
                //            objc_setAssociatedObject(tap, "cell", cell, OBJC_ASSOCIATION_ASSIGN);
                objc_setAssociatedObject(tap, "cell", cell, .OBJC_ASSOCIATION_ASSIGN)
                cell?.bannerView.addGestureRecognizer(tap)
                self.banncerCell = cell
            }
          
            cell?.selectionStyle = .none
            return cell!
            
        }else if indexPath.section == 1 {
            
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "duobaoCell")
            cell.selectionStyle = .none
            if ShareManager.shareInstance().isInReview{
                
            }else{
               
//                if (ShareManager.shareInstance().userinfo != nil){
//                    if (ShareManager.shareInstance().userinfo.home_show != nil){
//                        let arr = ShareManager.shareInstance().userinfo.home_show.components(separatedBy: ",")
//                        let modelArr = Tool.getHomeShowDatas(with: arr)
//                        var rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120)
//                        if (modelArr?.count)! > 4{
//                          rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 240)
//                        }
//                        let view = NewBaseShopCollectionView(frame: rect, modelArr: modelArr as! [ShowModel], cell: "NewHomeDuoBaoCell")
//                        view.delegate = self
//                        cell.addSubview(view)
//                    }
//                }
            }
            
            cell.selectionStyle = .none
            return cell
            
        }else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "selectCell", for: indexPath) as! SelectCell
            cell.leftTitle.text = self.leftReModel?.goods_type_name
            cell.leftDesTitle.text = self.leftReModel?.remark
            cell.leftImageView.sd_setImage(with: URL(string: (self.leftReModel?.goods_type_header)!), placeholderImage: nil)
            cell.leftView.whenTapped({
//                let vc = GoodSelectionViewController()
//                vc.flageTag = 1
//                vc.typeArray = self.secondArray
//                self.navigationController?.pushViewController(vc, animated: true)
            })
            cell.rightTitle.text = self.rightReModel?.goods_type_name
            cell.rightDesTitle.text = self.rightReModel?.remark
            cell.rightImageView.sd_setImage(with: URL(string: (self.rightReModel?.goods_type_header)!), placeholderImage: nil)
            cell.rightView.whenTapped({
//                let vc = GoodSelectionViewController()
//                vc.flageTag = 0
//                vc.typeArray = self.secondArray
//                self.navigationController?.pushViewController(vc, animated: true)
            })
            
             cell.selectionStyle = .none
            
            return cell
            
        }else if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "recommendedCell", for: indexPath) as! RecommendedCell
            let model = self.recommendDataArray[indexPath.row] as? HomeGoodModel
            cell.goodModel = model
            

            cell.buyNowBtn.whenTapped({

                self.pushDetialWithGoodModel(model!)
            })
           
             cell.selectionStyle = .none
            return cell
            
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! NewShopHomeListCell
            let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapFuction(_:)))
            tap.numberOfTapsRequired = 1
            cell.leftView.tag = indexPath.row*2
            cell.leftModel = self.goodsData[indexPath.row*2] as? HomeGoodModel
            cell.leftView.addGestureRecognizer(tap)
            
            //当数据为单数是隐藏右边View
            if ((indexPath.row*2)==self.goodsData.count-1 && !((self.goodsData.count%2)==0)){
                cell.rightView.isHidden = true
            }else{
                cell.rightView.isHidden = false
                let tap1 = UITapGestureRecognizer(target: self, action: #selector(cellTapFuction(_:)))
                tap1.numberOfTapsRequired = 1
                cell.rightView.tag = indexPath.row*2+1
                cell.rightModel = self.goodsData[indexPath.row*2+1] as? HomeGoodModel
                cell.rightView.addGestureRecognizer(tap1)
                cell.selectionStyle = .none
            }
           
            
            return cell
        }
        
    }
    
    func cellTapFuction(_ tap:UITapGestureRecognizer)  {
        
        let model = self.goodsData[(tap.view?.tag)!] as! HomeGoodModel
        self.pushDetialWithGoodModel(model)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UIScreen.main.bounds.width*0.632
        }
        if indexPath.section == 1 {
            if Tool.islogin(){
                if ShareManager.shareInstance().isInReview{
                    return 0
                }else{
                    if (ShareManager.shareInstance().userinfo != nil){
                        if (ShareManager.shareInstance().userinfo.home_show != nil){
                            let arr = ShareManager.shareInstance().userinfo.home_show.components(separatedBy: ",")
                            let modelArr = Tool.getHomeShowDatas(with: arr)
                            if (modelArr?.count)!>4{
                                return 220
                            }else{
                               return 108
                            }
                        }else{
                            return 108
                        }
                        
                    }else{
                      return 108
                    }
//                    return 108
                }
                
            }else{
                return 0
            }
        }
        if indexPath.section == 2 {
             return 118
        }
        if indexPath.section == 3 {
            return 158
        }
        if indexPath.section == 4 {
            return 265
        }else{
            return 135
        }
    }
    
   
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < -64 || scrollView.contentOffset.y > 0 {
            self.searchView?.alpha = 0
        }else{
            self.searchView?.alpha = 1
        }

    }
    
//    创建header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.001
        }
        if section == 1 {
             return 0.001
            
        }
        if section == 2 {
             return 0.001
        }
        if section == 3 {
             return 50
        }
        if section == 4 {
             return 50
        }else{
            return 0.001;
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section != 0&&section != 4 {
            return 10
        }else{
            return 0.001
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
         if section != 0||section != 4 {
        view.frame = CGRect(x: 0, y: 0, width: kWidth, height: 10)
        view.backgroundColor = UIColor(fromHexString: "F8F6F6")
            
         }else{
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
       
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = Bundle.main.loadNibNamed("HeaderView", owner: nil, options: nil)?.first as! HeaderView
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        view.rightLabel.text = ""
        if section == 2 {
//            view.leftLabel.text = "精选好货"
        }
        if section == 3 {
            view.leftLabel.text = "好券推荐"
        }
        if section == 4 {
            view.leftLabel.text = "猜你喜欢"
            
        }
//        view.backgroundColor = UIColor.blue
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let model = self.recommendDataArray[indexPath.row] as! HomeGoodModel
            self.pushDetialWithGoodModel(model)
        }
    }
    
    //    MARK:跳转商品详情页面
    func pushDetialWithGoodModel(_ goodModel:HomeGoodModel) {
//
//       let vc = NewShopGoodDetailViewController(tableViewStyle: .grouped)
//        vc?.goodModel = goodModel
//        self.navigationController?.pushViewController(vc!, animated: true)
      
    }
    
    //    MARK:跳转到各个页面
    func pushToVCFor(_ tag:Int)  {
        
        switch tag {
        case 1:
          self.navigationController?.navigationBar.barTintColor = UIColor.defaultRed()
          self.tabBarController?.tabBar.isHidden = true
          ShareManager.shareInstance().isEnterMK = true
          let entVC = EntTabBarViewController()
//          let magicMove = MagicMoveTransition()
          self.navigationController?.pushViewController(entVC, animated: true)
        
            break
        case 2:
            self.navigationController?.navigationBar.barTintColor = UIColor.defaultRed()
            self.tabBarController?.tabBar.isHidden = true
            ShareManager.shareInstance().isEnterMK = false
            let entVC = EntTabBarViewController()
//            let magicMove = MagicMoveTransition()
            self.navigationController?.pushViewController(entVC, animated: true)
            break
        case 3:
            self.navigationController?.navigationBar.barTintColor = UIColor.defaultRed()
            self.tabBarController?.tabBar.isHidden = true
            let rotVC = RotaryViewController(nibName: "RotaryViewController", bundle: nil)
//            self.navigationController?.pushViewController(rotVC, animated: true)
//            let magicMove = MagicMoveTransition()
            self.navigationController?.pushViewController(rotVC, animated: true)
            break
        case 4:
//            let vc = NewChangeViewController(tableViewStyle: .plain)
//
//            self.navigationController?.pushViewController(vc!, animated: true)
            break
        case 5:
//            let vc = SafariViewController(nibName: "SafariViewController", bundle: nil)
//            vc.isGame = true
//            vc.urlStr = URL_Game_Fruits
//            vc.title = "水果游戏"
//            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 6:
         //签到
//            let vc = SafariViewController(nibName: "SafariViewController", bundle: nil)
//            vc.isGame = true
//            vc.urlStr = URL_Game_QQQuiz
//            vc.title = "qq在线人数竞猜"
//            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 7:
            //签到
//            let vc = SafariViewController(nibName: "SafariViewController", bundle: nil)
//            vc.isGame = true
//            vc.urlStr = URL_Game_SSC
//            vc.title = "时时彩"
//            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 8:
            //签到
//            let vc = SafariViewController(nibName: "SafariViewController", bundle: nil)
//            vc.isGame = true
//            vc.urlStr = URL_Game_Bowling
//            vc.title = "保龄球"
//            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
        
    }
    
    //    MARK:NewBaseCollectionDelegate
    func pushToDouBaoWith(_ tag: Int) {
        self.pushToVCFor(tag)
        
    }
    
    func pushToGoodDetialWith(_ goodId: String) {
//        self.pushDetialWithGoodModel(goodId)
    }
   

}
