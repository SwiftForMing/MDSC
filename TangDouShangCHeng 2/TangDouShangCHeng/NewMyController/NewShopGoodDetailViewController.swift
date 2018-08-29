//
//  NewShopGoodDetailViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/13.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewShopGoodDetailViewController: BaseTableViewController,CycleScrollViewDelegate,CycleScrollViewDataSource {
    
    var banncerCell:BannerTableViewCell?
    var popView:PopView?
    var numForRow = 0
    var buyNum = 1
    var buyTitle:String = ""
    var propertys:String = ""
    var scModels:[HomeGoodModel] = DataManager().fetchAllData()
    var scImageView:UIImageView?
    var goodModel:HomeGoodModel?{
        didSet{
            numForRow = 1
            self.createFooterView()
            for model in scModels {
                if goodModel?.id == model.id{
                 scImageView?.image = UIImage(named: "hadselect")
                }
            }
            
            banncerCell?.bannerView.reloadData()
            self.getDetialModel()
            self.tableView.reloadData()
           
        }
    }
    var fatherArray:[GoodArgModel] = []
    var childArray:[[GoodArgModel]] = []
    var imagesArray:[String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = """
//        商品               详情
//        """
        
        let bgview = UIView(frame: CGRect(x: 0, y: 0, width: 210, height: 44))
        bgview.backgroundColor = UIColor.white
        let leftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 44))
        leftLabel.text = "商品"
        leftLabel.textAlignment = .center
        leftLabel.textColor = UIColor(fromHexString: "#666666")
        leftLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 15)
        leftLabel.whenTapped {
            UIView.animate(withDuration: 1, animations: {
                self.tableView.contentOffset = CGPoint(x: 0, y: 0)
            })
            
        }
        
         let rightLabel = UILabel(frame: CGRect(x: 70, y: 0, width: 70, height: 44))
        rightLabel.text = "详情"
        rightLabel.textAlignment = .center
        rightLabel.textColor = UIColor(fromHexString: "#666666")
        rightLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 15)
        rightLabel.whenTapped {
            UIView.animate(withDuration: 1, animations: {
                self.tableView.contentOffset = CGPoint(x: 0, y: (kWidth*0.80)+300)
            })
           
        }
        let commentLabel = UILabel(frame: CGRect(x: 140, y: 0, width: 70, height: 44))
        commentLabel.text = "评论"
        commentLabel.textAlignment = .center
        commentLabel.textColor = UIColor(fromHexString: "#666666")
        commentLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 15)
        commentLabel.whenTapped {
          
            let vc = ShaiDanViewController(nibName: "ShaiDanViewController", bundle: nil)
            vc.goodId = self.goodModel?.id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        bgview.addSubview(commentLabel)
        bgview.addSubview(leftLabel)
        bgview.addSubview(rightLabel)
        self.navigationItem.titleView = bgview
        
        let leftItemControl = UIControl(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        leftItemControl.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        let back = UIImageView(frame: CGRect(x: 0, y: 13, width: 10, height: 18))
        back.image = UIImage(named: "shopBack")
        leftItemControl.addSubview(back)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftItemControl)
        
        self.tableView.frame = CGRect(x: 0, y: 0, width: kWidth, height: kHeight-50)
        self.tableView?.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
        self.tableView.register(UINib(nibName: "NewHomeGoodDetialCell", bundle: nil), forCellReuseIdentifier: "infoCell")
        self.tableView.register(UINib(nibName: "NewShopWebViewCell", bundle: nil), forCellReuseIdentifier: "imageCell")
         tableView.register(UINib(nibName: "NewBuyGoodDetialCell", bundle: nil), forCellReuseIdentifier: "buyCell")
    }
    
    func getDetialModel() {
        
//        let imagesStr = goodModel?.content_imgs
//
//        if !((imagesStr) != nil){
//
//        }else{
//            let imageArr = imagesStr?.components(separatedBy: ",")
//            for str in imageArr!{
//
//                self.imagesArray.append(str)
//            }
//        }
//
//
//        let array = (goodModel?.good_option)! as NSArray
//
//        for dic in array {
//            let dict = dic as! NSDictionary
//            let model = dict.object(by: GoodArgModel.self) as! GoodArgModel
//            fatherArray.append(model)
//        }
//
//        var child:[[GoodArgModel]] = []
//        for (model) in fatherArray{
//            var arr:[GoodArgModel] = []
//            let childArr = model.children_option
//            for (i,dic) in childArr!.enumerated(){
//
//                let dict = dic as! NSDictionary
//                let model = dict.object(by: GoodArgModel.self) as! GoodArgModel
//                if i == 0{
//
//                    self.buyTitle = self.buyTitle + model.property_value! + ","
//
//                    self.propertys = self.propertys + model.id! + ","
//                }
//                arr.append(model)
//            }
//            child.append(arr)
//        }
//
//        self.childArray = child
    }
    
    func createFooterView() {
        let btnWidth = (129/375)*kWidth
        let leftWidth = ((kWidth-btnWidth*2)-60)/2
        let view = UIView(frame: CGRect(x: 0, y: kHeight-64-50-xBottomHeight, width: kWidth, height: 50))
        view.backgroundColor = UIColor.white
        let kfImg = UIImageView(frame: CGRect(x: 20, y: 10, width: leftWidth, height: 30))
        kfImg.image = UIImage(named: "kehu")
        kfImg.whenTapped {
            //           MARK: 进入客服系统
            self.gotoKF()
            
        }
        kfImg.contentMode = .scaleAspectFit
        
        let scImg = UIImageView(frame: CGRect(x: kfImg.frame.size.width+30+kfImg.frame.origin.x, y: kfImg.frame.origin.y, width: leftWidth, height: kfImg.frame.size.height))
        scImg.image = UIImage(named: "favourite")
        scImg.whenTapped {
            scImg.image = UIImage(named: "hadselect")
//            MARK: 加入收藏
            let dataMannger = DataManager()
            if self.scModels.count>0{
            for model in self.scModels {
                if self.goodModel?.id == model.id{
                    Tool.showPromptContent("已收藏")
                }else{
                    dataMannger.insertDataWith(self.goodModel!)
                    }
                }
            }else{
                dataMannger.insertDataWith(self.goodModel!)
            }
        }
        
        
        self.scImageView = scImg
        scImg.contentMode = .scaleAspectFit
        
        let buyAlone = UIButton(frame: CGRect(x: scImg.frame.origin.x+scImg.frame.size.width+12, y: 0, width: btnWidth, height: 50))
        buyAlone.setTitle("单独购买", for: .normal)
        buyAlone.whenTapped {
//         MARK:   点击进入单独购买
           
//            let vc = EditOrderViewController(tableViewStyle: UITableViewStyle.grouped)
//            vc?.goodModel = self.goodModel
//            vc?.propertys = self.propertys
//            vc?.buyNum = "\(self.buyNum)"
//            self.navigationController?.pushViewController(vc!, animated: true)
        }
        buyAlone.alpha = 0.8
        
        buyAlone.setzGradient(leftColor: "ED533B", right: "EF2F48")

        let buyCoupon = UIButton(frame: CGRect(x: buyAlone.frame.origin.x+buyAlone.frame.size.width, y: 0, width:btnWidth, height: 50))
        buyCoupon.setTitle("立即购券", for: .normal)
        buyCoupon.whenTapped {
            //  MARK:   点击进入购买
            
//            let payVC = NewShopOrderViewController()
//            payVC.buyNum = "\(self.buyNum)"
//            payVC.goodModel = self.goodModel
//            payVC.propertys = self.propertys
//
//            self.navigationController?.pushViewController(payVC, animated: true)
        }
        buyCoupon.backgroundColor = UIColor(fromHexString: "EF2F48")
        
        view.addSubview(kfImg)
        view.addSubview(scImg)
        view.addSubview(buyAlone)
        view.addSubview(buyCoupon)
        self.view.addSubview(view)
    }
    
    func gotoKF() {
        
        if !ShareManager.shareInstance().userinfo.islogin {
            Tool.loginWith(animated: true, viewController: nil)
            return
        }
        
        let userInfo = ShareManager.shareInstance().userinfo
        let userID = userInfo?.id

        let version = (Bundle.main.infoDictionary! as NSDictionary).object(forKey: "CFBundleShortVersionString") as! String
        let versionString = "iOS \(version)"
        let alias = userInfo?.nick_name
        let telephone = userInfo?.user_tel
       
        let chatViewConfig = MQChatViewConfig.shared()
        let chatViewController = MQChatViewController(chatViewManager: chatViewConfig)
        chatViewConfig?.enableOutgoingAvatar = false
        chatViewConfig?.enableRoundAvatar = true
        chatViewConfig?.navTitleColor = UIColor.white
        chatViewConfig?.navBarColor = UIColor.white
        chatViewConfig?.statusBarStyle = .lightContent
        chatViewController!.title = "客服"
        chatViewConfig?.navTitleText = "客服"
        chatViewConfig?.customizedId = userID
        chatViewConfig?.enableEvaluationButton = false
        chatViewConfig?.agentName = "客服"
        chatViewConfig?.clientInfo = ["name":alias!,"version": versionString,"identify": userID!,"telephone": telephone!]
        chatViewConfig?.updateClientInfoUseOverride = true
        chatViewConfig?.recordMode = .duckOther
        chatViewConfig?.playMode = .mixWithOther
        self.navigationController?.pushViewController(chatViewController!, animated: true)
        
        let leftItemControl = UIControl(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        leftItemControl.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        let back = UIImageView(frame: CGRect(x: 0, y: 13, width: 10, height: 18))
        back.image = UIImage(named: "shopBack")
        leftItemControl.addSubview(back)
        chatViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftItemControl)
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return numForRow
        }
        if section == 1 {
            return numForRow
        }
        if section == 2 {
            return 2*numForRow
        }
        if section == 3 {
            return self.imagesArray.count
        }else if section == 4 {
            return numForRow
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let nib = Bundle.main.loadNibNamed("BannerTableViewCell", owner: nil, options: nil)
            let cell = nib?.first as! BannerTableViewCell
            cell.bannerView.delegate = self
            cell.bannerView.dataSource = self
            cell.bannerView.autoScrollAble = true
            cell.bannerView.tag = 100
            cell.bannerView.direction = CycleDirectionLandscape

            let tap = UITapGestureRecognizer(target: self, action: #selector(tapBanner(_:)))
            tap.numberOfTapsRequired = 1
            cell.bannerView.addGestureRecognizer(tap)
            self.banncerCell = cell
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! NewHomeGoodDetialCell
            cell.goodModel = self.goodModel
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.section == 2 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "buyCell", for: indexPath) as! NewBuyGoodDetialCell
            cell.selectionStyle = .none
            if indexPath.row == 0{
                cell.titleLabel.text = "产品参数"
                cell.selectLabel.text = ""
                cell.selectHeight.constant = 5
            }
            if indexPath.row == 1{
                
                self.buyTitle = self.buyTitle + " "
                let str = (self.buyTitle as NSString).replacingOccurrences(of: ", ", with: "  ")
                self.buyTitle = str+","
                cell.selectLabel.text = str
                cell.selectHeight.constant = 15
            }
                 return cell
           
        }
//        if indexPath.section == 3 {
//            let nib = Bundle.main.loadNibNamed("LifeZoneListTableViewCell", owner: nil, options: nil)
//            let cell = nib?.first as! LifeZoneListTableViewCell
//            cell.initImageCollectView()
////            cell.delegate = self
////            cell.imageCollectView.delegate = cell
////            cell.imageCollectView.dataSource = cell
//            cell.photo.tag = indexPath.row
//            cell.photo.isUserInteractionEnabled = true
//            let tap = UITapGestureRecognizer(target: self, action: #selector(self.clickUserPhotoAction(_:)))
//            cell.photo.addGestureRecognizer(tap)
//
//            cell.selectionStyle = .none
//
//
////             [self loadCellContent:cell indexPath:indexPath];
//            return cell
//
//        }
        
        if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) //as! NewShopWebViewCell
//            cell.url = self.imagesArray[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell1")
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        if section == 2 {
            view.frame = CGRect(x: 0, y: 0, width: kWidth, height: 50)
            let label = UILabel(frame: CGRect(x: 20, y: 10, width: kWidth-40, height: 30))
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = UIColor.red
            if numForRow == 1 {
                label.text = "\((goodModel?.coupons_price)!)元购券立享\((goodModel?.after_coupons_price)!)购买产品"
            }
            view.addSubview(label)
        }else{
            view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 50
        }else{
            return 0.01
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        if section == 1 || section == 2 {
            view.frame = CGRect(x: 0, y: 0, width:kWidth, height: 10)
        }else {
            view.frame = CGRect(x: 0, y: 0, width:kWidth, height: 0)
        }
        view.backgroundColor = UIColor(fromHexString: "F8F6F6")
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height:CGFloat = 0
        if section == 1||section == 2 {
            height = 10
        }else {
            height = 0.001
        }
        return height
    }
    
//    //    MARK:TAP
//    func clickUserPhotoAction(_ tap:UITapGestureRecognizer) {
//        
//        
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if indexPath.section == 2 {
            if indexPath.row == 0{
                self.popView = PopView(frame: self.view.frame)
//                let array = (goodModel?.good_details)! as NSArray
//                let height = (array.count)*44+50+50
//                let fram = CGRect(x: 0, y: 0, width: Int(kWidth), height: height)
//                let showView = GoodInfoView(frame: fram, goodArray: array)
//                showView.delegate = self
//               self.popView?.showInView(self.view, withChirdView: showView,moveVaule:0-xBottomHeight)
            }
            
            if indexPath.row == 1{
                self.popView = PopView(frame: self.view.frame)
                let rect = CGRect(x: 0, y: 0, width: kWidth, height: 500)
               
//                let showView = NewShopSelectView(frame: rect, goodModel:self.goodModel!)
//                showView.sendBuyValue = {
//                    (colorValue,memoryValue,buyNum) in
//
//                    self.buyNum = buyNum
//                    if colorValue == -1 || memoryValue == -1{
//                        if buyNum != 0{
//                            self.buyTitle = "\(buyNum)件"
//                        }
//                    }else{
//                        self.buyTitle = self.childArray[0][colorValue].property_value! + "  , " + self.childArray[1][memoryValue].property_value! + "  , " + "\(buyNum)件" + ","
//                         self.propertys = self.childArray[0][colorValue].id! + "," + self.childArray[1][memoryValue].id!
//
//                        self.tableView.reloadData()
//                    }
//                    self.popView?.disMissView()
//
//                }
//
//                self.popView?.showInView(self.view, withChirdView: showView,moveVaule:0-xBottomHeight)
            }
            }
        }
    
    func closePopView() {
        if self.popView != nil {
            self.popView?.disMissView()
        }
        
    }
    
    func heightForRow(row:Int)->CGFloat {
        let image = UIImageView(frame: CGRect.zero)
        var height:CGFloat = 0
        let url = URL(string: self.imagesArray[row])
        
        image.sd_setImage(with: url!, placeholderImage: nil, options: .retryFailed) { (image, error, SDImageCacheType, imageUrl) in
            height = (((image?.size.height)!)/(image?.size.width)!)*kWidth
        }
        return height
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return kWidth*0.80
        }
        if indexPath.section == 1 {
            return 120
        }
        if indexPath.section == 2 {
            return 60
        }
        if indexPath.section == 3 {
            
            return heightForRow(row: indexPath.row)
        }
        if indexPath.section == 4 {
            return 1250
        }else{
            return 135
        }
    }
    //    MARK:banncer点击fangf
    func tapBanner(_ tap:UITapGestureRecognizer) {
//        print("tapBanner",tap.view?.tag)
    }
    
    //    MARK:BanncerDelegate
    func cycleScrollView(_ cycleScrollView: CycleScrollView!, viewAtPage page: Int) -> UIView! {
        
        if cycleScrollView.tag == 100 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            let str = goodModel?.good_imgs
            let arr = (str?.components(separatedBy: ","))!
            let urls = URL(string: arr[page])
//            print("urls>>>>>>",urls)
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
            let str = goodModel?.good_imgs
            let arr = (str?.components(separatedBy: ","))!
//            if (arr.count<2) {
//                (cell)?.pageController.numberOfPages = 2
//            }else{
                (cell)?.pageController.numberOfPages = arr.count
//            }
            return  arr.count
        }else{
            return 1
        }
    }
    
    func cycleScrollView(_ cycleScrollView: CycleScrollView!, didScrollView index: Int32) {
        if (cycleScrollView.tag == 100) {
            //           let cell = objc_getAssociatedObject(cycleScrollView, "cell") as! BannerTableViewCell
            let cell = self.banncerCell
//            if (isBannerTwo)
//            {
//                cell?.pageController.currentPage = Int(index%2)
//            }else{
                cell?.pageController.currentPage = Int(index)
//            }
        }
    }
    
    
    func frame(of cycleScrollView: CycleScrollView!) -> CGRect {
        if (cycleScrollView.tag == 100) {
            
            return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: kWidth*0.80)
        }else{
            return CGRect(x:0,y:0,width:UIScreen.main.bounds.width-46,height:20);
        }
    }
    

}
