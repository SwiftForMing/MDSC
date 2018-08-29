//
//  GlobalFile.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/15.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import Foundation

let kWidth:CGFloat = UIScreen.main.bounds.width
let kHeight:CGFloat = UIScreen.main.bounds.height
let navHeight:CGFloat = kHeight == 812.0 ? 88:64
let xBottomHeight:CGFloat = kHeight == 812.0 ? 34:0
let kLoginSuccess = "LoginSuccess"
let kUpdateUserInfo = "kUpdateUserInfo"
let kWeiXinPayNotif = "kWeiXinPayNotif"
let kTimeValue = 60


// MARK:  首页
//获取基础数据
let  URL_HomeBasics = "appInterface/getIndexData.jhtml"
//获取人气推荐
let URL_Recommend = "appInterface/getIndexGoodsList.jhtml"
//获取人气推荐
let URL_BeanList = "appInterface/getBeanGoodsList.jhtml"
//截图
let URL_CutPhoto = "appInterface/screenshot.jhtml"

//获取分类数据
let URL_GetGoodsType = "appInterface/getGoodsTypeData.jhtml"

let Wap_PayMoneyView = "appInterface/paymentGoodsFightIndex.jhtml?"
let Wap_AboutDuobao = "appInterface/aboutUsContentInfo.jhtml?"

//游戏
//水果
//http://g.zhimalegou.com/TaoGame/gApi/fruits/index.jhtml?token=VK4NmjhnVQDKGTrCpWUoUKhxbRufTeg0PvuzTJFFTfc&request_time=1521792525676
let URL_Game_Fruits = "http://g.zhimalegou.com/TaoGame/gApi/fruits/index.jhtml"
//qq人数
//http://g.zhimalegou.com/TaoGame/gApi/qqQuiz/index.jhtml?token=VK4NmjhnVQDKGTrCpWUoUKhxbRufTeg0PvuzTJFFTfc&request_time=1521792525676
let URL_Game_QQQuiz = "http://g.zhimalegou.com/TaoGame/gApi/qqQuiz/index.jhtml"
//还有两款不能用的：下个星期上
//时时彩：
//http://g.zhimalegou.com/TaoGame/gApi/ssc/index.jhtml?token=VK4NmjhnVQDKGTrCpWUoUKhxbRufTeg0PvuzTJFFTfc&request_time=1521792525676
let URL_Game_SSC = "http://g.zhimalegou.com/TaoGame/gApi/ssc/index.jhtml"
//保龄球：
//http://g.zhimalegou.com/TaoGame/gApi/bowling/index.jhtml?token=VK4NmjhnVQDKGTrCpWUoUKhxbRufTeg0PvuzTJFFTfc&request_time=1521792525676
let URL_Game_Bowling = "http://g.zhimalegou.com/TaoGame/gApi/bowling/index.jhtml"



extension UIView{
    func setzGradient(leftColor:String,right:String){
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(fromHexString: leftColor).cgColor,UIColor(fromHexString: right).cgColor]
        //(这里的起始和终止位置就是按照坐标系,四个角分别是左上(0,0),左下(0,1),右上(1,0),右下(1,1))
        //渲染的起始位置
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        //渲染的终止位置
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        //设置frame和插入view的layer
        gradientLayer.frame = self.bounds
        
        self.layer.addSublayer(gradientLayer)
       
    }
    
    func setyGradient(upColor:String,bottom:String){
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(fromHexString: upColor).cgColor,UIColor(fromHexString: bottom).cgColor]
        //(这里的起始和终止位置就是按照坐标系,四个角分别是左上(0,0),左下(0,1),右上(1,0),右下(1,1))
        //渲染的起始位置
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        //渲染的终止位置
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        //设置frame和插入view的layer
        gradientLayer.frame = self.bounds
        
        self.layer.addSublayer(gradientLayer)
        
    }
}


