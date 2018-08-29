//
//  NewCalerderViewController.swift
//  TangDouShangCHeng
//
//  Created by 黎应明 on 2018/6/12.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class NewCalerderViewController: BaseViewController {

    var carlerLabel:UILabel?
    var liftLabel:UILabel?
    var scoreLabel:UILabel?
    
    var score:String?{
        didSet{
            if self.score != "0"{
                self.scoreLabel?.text = "签到成功赠送\(score!)欢乐豆"
            }
        }
    }
    var lift:String?{
        didSet{
            if !ShareManager.shareInstance().isInReview && self.lift != "0"{
                self.liftLabel?.text = "今日首充¥10，嘉奖百分之\(lift!)（今天所有中奖将返\(Double(lift!)!/10)%米豆，由系统自动结算）"
//
            }
        }
    }
    var todayStauts:String?{
        didSet{
            if todayStauts == "1" {
                jionBtn?.setImage(UIImage(named: "carlerderqd"), for: .normal)
                jionBtn?.isUserInteractionEnabled = false
            }
            if todayStauts == "0" {
                jionBtn?.setImage(UIImage(named: "qdImg"), for: .normal)
                jionBtn?.isUserInteractionEnabled = true
                jionBtn?.whenTapped({
                    self.qianDaoWith(tag: "week_status")
                })
            }
            
        }
    }
    var cumulativeModel:Cumulativemodel?{
        didSet{
            if cumulativeModel?.continue_day_num != "0" {
                let num = Int((cumulativeModel?.continue_day_num)!)!
                self.carlerLabel?.text = "连续签到\(num)天了,累计签到获取奖励～"
                for i in 0..<num{
                    dayImageArr[i].image = UIImage(named: "carlerderGift")
                }
            }else{
                for i in 0..<dayImageArr.count{
                    dayImageArr[i].image = UIImage(named: "carlerderGiftS")
                }
            }
            
            if cumulativeModel?.first_status == "n"{
                threeImageArr[0].setImage(UIImage(named: "carlerderBX"), for: .normal)
                threeImageArr[0].whenTapped {
                    self.qianDaoWith(tag: "first_status")
                }
            }else{
                threeImageArr[0].setImage(UIImage(named: "carlerderBXS"), for: .normal)
                threeLabelArr[0].image = UIImage(named: "carlerderLqtlS")
                threeImageArr[0].whenTapped {
                   
                  
                }
            }
            
            if cumulativeModel?.second_status == "n"{
                threeImageArr[1].setImage(UIImage(named: "carlerderBX"), for: .normal)
                threeImageArr[1].whenTapped {
                    self.qianDaoWith(tag: "second_status")
                }
            }else{
                threeImageArr[1].setImage(UIImage(named: "carlerderBXS"), for: .normal)
               threeLabelArr[1].image = UIImage(named: "carlerderLqtlS")
            }
            
            if cumulativeModel?.third_status == "n"{
               threeImageArr[2].setImage(UIImage(named: "carlerderBX"), for: .normal)
                threeImageArr[2].whenTapped {
                   self.qianDaoWith(tag: "third_status")
                }
                
            }else{
                threeImageArr[2].setImage(UIImage(named: "carlerderBXS"), for: .normal)
                threeLabelArr[2].image = UIImage(named: "carlerderLqtlS")
            }
           
        }
    }
    
    var jionBtn:UIButton?
    var dayImageArr:[UIImageView] = []
    var threeImageArr:[UIButton] = []
     var threeLabelArr:[UIImageView] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        todayStauts = "1"
        self.navigationController?.navigationBar.isHidden = true;
        
        var height:CGFloat = 0
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: -20, width: kWidth, height: kHeight))
        scrollView.backgroundColor = UIColor(fromHexString: "E5E4E4")
        
        self.view.addSubview(scrollView)
        // 日历加导航 bg
        let carlerView = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 270+64))
        height += carlerView.frame.size.height
        //导航
        let navView = UIView(frame: CGRect(x: 0, y: 0, width: kWidth, height: 64))
        navView.backgroundColor = UIColor(fromHexString: "f9445c")
        carlerView.addSubview(navView)
        //导航圆角
        let navWhite = UIImageView(frame: CGRect(x: 25, y: 25, width: kWidth-50, height: 44))
        navWhite.backgroundColor = UIColor.white
        navWhite.alpha = 0.2
        let maskPath = UIBezierPath(roundedRect: navWhite.bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: navWhite.bounds.size)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = navWhite.bounds
        maskLayer.path = maskPath.cgPath
        navWhite.layer.mask = maskLayer
        navView.addSubview(navWhite)
        //导航标题
        let titleLabel = UILabel(frame: CGRect(x: kWidth/2-50, y: 30, width: 100, height: 20))
        
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM"
        let strNowTime = timeFormatter.string(from: date as Date) as String
        
        titleLabel.text = strNowTime
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        navView.addSubview(titleLabel)
        
//        日历bg
        let carlerBg = UIView(frame: CGRect(x: 25, y: 64, width: kWidth-50, height: 270))
        carlerBg.backgroundColor = UIColor.white
        carlerView.addSubview(carlerBg)
        
        self.carlerLabel = UILabel(frame: CGRect(x: 0, y: 10, width: kWidth-50, height: 25))
        self.carlerLabel?.textColor = UIColor(fromHexString: "2A2A2A")
        self.carlerLabel?.text = "连续签到0天了,累计签到获取奖励～"
        self.carlerLabel?.font = UIFont.systemFont(ofSize: 10)
        self.carlerLabel?.textAlignment = .center
        carlerBg.addSubview(self.carlerLabel!)
        
//        日历
        let carlerder = BSLCalendar(frame: CGRect(x: 50, y: 100, width: kWidth-100, height: 170))
        carlerder.showChineseCalendar = false
        
        carlerder.selectDate { (year, month, day) in
            print("\(year)年\(month)月\(day)")
        }
        carlerView.addSubview(carlerder)
        self.liftLabel = UILabel(frame: CGRect(x: 0, y: carlerder.frame.origin.y+170, width: kWidth-50, height: 35))
        self.liftLabel?.textColor = UIColor(fromHexString: "2A2A2A")
        self.liftLabel?.text = ""
        self.liftLabel?.numberOfLines = 0
        self.liftLabel?.font = UIFont.systemFont(ofSize: 10)
        self.liftLabel?.textAlignment = .center
        carlerBg.addSubview(self.liftLabel!)
        
        
        
        let qdBtn = UIButton(frame: CGRect(x: kWidth/2-60, y: carlerder.frame.origin.y+170+10, width: 120, height: 30))

        qdBtn.setImage(UIImage(named: "qdImg"), for: .normal)
        jionBtn = qdBtn
        carlerView.addSubview(qdBtn)
        
        self.scoreLabel = UILabel(frame: CGRect(x: 25, y:(qdBtn.bottom), width: kWidth-50, height: 25))
        self.scoreLabel?.textColor = UIColor(fromHexString: "2A2A2A")
        self.scoreLabel?.text = ""
        self.scoreLabel?.font = UIFont.systemFont(ofSize: 10)
        self.scoreLabel?.textAlignment = .center
        carlerView.addSubview(self.scoreLabel!)
        
        scrollView.addSubview(carlerView)
        
//        累计签到视图
//        每天签到领奖img
        let qdImg = UIImageView(frame: CGRect(x: 25, y: carlerView.frame.origin.y+carlerView.frame.size.height+30, width: 24, height: 23))
        qdImg.image = UIImage(named: "carlerderSC")
        height += (qdImg.frame.size.height+30)
        scrollView.addSubview(qdImg)
        
        let qdLabel = UILabel(frame: CGRect(x: 25+qdImg.frame.size.width+15, y: qdImg.frame.origin.y, width: kWidth-(50+qdImg.frame.size.width+15), height: 23))
        qdLabel.textColor = UIColor(fromHexString: "4e4d4d")
       
        qdLabel.text = "每天签到领奖"
        qdLabel.font = UIFont.systemFont(ofSize: 14)
        scrollView.addSubview(qdLabel)
        
//        签到Img
        let qdImgView = UIView(frame: CGRect(x: 25, y: qdImg.frame.origin.y+qdImg.frame.size.height+5, width: kWidth-50, height: 110))
        scrollView.addSubview(qdImgView)
        height += (qdImgView.frame.size.height+5)
        let xArrary = [(kWidth/2-23)-48-46,(kWidth/2-23)-24,(kWidth/2+23),(kWidth/2+23)+24+46];
        let xArrary1 = [(kWidth/2-11)-48-22,(kWidth/2-11),(kWidth/2-11)+48+11];
        for i in 0...6 {
            let imageView = UIImageView()
           
            if i < 4{
                imageView.frame = CGRect(x: xArrary[i]-25, y: 10, width: 22, height: 24)
                imageView.image = UIImage(named: "carlerderGiftS")

            
            }else{
                imageView.frame = CGRect(x: xArrary1[i-4]-25, y:70, width: 22, height: 24)
                imageView.image = UIImage(named: "carlerderGiftS")

            }
            qdImgView.addSubview(imageView)
            dayImageArr.append(imageView)
           
        }
        
 //        奖励
        let qdLJImg = UIImageView(frame: CGRect(x: 25, y: qdImgView.frame.origin.y+qdImgView.frame.size.height+10, width: 24, height: 23))
        qdLJImg.image = UIImage(named: "carlerderLJ")
        height += (10+qdLJImg.frame.size.height)
        scrollView.addSubview(qdLJImg)

        let qdJLLabel = UILabel(frame: CGRect(x: 25+qdLJImg.frame.size.width+15, y: qdLJImg.frame.origin.y, width: 150, height: 23))
        qdJLLabel.textColor = UIColor(fromHexString: "4e4d4d")
        qdJLLabel.text = "累计签到领大奖"
        qdJLLabel.font = UIFont.systemFont(ofSize: 14)
        scrollView.addSubview(qdJLLabel)
        
//        奖励Img
        let qdJLImgView = UIView(frame: CGRect(x: 25, y: qdLJImg.frame.origin.y+qdLJImg.frame.size.height+5, width: kWidth-50, height: 60))
//        qdJLImgView.backgroundColor = UIColor.white
        scrollView.addSubview(qdJLImgView)
        height += (qdJLImgView.frame.size.height+10)
        let xArrary2 = [(kWidth/2-11)-48-22,(kWidth/2-11),(kWidth/2+11)+48];
        for i in 0...2 {
            let btn = UIButton()
            let labelImage = UIImageView()
           
            btn.frame = CGRect(x: xArrary2[i]-25, y: 10, width: 22, height: 24)
            btn.setImage(UIImage(named: "carlerderBX"), for: .normal)
            labelImage.frame = CGRect(x: xArrary2[i]-25-3, y: 10+24+5, width: 28, height: 11)
            labelImage.image = UIImage(named: "carlerderLqtl")
          
            qdJLImgView.addSubview(btn)
            qdJLImgView.addSubview(labelImage)
            
            threeImageArr.append(btn)
            threeLabelArr.append(labelImage)
        }
       
        if kHeight<height+50 {

//            scrollView.frame = CGRect(x: 0, y: 0, width: kWidth, height: height)
           scrollView.contentSize = CGSize(width: 0, height: height)
        }else{
             scrollView.isScrollEnabled = false
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getQianDaoLoginDate()
    }
    
    
    func qianDaoWith(tag:String){
        if !Tool.islogin() {
            Tool.showPromptContent("未登录")
        }else{
            if(ShareManager.shareInstance().userinfo.id != ""){
                HttpHelper.qianDao(withUserId: ShareManager.shareInstance().userinfo.id, tag: tag,success: { (data) in
                    let dic = data! as NSDictionary
                    print("dicdicdic",dic)
                    let status = dic["status"] as! String
                    if status == "0"{
                        let dict = dic["data"] as! NSDictionary
                        let money = dict["money"] as! Int
                        let score = dict["score"] as! Int
                        print("score",score)
                        self.score = "\(score)"
                        if(tag == "week_status"){
                            let lift = dict["lift"] as! String
                            self.lift = lift
                        }
                        
                        RewardSuccess.show(withTitle: "领取奖励成功", withExperience: money)
                        let sound = SoundManager() //跟哥们联系
                        sound.loadaudioFile(soundType: SoundManager.SoundType.mi) //取到指定音频
                        sound.playSound()
                        self.getQianDaoLoginDate()
                    }else{
                        Tool.showPromptContent(dic["desc"] as! String)
                    }
                    
                }) { (error) in
                    Tool.showPromptContent("网络请求失败")
                }
                
            }
        }
    }
    
    func getQianDaoLoginDate() {
        
        if !Tool.islogin() {
            Tool.showPromptContent("未登录")
        }else{
            if(ShareManager.shareInstance().userinfo.id != ""){
                HttpHelper.getQianDaoDate(withUserId: ShareManager.shareInstance().userinfo.id, success: { (data) in
                    let dic = data! as NSDictionary
                    print("getQianDaoLoginDate",dic)
                    let status = dic["status"] as! String
                    if status == "0"{
                        let dict = dic["data"] as! NSDictionary
                       
                        let status1 = dict["today_signin_status"] as! String
                        self.todayStauts = status1
                        let cumulativedic = dict["cumulativemap"] as! NSDictionary
                        let model = cumulativedic.object(by: Cumulativemodel.self) as! Cumulativemodel
                        self.cumulativeModel = model
                    }else{
                        Tool.showPromptContent(dic["desc"] as! String)
                    }

                }) { (error) in
                    Tool.showPromptContent("网络请求失败")
                }
                
            }
        }
        
        
    }

    
    
}
