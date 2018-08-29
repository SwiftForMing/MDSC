//
//  RotaryViewController.swift
//  Rotarytable
//
//  Created by 黎应明 on 2017/11/13.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit


class RotaryViewController: UIViewController,GetBetSelectedDelegate,MZTimerLabelDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    @IBOutlet weak var tigerNum: UILabel!
    @IBOutlet weak var longNum: UILabel!
    @IBOutlet weak var nangNum: UILabel!
    
    @IBOutlet weak var lastWinnerImage: UIImageView!
    @IBOutlet weak var timeLeftImage: UIImageView!
   
    @IBOutlet weak var lastJiexiaoImage: UIImageView!
    
    @IBOutlet weak var timeCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var scView: UIScrollView!
    @IBOutlet weak var oneHundredBtn: UIButton!
    
    @IBOutlet weak var bigListView: UIView!
    @IBOutlet weak var oneHundredTopLabel: UILabel!
    @IBOutlet weak var oneHundredBottomLabel: UILabel!
   
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet weak var tenBtn: UIButton!
    
    @IBOutlet weak var tenTopLabel: UILabel!
    @IBOutlet weak var tenBottomLabel: UILabel!
    
    @IBOutlet weak var mutipleLabel: UILabel!
    @IBOutlet weak var sixBtn: UIButton!
    @IBOutlet weak var sixTopLabel: UILabel!
    @IBOutlet weak var sixBottomLabel: UILabel!
    
    @IBOutlet weak var fiveBtn: UIButton!
    @IBOutlet weak var fiveTopLabel: UILabel!
    @IBOutlet weak var fiveBottomLabel: UILabel!
    
    @IBOutlet weak var fourTopLabel: UILabel!
    @IBOutlet weak var fourBtn: UIButton!
    @IBOutlet weak var fourBottomLabel: UILabel!
    
    @IBOutlet weak var threeBottomLabel: UILabel!
    @IBOutlet weak var threeTopLabel: UILabel!
    
    @IBOutlet weak var threeBtn: UIButton!
    
    @IBOutlet weak var timerLabel: MZTimerLabel!
    
    
    @IBOutlet weak var rulerBtn: UIButton!
    
    @IBOutlet weak var multipleBtn: UIButton!
    @IBOutlet weak var rotaryImageView: UIImageView!
    
    @IBOutlet weak var lastWinerImageView: UIImageView!
    
    @IBOutlet weak var lastWinerNameLabel: UILabel!
    @IBOutlet weak var lastWinBeanNumLabel: UILabel!
    
    @IBOutlet weak var beanNumLabel: UILabel!
    @IBOutlet weak var addBeanBtn: UIButton!
    
   
    
    var oneHundredBuyNum = 0
    var tenBuyNum = 0
    var sixBuyNum = 0
    var fiveBuyNum = 0
    var fourBuyNum = 0
    var threeBuyNum = 0
    
    var multiple = 1000
    var isFirst = true
    
    var refrshTimer:Timer?
    
    var oneHundredNowBuyNum = 0.0
    var tendNowBuyNum = 0.0
    var sixNowBuyNum = 0.0
    var fiveNowBuyNum = 0.0
    var fourNowBuyNum = 0.0
    var threeNowBuyNum = 0.0
    
    var betView:BetView?
    
    var lastangle = 0.0;
    
    @IBOutlet weak var lottery_yellow_bg: UIImageView!
    
    var manager = GCDSocketManger()

    var collectionView:UICollectionView?
    
    
    var luckyWheel:LXLuckyWheel?
    
    
    deinit {
        luckyWheel?.invalidate()
        luckyWheel = nil
        
        print("RotaryViewController deinit")
    }
    

    
    var bottomModel:fightAnimalModel?{
        didSet{
            self.oneHundredBottomLabel.text = "\((bottomModel?.FightAnimal_1)!)"
            self.tenBottomLabel.text = "\((bottomModel?.FightAnimal_2)!)"
            self.sixBottomLabel.text = "\((bottomModel?.FightAnimal_3)!)"
            self.fiveBottomLabel.text = "\((bottomModel?.FightAnimal_4)!)"
            self.fourBottomLabel.text = "\((bottomModel?.FightAnimal_5)!)"
            self.threeBottomLabel.text = "\((bottomModel?.FightAnimal_6)!)"
        }
    }
    
    //MARK:自己购买的model值didSet的时候赋值
    var topModel:BuyRecode?{
        didSet{
            self.oneHundredTopLabel.text = "\((topModel?.choice_1)!)"
            self.tenTopLabel.text = "\((topModel?.choice_2)!)"
            self.sixTopLabel.text = "\((topModel?.choice_3)!)"
            self.fiveTopLabel.text = "\((topModel?.choice_4)!)"
            self.fourTopLabel.text = "\((topModel?.choice_5)!)"
            self.threeTopLabel.text = "\((topModel?.choice_6)!)"
        }
    }
    
    //MARK:对上下label进行赋值
    func setData(dic:NSDictionary) {
        weak var weakSelf = self
        if dic["fightAnimal"] != nil{
            let bottomModel = ((dic["fightAnimal"]!) as! NSDictionary).object(by: fightAnimalModel.self)
            weakSelf!.bottomModel = (bottomModel as! fightAnimalModel)
        }
        
        if dic["buyRecord"] != nil{
            let topModel = (dic["buyRecord"]!) as! NSDictionary
            let model = BuyRecode()
            if (topModel["choice_1"] != nil){
                
                if topModel["choice_1"] as! String != String(weakSelf!.oneHundredBuyNum){
                    if weakSelf!.oneHundredBuyNum == 0{
                         model.choice_1 = topModel["choice_1"] as! String
                    }else{
                        model.choice_1 = String(weakSelf!.oneHundredBuyNum)
                    }
                   
                }else{
                    model.choice_1 = topModel["choice_1"] as! String
                    
                }
                weakSelf!.oneHundredBtn.setImage(UIImage(named:"lottery_bet_select"), for: .normal)
            }else{
                if weakSelf!.oneHundredBuyNum != 0 {
                    
                    model.choice_1 = String(weakSelf!.oneHundredBuyNum)
                }else{
                    model.choice_1 = "未下注"
                }
                
            }
            
            if (topModel["choice_2"] != nil){
                if topModel["choice_2"] as! String != String(weakSelf!.tenBuyNum){
                    if weakSelf!.tenBuyNum == 0{
                        model.choice_2 = topModel["choice_2"] as! String
                    }else{
                         model.choice_2 = String(weakSelf!.tenBuyNum)
                    }
                   
                }else{
                    model.choice_2 = topModel["choice_2"] as! String
                }
                weakSelf!.tenBtn.setImage(UIImage(named:"lottery_bet_select"), for: .normal)
            }else{
                if weakSelf!.tenBuyNum != 0 {
                    model.choice_2 = String(weakSelf!.tenBuyNum)
                }else{
                    model.choice_2 = "未下注"
                }
            }
            
            if (topModel["choice_3"] != nil){
                if topModel["choice_3"] as! String != String(weakSelf!.sixBuyNum){
                    if weakSelf!.sixBuyNum == 0{
                        model.choice_3 = topModel["choice_3"] as! String
                    }else{
                         model.choice_3 = String(weakSelf!.sixBuyNum)
                    }
                   
                }else{
                    model.choice_3 = topModel["choice_3"] as! String
                }
                
                weakSelf!.sixBtn.setImage(UIImage(named:"lottery_bet_select"), for: .normal)
            }else{
                if weakSelf!.sixBuyNum != 0 {
                    model.choice_3 = String(weakSelf!.sixBuyNum)
                }else{
                    model.choice_3 = "未下注"
                }
            }
            
            
            if (topModel["choice_4"] != nil){
                if topModel["choice_4"] as! String != String(weakSelf!.fiveBuyNum){
                    if weakSelf!.fiveBuyNum == 0{
                        model.choice_4 = topModel["choice_4"] as! String
                    }else{
                        model.choice_4 = String(weakSelf!.fiveBuyNum)
                    }
                   
                }else{
                    model.choice_4 = topModel["choice_4"] as! String
                }
                
                weakSelf!.fiveBtn.setImage(UIImage(named:"lottery_bet_select"), for: .normal)
            }else{
                if weakSelf!.fiveBuyNum != 0 {
                    model.choice_4 = String(weakSelf!.fiveBuyNum)
                }else{
                    model.choice_4 = "未下注"
                }
            }
            
            if (topModel["choice_5"] != nil){
                if topModel["choice_5"] as! String != String(weakSelf!.fourBuyNum){
                    if weakSelf!.fourBuyNum == 0{
                        model.choice_5 = topModel["choice_5"] as! String
                    }else{
                         model.choice_5 = String(weakSelf!.fourBuyNum)
                    }
                   
                }else{
                    model.choice_5 = topModel["choice_5"] as! String
                }
                
                weakSelf!.fourBtn.setImage(UIImage(named:"lottery_bet_select"), for: .normal)
            }else{
                if weakSelf!.fourBuyNum != 0 {
                    model.choice_5 = String(weakSelf!.fourBuyNum)
                }else{
                    model.choice_5 = "未下注"
                }
            }
            
            if (topModel["choice_6"] != nil){
                if topModel["choice_6"] as! String != String(weakSelf!.threeBuyNum){
                    if weakSelf!.threeBuyNum == 0{
                        model.choice_6 = topModel["choice_6"] as! String
                    }else{
                        model.choice_6 = String(weakSelf!.threeBuyNum)
                    }
                   
                }else{
                    model.choice_6 = topModel["choice_6"] as! String
                }
                
                weakSelf!.threeBtn.setImage(UIImage(named:"lottery_bet_select"), for: .normal)
            }else{
                if weakSelf!.threeBuyNum != 0 {
                    model.choice_6 = String(weakSelf!.threeBuyNum)
                }else{
                    model.choice_6 = "未下注"
                }
            }
            weakSelf!.topModel = model
        }

    }
    
    //MRAK:开奖后选中按钮
    func luckly(which:Int){
        switch which {
            case 1:
             self.oneHundredBtn.setImage(UIImage(named:"lottery_bet_select"), for:.normal)
            break
            case 2:
             self.tenBtn.setImage(UIImage(named:"lottery_bet_select"), for:.normal)
            break
            case 3:
             self.sixBtn.setImage(UIImage(named:"lottery_bet_select"), for:.normal)
            break
            case 4:
             self.fiveBtn.setImage(UIImage(named:"lottery_bet_select"), for:.normal)
            break
            case 5:
             self.fourBtn.setImage(UIImage(named:"lottery_bet_select"), for:.normal)
            break
            case 6:
             self.threeBtn.setImage(UIImage(named:"lottery_bet_select"), for:.normal)
            break
        default:
            break
        }
    }
    
    //MARK:是否在揭晓期间禁止操作
    func notCanUse(isOpen:Bool){
        self.oneHundredBtn.isUserInteractionEnabled = isOpen
        if isOpen {
             self.oneHundredBtn.setImage(UIImage(named:"lottery_bet_normal"), for:.normal)
        }else{
             self.oneHundredBtn.setImage(UIImage(named:"lottery_bet_disable"), for:.normal)
        }
       
        self.tenBtn.isUserInteractionEnabled = isOpen
        if isOpen {
            self.tenBtn.setImage(UIImage(named:"lottery_bet_normal"), for:.normal)
        }else{
            self.tenBtn.setImage(UIImage(named:"lottery_bet_disable"), for:.normal)
        }
        
        self.sixBtn.isUserInteractionEnabled = isOpen
        if isOpen {
            self.sixBtn.setImage(UIImage(named:"lottery_bet_normal"), for:.normal)
        }else{
            self.sixBtn.setImage(UIImage(named:"lottery_bet_disable"), for:.normal)
        }
        
        self.fiveBtn.isUserInteractionEnabled = isOpen
        if isOpen {
            self.fiveBtn.setImage(UIImage(named:"lottery_bet_normal"), for:.normal)
        }else{
            self.fiveBtn.setImage(UIImage(named:"lottery_bet_disable"), for:.normal)
        }
        
        self.fourBtn.isUserInteractionEnabled = isOpen
        if isOpen {
            self.fourBtn.setImage(UIImage(named:"lottery_bet_normal"), for:.normal)
        }else{
            self.fourBtn.setImage(UIImage(named:"lottery_bet_disable"), for:.normal)
        }
        
        self.threeBtn.isUserInteractionEnabled = isOpen
        if isOpen {
            self.threeBtn.setImage(UIImage(named:"lottery_bet_normal"), for:.normal)
        }else{
            self.threeBtn.setImage(UIImage(named:"lottery_bet_disable"), for:.normal)
        }
    }
    //MARK:通过参数设置时间
    func setTimeLabelWithTime(time:Int) {
        var s = 0
        self.timerLabel.timeFormat = "mm:ss"
        self.timerLabel.font = UIFont.init(name: "HelveticaNeue-Bold", size: 17)
        self.timerLabel.timerType = MZTimerLabelTypeTimer

        if time<50 {
            s = 50-time
            self.timerLabel.setCountDownTime(TimeInterval(s))
            self.timerLabel.reset()
            self.timerLabel.start()
        }
    }
    
    var currentChovie = 0
    //MARK:设置时间
    @objc func setTimeLabel() {
        var s = 0
        self.timerLabel.timeFormat = "mm:ss"
        self.timerLabel.font = UIFont.init(name: "HelveticaNeue-Bold", size: 17)
        self.timerLabel.timerType = MZTimerLabelTypeTimer

            let a = (animals[currentChovie-1])%360
        
            self.luckyWheel?.stop(atAngle: Float((Double(a))*(Double.pi/180)))
            self.notCanUse(isOpen: true)
            s = 48
            self.timerLabel.isHidden = false
            self.timeLeftImage.image = UIImage(named:"lottery_time_status_countdown")
            self.timerLabel.setCountDownTime(TimeInterval(s))
            self.timerLabel.reset()
            self.timerLabel.start()
            self.perform(#selector(self.open), with: nil, afterDelay: 1.0)
        
    }
    
    func open() {
        self.notCanUse(isOpen: true)
    }
     //MARK:pragma mark 支付结果处理逻辑
    func payNotifi(notification:NSNotification){
        
        let infoDic = notification.object as! NSDictionary
        let states = infoDic["resultStatue"] as! String
        var message = ""
        if  states == "9000"{
            HttpHelper.getUserInfo(withUserId: ShareManager.shareInstance().userinfo.id, success: { (data) in
                let dic = data! as NSDictionary
                let status = dic["status"] as! String
                print("status",status)
                if status == "0" {
                    let info = (dic["data"]! as! NSDictionary).object(by: UserInfo.self) as! UserInfo
                    self.userBean = Int(info.user_money)
                    print("ShareManager.shareInstance().userinfo.user_money",info.user_money)
                    self.beanNumLabel.text = String(self.userBean)
                    ShareManager.shareInstance().userinfo = info
                    Tool.saveUserInfo(toDB: true)
                    
                }
            }, fail: { (error) in
                
            })
        }
        
        if  states == "8000"{
            Tool.getUserInfo()
            message = "正在处理中,请稍候查看!"
         Tool.showPromptContent(message, on: self.view)
        }
        
    }
   

    
    //MARK: 游戏结束
    func endGame(data:NSDictionary)
    {
        
        weak var weakSelf = self
        print("endGamedata",data)
        weakSelf!.oneHundredBuyNum = 0
        weakSelf!.tenBuyNum = 0
        weakSelf!.sixBuyNum = 0
        weakSelf!.fiveBuyNum = 0
        weakSelf!.fourBuyNum = 0
        weakSelf!.threeBuyNum = 0
        
        let histeryDicArr = data["histeryWinList"] as! NSArray
        weakSelf!.collectArr.removeAll()
        for item in histeryDicArr{
            let histeryDic = item as! NSDictionary
            let model = histeryDic.object(by: HisteryModel.self) as! HisteryModel
            weakSelf!.collectArr.append(model)
        }
        weakSelf!.collectionView?.reloadData()
        
        let time = data["time"] as! Int
        let str = Tool.timeString(toDateSting: time.description, format: "ss")
        let timeInt = Int(str!)
       
        let tesults:Int = Int(data["winChoice"] as! String)!
        
        weakSelf!.perform(#selector(weakSelf!.startGame), with: nil, afterDelay: TimeInterval(60 - timeInt!) )
        
        //设置页面数据
        weakSelf!.setData(dic: data)
        weakSelf!.topLabelTitle()
        //大赢家
        weakSelf!.bigListArray.removeAll()
        let bigArr = data["bigWinRecord"] as!  NSArray
        for (i,item) in bigArr.enumerated(){
            let bigDict = item as! NSDictionary
            let model = bigDict.object(by: BigListModel.self) as! BigListModel
            if i == 0{
                weakSelf!.lastWinerNameLabel.text = model.nick_name
                weakSelf!.lastWinBeanNumLabel.text = model.win_money
                weakSelf!.lastWinerImageView.sd_setImage(with: URL(string: model.user_header), placeholderImage: UIImage(named:"avatar_header"))
            }
            weakSelf!.bigListArray.append(model)
        }
        
        
        let numDict = data["notOpenRecord"] as! NSDictionary
        
        weakSelf?.getNumWith(dict: numDict)
        
        weakSelf!.luckly(which: tesults)
        weakSelf!.currentChovie = tesults
        
        let a = animals[currentChovie-1]
//        print("angle\(a)")
        weakSelf!.luckyWheel?.stop(atAngle: Float((Double(a))*(.pi/180)))
       
    }
    
    //MARGK:开始游戏
    func startGame() {
        
        var s = 0
        self.notCanUse(isOpen: true)
        s = 48
        self.timerLabel.isHidden = false
        self.timeLeftImage.image = UIImage(named:"lottery_time_status_countdown")
        self.timerLabel.setCountDownTime(TimeInterval(s))
        self.timerLabel.reset()
        self.timerLabel.start()
        self.timeLeftImage.isHidden = false
        self.lastJiexiaoImage.isHidden = true
    }
    
    //MARK:    每个动物对应的旋转角度
    var animals = [0,240,120,300,180,60]
    var userBean = 0
     //MARK:对上面标签赋值topLabelTitle
    func topLabelTitle() {
        self.oneHundredTopLabel.text = "未下注"
        self.tenTopLabel.text = "未下注"
        self.sixTopLabel.text = "未下注"
        self.fiveTopLabel.text = "未下注"
        self.fourTopLabel.text = "未下注"
        self.threeTopLabel.text = "未下注"
    }
    
    var bigListArray:[BigListModel] = []
    
    var collectArr:[HisteryModel] = []
    
    //MARK:collectionView
    func initCollectionView(){

        self.scView.contentSize = CGSize(width: 10*(self.scView.frame.width-50)/4, height: 0)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: (self.scView.frame.width-50)/4, height: self.scView.frame.height)
        self.collectionView = UICollectionView(frame:CGRect(x: 0, y: 0, width: self.scView.contentSize.width, height: self.scView.frame.size.height), collectionViewLayout: layout)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.backgroundColor = UIColor.clear
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.register(UINib(nibName: "HistoryCell", bundle: nil), forCellWithReuseIdentifier: "historyCell")
        self.scView.addSubview(self.collectionView!)

    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        self.manager.reconnectSocket()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        manager.cutOffSocket()
    }
    
    //MARK:中奖动画（需要中奖小米去显示）
    func winAnmiationWith(beans:String) {
        
        let moveView = Bundle.main.loadNibNamed("MoveView", owner: self, options: nil)?.first as? MoveView
        moveView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-100, height:  UIScreen.main.bounds.size.width-100)
        moveView?.beanNumsLabbel.text = "+\(beans)"
        let alertVC = TYAlertController(alert: moveView, preferredStyle: .alert)
        alertVC?.backgoundTapDismissEnable = true
        alertVC?.backgroundColor = UIColor.clear       
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(alertVC!, animated: true, completion: nil)
    }
    
    
    func back() {
        if ShareManager.shareInstance().isEnterMK {
            self.navigationController?.popViewController(animated: true)
        }else{
        ShareManager.shareInstance().isEnterMK = true
        let entBarVC = EntTabBarViewController()
            self.navigationController?.pushViewController(entBarVC, animated: true)
            
        }

    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "米花糖大转盘"
        NotificationCenter.default.addObserver(self, selector: #selector(payNotifi(notification:)), name: NSNotification.Name(rawValue: "PaySuccess"), object: nil)
        
        let leftItemControl = UIControl(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        leftItemControl.addTarget(self, action:#selector(self.back), for: .touchUpInside)
        let back = UIImageView(frame: CGRect(x: 0, y: 12, width: 10, height: 18))
            back.image = UIImage(named: "new_back")
      
            leftItemControl.addSubview(back)
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftItemControl)
        
        
        self.timerLabel.delegate = self

        self.luckyWheel = LXLuckyWheel()
        self.luckyWheel?.imageView = self.rotaryImageView
        
        manager.connectToServer()
        
        self.initCollectionView()
        
        weak var weakSelf = self

        //MARK:规则按钮点击事件
        self.rulerBtn.whenTapped {
            let vc = RoRulerViewController()
            vc.view.backgroundColor = UIColor.clear
            //设置model的样式
            vc.modalPresentationStyle = .custom
            let rootVC = UIApplication.shared.keyWindow?.rootViewController
            rootVC?.present(vc, animated: true, completion: nil)
        }
        
        //MARK:大赢家点击事件
        self.bigListView.whenTapped {
            
            let vc = BighistoryViewController()
            vc.listModelArr = weakSelf!.bigListArray
            vc.view.backgroundColor = UIColor.clear
           
            //设置model的样式
            vc.modalPresentationStyle = .custom
            let rootVC = UIApplication.shared.keyWindow?.rootViewController
            rootVC?.present(vc, animated: true, completion: nil)
        }
        
        //MARK:购买成功后的block（闭包）
        manager.buyBlock = {
            dict in
            let dic = dict! as NSDictionary
            //设置页面数据
            weakSelf!.setData(dic: dic)
            weakSelf!.userBean -= weakSelf!.multiple
            let bean = String(weakSelf!.userBean)
            weakSelf!.beanNumLabel.text = bean
            
        }
        
        //MARK:买不了
        manager.canNotBlock = {
            (b) in
            weakSelf!.notCanUse(isOpen: false)
        }
        //MARK: 自己中奖后的block
        manager.myresultsBlock = {
            dict in
            let dic = dict! as NSDictionary
            let getBean = dic["win_count"] as! String
           
            let myGet = Int(getBean)
            weakSelf!.userBean += myGet!
            let bean = String(weakSelf!.userBean)
            weakSelf!.beanNumLabel.text = bean
            //中奖动画
            weakSelf!.winAnmiationWith(beans: getBean)
            
//            print("中奖成功dict:",dic)
        }
        
        //MARK:后台主动push的block
        manager.pushBlock = {
            dict in
            let dic = dict! as NSDictionary
//             print("推送成功dict:",dic)
            if dic["time"] != nil && weakSelf!.isFirst{
                weakSelf!.isFirst = false
                let time = dic["time"] as! Int
                let str = Tool.timeString(toDateSting: time.description, format: "ss")
                let timeInt = Int(str!)
                //设置时间
                weakSelf!.setTimeLabelWithTime(time: timeInt!)
            }
          
            //设置页面数据
            weakSelf!.setData(dic: dic)
//            print("推送成功dict:",dic)
        }

        //MARK:返回结果block
        manager.resultsBlock = {
            dict in
            
            weakSelf!.isFirst = true
            let dic = dict! as NSDictionary
            weakSelf!.endGame(data:dic)
//            print("返回结果")
        }
 

        //MARK:登陆成功后的block
        manager.loginBlock = {
            dict in
            
            let dic = dict! as NSDictionary
            weakSelf?.loginSucess(dic: dic)
           
        }
         

 
        self.lastWinerImageView.layer.masksToBounds = true
        self.lastWinerImageView.layer.cornerRadius = self.lastWinerImageView.frame.size.height/2
        
        var image = UIImage(named: "lottery_yellow_bg")
        let top:CGFloat = 5
        let bottom:CGFloat = 5
        let left:CGFloat = 5
        let right:CGFloat = 5
        let insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        image = image?.resizableImage(withCapInsets: insets, resizingMode: .stretch)
        lottery_yellow_bg.image = image

        
        oneHundredBtn.layer.masksToBounds = true
        oneHundredBtn.layer.cornerRadius = oneHundredBtn.frame.height/2
        
        tenBtn.layer.masksToBounds = true
        tenBtn.layer.cornerRadius = tenBtn.frame.height/2
        
        sixBtn.layer.masksToBounds = true
        sixBtn.layer.cornerRadius = sixBtn.frame.height/2
        
        fiveBtn.layer.masksToBounds = true
        fiveBtn.layer.cornerRadius = fiveBtn.frame.height/2
        
        fourBtn.layer.masksToBounds = true
        fourBtn.layer.cornerRadius = fourBtn.frame.height/2
        
        threeBtn.layer.masksToBounds = true
        threeBtn.layer.cornerRadius = threeBtn.frame.height/2
        
    }
    
    //    MARK:频次统计
    func getNumWith(dict:NSDictionary){
    
        let model = dict.object(by: RotaryNumModel.self) as! RotaryNumModel
        self.longNum.text = "\(model.num1!)"
        self.tigerNum.text = "\(model.num2!)"
        self.nangNum.text = "\(model.num3!)"
        
    }
    
    //MARK:登陆成功
    func loginSucess(dic:NSDictionary) {
        
        weak var weakSelf = self
        
        let histeryDicArr = dic["histeryWinList"] as! NSArray
        
        weakSelf!.collectArr.removeAll()
        for item in histeryDicArr{
            let histeryDic = item as! NSDictionary
            let model = histeryDic.object(by: HisteryModel.self) as! HisteryModel
            weakSelf!.collectArr.append(model)
        }
        
        let choice = Int(collectArr.last!.win_choice)
        let angel = self.animals[choice!-1]
        let cgaRotate = CGAffineTransform(rotationAngle: CGFloat((Double(angel))*(Double.pi/180)))
        self.rotaryImageView.transform = cgaRotate
        
        weakSelf!.collectionView?.reloadData()
        
        let time = dic["time"] as! Int
        let str = Tool.timeString(toDateSting: time.description, format: "ss")
        let timeInt = Int(str!)
        //设置时间
        weakSelf!.setTimeLabelWithTime(time: timeInt!)
        //设置页面数据
        weakSelf!.setData(dic: dic)
        
        //大赢家
        weakSelf!.bigListArray.removeAll()
        let bigArr = dic["bigWinRecord"] as!  NSArray
        for (i,item) in bigArr.enumerated(){
            let bigDict = item as! NSDictionary
            let model = bigDict.object(by: BigListModel.self) as! BigListModel
            if i == 0{
                weakSelf!.lastWinerNameLabel.text = model.nick_name
                weakSelf!.lastWinBeanNumLabel.text = model.win_money
                weakSelf!.lastWinerImageView.sd_setImage(with: URL(string: model.user_header), placeholderImage: UIImage(named:""))
            }
            weakSelf!.bigListArray.append(model)
        }
        
        let numDict = dic["notOpenRecord"] as! NSDictionary
        
        weakSelf?.getNumWith(dict: numDict)
        //小米
        let userDic = dic["user_map"]! as! NSDictionary
        weakSelf!.userBean = userDic["user_money"] as! Int
        let bean = String(weakSelf!.userBean)
        weakSelf!.beanNumLabel.text = bean
        
//        print("登陆成功dict:",dic)
        
    }
    
    
    
    //MARK:倒计时label代理
    func timerLabel(_ timerLabel: MZTimerLabel!, finshedCountDownTimerWithTime countTime: TimeInterval) {
        self.notCanUse(isOpen: false)
        self.timerLabel.isHidden = true
        self.timeLeftImage.isHidden = true
        self.lastJiexiaoImage.isHidden = false

        self.luckyWheel?.start()
    }
    
    
    @IBAction func MultipleBtnClick(_ sender: Any) {
//       跳转押注倍数界面
        let vc = BetSelectedViewController()
        vc.mutlipy = multiple/100
        vc.delegate = self
        vc.view.backgroundColor = UIColor.clear
        //设置model的样式
        vc.modalPresentationStyle = .custom

        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(vc, animated: true, completion: nil)
    }
    
    //MARK:GetBetSelectedDelegate从下注倍数按钮界面传旨回来
    func getBetNum(num: Int) {
        self.multiple = num*100
//        print("multiple",multiple);
        if multiple == 10000 {
            self.mutipleLabel.text = "1万"
        }else if self.multiple == 100000{
            self.mutipleLabel.text = "10万"
        }else{
            self.mutipleLabel.text = "\(self.multiple)"
        }
        
    }
    
    //MARK:向服务器传送购买数据
    func sendDataToSever(type:Int,num:Int) {
        let parameters = NSMutableDictionary()
        parameters.setValue("\(type)", forKey:"fight_choice")
        parameters.setValue("\(num)", forKey: "fight_count")
        
        let data = try? JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions(rawValue: 0))
        if data != nil {
            let jsonData = NSMutableData()
            jsonData.append((manager.getCPackageData(withModul: 5, cmd: 3))!)
            jsonData .append(YMSocketUtils.bytes(from: UInt32((data?.count)!)))
            jsonData.append(data!)
            manager.socket.write(jsonData as Data, withTimeout: -1, tag: 200)
        }
    }
    //MARK:在购买的时候小米不足
    func notMoney(btn:UIButton) {
        
//        _ = NSDate()
       
//        print("date.second>>>>>>>", date.second)
        
        if self.userBean < self.multiple {
            Tool.showPromptContent("小米不足,请先获取小米", on: self.view)
            return
        }else{

//            print("上传数据")
            self.sendDataToSever(type: btn.tag, num: multiple)
            btn.setImage(UIImage(named:"lottery_bet_select.png"), for: .normal)
        }
    }
  
    //    MARK:100点击事件
    
    @IBAction func oneHundredBtnClick(_ sender: Any) {
        
        //判断是否有有钱
        self.notMoney(btn: sender as! UIButton)
    }
    
    //    MARK:10点击事件
    @IBAction func tenBtnClick(_ sender: Any) {
        self.notMoney(btn: sender as! UIButton)
        
    }
    
    
    //    MARK:6点击事件
    @IBAction func sixBtnClick(_ sender: Any) {
         self.notMoney(btn: sender as! UIButton)

    }
    //    MARK:5点击事件
    @IBAction func fiveBtnClick(_ sender: Any) {
         self.notMoney(btn: sender as! UIButton)
    }
    //   MARK:4点击事件
    
    @IBAction func fourBtnClick(_ sender: Any) {
         self.notMoney(btn: sender as! UIButton)
    }
    //    MARK:3点击事件
    
    @IBAction func threeBtnClick(_ sender: Any) {
        self.notMoney(btn: sender as! UIButton)
        
    }
    
    
    //    MARK:_充值按钮
    
    @IBAction func getBeanClick(_ sender: Any) {
        
        let vc = EntBuyViewController()
        self.navigationController?.pushViewController(vc, animated: true)
//        let magicMove = MagicMoveTransition()
//        self.navigationController?.pushViewController(vc, animated: true, transition: magicMove)
    }
    
    //MARK:collectionViewDelegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectArr.count
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "historyCell", for: indexPath) as! HistoryCell
        
        if indexPath.row == 0 {
            cell.titleImageView.isHidden = false
        }else{
            cell.titleImageView.isHidden = true
        }
//        self.collectArr = self.collectArr.reversed()
        cell.model = self.collectArr[self.collectArr.count-1-indexPath.row]
       
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 0, 0, 10)
    }
    
   
    //MARK:走势图左右按钮
    @IBAction func backCollectionClick(_ sender: Any) {
        self.scView.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    
    @IBAction func rightColectionClick(_ sender: Any) {
        self.scView.setContentOffset(CGPoint(x:5*(self.scView.frame.width-50)/4,y:0), animated: true)
    }
    
    
    
}
