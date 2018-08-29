//
//  NewShopShareCouponViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/27.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewShopShareCouponViewController: BaseTableViewController,CycleScrollViewDelegate,CycleScrollViewDataSource {
    var numForRow = 0
    var banncerCell:BannerTableViewCell?
    var goodModel:HomeGoodModel?{
        didSet{
            numForRow = 1
            self.getDetialModel()
            self.getCouponId()
            banncerCell?.bannerView.reloadData() 
            self.tableView.reloadData()
        }
    }
    var couponString = ""
    var imagesArray:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "转让"
        self.tableView.register(UINib(nibName: "CouponCodeCell", bundle: nil), forCellReuseIdentifier: "codeCell")
         self.tableView.register(UINib(nibName: "NewShareCouponCell", bundle: nil), forCellReuseIdentifier: "shareCell")
         self.tableView.register(UINib(nibName: "NewShopCouponRulerCell", bundle: nil), forCellReuseIdentifier: "rulerCell")
         self.tableView.register(UINib(nibName: "NewHomeGoodDetialCell", bundle: nil), forCellReuseIdentifier: "infoCell")
        // Do any additional setup after loading the view.
    }
    func getDetialModel() {
        
//        let imagesStr = goodModel?.content_imgs
//        
//        if !((imagesStr) != nil){
//            
//        }else{
//            let imageArr = imagesStr?.components(separatedBy: ",")
//            for str in imageArr!{
//                print("str>>>>>>",str)
//                self.imagesArray.append(str)
//            }
//        }
        
    }
    
  
    func getCouponId() {
       
        HttpHelper.getSharaCouponID(withUserID: ShareManager.shareInstance().userinfo.id, coupons_secret: goodModel?.id, success: { (data) in
          
            let dict = data! as NSDictionary
            let status = dict["status"] as! String
           
            if (status == "0"){
                
              let dic = dict["data"] as! NSDictionary
              let shareCoupons =  dic["shareCoupons"] as! [String:Any];
               
              self.couponString = shareCoupons["id"] as! String
            }else{
            self.couponString = "获取优惠券码失败"
            }
            self.tableView.reloadData()
            
        }) { (error) in
            self.couponString = "获取优惠券码失败"
            Tool.showPromptContent(error, on: self.view)
             self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numForRow
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
//            print("NewHomeGoodDetialCell:",self.goodModel?.coupons_value)
            cell.goodModel = self.goodModel
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "codeCell", for: indexPath) as! CouponCodeCell
            cell.selectionStyle = .none
            cell.copyBtn.whenTapped({
                let link = self.couponString
                let pasteboard = UIPasteboard()
                pasteboard.string = link
                Tool.showPromptContent("复制成功")
            })
            cell.shareCodeLabel.text = self.couponString
            return cell
        }
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "shareCell", for: indexPath)
            as! NewShareCouponCell
            cell.selectionStyle = .none
            cell.qqImageView.whenTapped({
                self.sharaToQQ()
            })
            
            cell.weixinImageView.whenTapped({
                self.shareWX()
            })
            return cell
        }
        if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rulerCell", for: indexPath) as! NewShopCouponRulerCell
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 240
        }
        if indexPath.section == 1 {
            return 120
        }
        if indexPath.section == 2 {
            return 92
        }
        if indexPath.section == 3 {
            return 102
        }
        if indexPath.section == 4 {
            return 150
        }else{
            return 100
        }
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 10
        }else{
            return 0.01
        }
      
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view  = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 10))
        view.backgroundColor = UIColor(fromHexString: "f7f7f7")
        return view
    }
    
    func sharaToQQ() {
        if self.couponString == "获取优惠券码失败" {
            Tool.showPromptContent("获取优惠券码失败", on: self.view)
            return
        }
        
        let bundleDisplayName = (Bundle.main.infoDictionary! as NSDictionary).object(forKey: "CFBundleDisplayName") as! String
        let str = "\(bundleDisplayName)- 最靠谱购物APP，0元购你所想！"
        
        let shareParams = NSMutableDictionary()

        shareParams.ssdkSetupQQParams(byText: self.couponString, title: str, url: nil, thumbImage: nil, image: "", type: .text, forPlatformSubType: .subTypeQQFriend)
        
        ShareSDK.share(.subTypeQQFriend, parameters: shareParams) { (state, userData, contentEntity, error) in
            switch(state){
            case .begin:
                break;
            case .success:
                break;
            case .fail:
                break;
            case .cancel:
                break;
            
        }
        }
        
    }
    
    
    
    func shareWX() {
        
            if self.couponString == "获取优惠券码失败" {
                Tool.showPromptContent("获取优惠券码失败", on: self.view)
                return
            }
            
            let bundleDisplayName = (Bundle.main.infoDictionary! as NSDictionary).object(forKey: "CFBundleDisplayName") as! String
            let str = "\(bundleDisplayName)- 最靠谱购物APP，0元购你所想！"
            
            let shareParams = NSMutableDictionary()
            shareParams.ssdkSetupWeChatParams(byText: self.couponString, title: str, url: nil, thumbImage: nil, image: nil, musicFileURL: nil, extInfo: nil, fileData: nil, emoticonData: nil, type: .text, forPlatformSubType: .subTypeWechatSession)
        
        
            ShareSDK.share(.subTypeWechatSession, parameters: shareParams) { (state, userData, contentEntity, error) in
                switch(state){
                case .begin:
                    break;
                case .success:
                    break;
                case .fail:
                    break;
                case .cancel:
                    break;
                    
                }
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
            
            return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 240)
        }else{
            return CGRect(x:0,y:0,width:UIScreen.main.bounds.width-46,height:20);
        }
    }
    
}
