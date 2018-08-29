//
//  ChartCell.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/11/2.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit


protocol ChartDelegate{
  //定义传值协议
    func sendBuyNum(num:Int)//给vc传购买数量
    func sendChartNum(num:Int)//给vc传查看的期数
    
    func stopTimer()
    func startTimer()

}

class ChartCell: UITableViewCell,UIScrollViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var buyLabel: UILabel!
    
    @IBOutlet weak var tou: UILabel!
    @IBOutlet weak var hou: UILabel!
    
    @IBOutlet weak var qian: UILabel!
    @IBOutlet weak var zhong: UILabel!
    @IBOutlet weak var buyNumTextField: UITextField!
    @IBOutlet weak var two: UILabel!
    @IBOutlet weak var three: UILabel!
    
    @IBOutlet weak var one: UILabel!
    var delegate:ChartDelegate?
    
    @IBOutlet weak var numLeftBtn: UIButton!
    @IBOutlet weak var numRightBtn: UIButton!
    @IBOutlet weak var chartView: UIScrollView!
    
    @IBOutlet weak var chartNumLeftBtn: UIButton!
    
    @IBOutlet weak var chartNumRightBtn: UIButton!
    
    @IBOutlet weak var chartNumLabel: UILabel!
    
    @IBOutlet weak var lastDesLabel: UILabel!
    
    @IBOutlet weak var currentLabel: UILabel!
    
    @IBOutlet weak var salledNumLabel: UILabel!
    
    @IBOutlet weak var remainNumLabel: UILabel!
    
    @IBOutlet weak var allNumLabel: UILabel!
    
    @IBOutlet weak var myNumLabel: UILabel!
    @IBOutlet weak var myFlagLabel: UILabel!
    
    @IBOutlet weak var progView: LDProgressView!
    
    @IBOutlet weak var secondRight: NSLayoutConstraint!
    
    @IBOutlet weak var threeRight: NSLayoutConstraint!
    
    @IBOutlet weak var fourRight: NSLayoutConstraint!
    
    @IBOutlet weak var firstRight: NSLayoutConstraint!
    
    @IBOutlet weak var labelWidth: NSLayoutConstraint!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var scendLabel: UILabel!
    @IBOutlet weak var threeLabel: UILabel!
    @IBOutlet weak var fourLabel: UILabel!
    
    
    @IBOutlet weak var chartBgView: UIView!
    @IBOutlet weak var joinLabel: UILabel!
    
    var isBuyNum:Bool = true
    var buyNum:Int?{
        didSet{
           buyNumTextField.text = String(buyNum!)

        }
    }
    var lookNum:Int?{
        didSet{
          chartNumLabel.text = String(lookNum!)
        }
    }
    var lineChart:PNLineChart?
    var isShowChart:Bool?{
        didSet{
            if isShowChart! {
                if ((self.chartModels?.count)!>0){
                    self.lineChart?.removeFromSuperview()
                    self.chartView.backgroundColor = UIColor.white
                   self.createChart(dataArr: chartModels!,isBuyNum: self.isBuyNum)
                }
            }else{
               self.lineChart?.removeFromSuperview()
                self.chartView.backgroundColor = UIColor.white
            }
        }
    }
    var chartModels:[ChartWinListModel]?
    var goodModel:GoodsDetailInfo?{
        didSet{
            
            let salledStr:NSString = "已售：\((self.goodModel?.now_people)!)次" as NSString
            let salled:NSString = (self.goodModel?.now_people)! as NSString
            let attributeSalled = NSMutableAttributedString.init(string: salledStr as String)
            attributeSalled.addAttributes([NSForegroundColorAttributeName: UIColor.red], range:salledStr.range(of: salled as String))
           salledNumLabel.attributedText = attributeSalled
            
            
            let remainStr:NSString = "剩余：\((self.goodModel?.remainderCount())!)次" as NSString
            let remain:NSString = (self.goodModel?.remainderCount().description)! as NSString
            let attributeRemain = NSMutableAttributedString.init(string: remainStr as String)
            attributeRemain.addAttributes([NSForegroundColorAttributeName: UIColor.red], range:remainStr.range(of: remain as String))
            remainNumLabel.attributedText = attributeRemain

            
            let allStr:NSString = "总需：\((self.goodModel?.need_people)!)次" as NSString
            let all:NSString = (self.goodModel?.need_people)! as NSString
            let attributeAll = NSMutableAttributedString.init(string: allStr as String)
            attributeAll.addAttributes([NSForegroundColorAttributeName: UIColor.red], range:allStr.range(of: all as String))
            allNumLabel.attributedText = attributeAll
            
            currentNum = self.goodModel?.now_people
            needNum = self.goodModel?.need_people
            currentLabel.text = "正在进行：第\((self.goodModel?.good_period)!)期"
            
        }
    }
    var currentNum:String?
    var timer:Timer?
    var good_fight_id:String?{
        didSet{

        }
        
    }

    var needNum:String?{
        didSet{
            let all:CGFloat = CGFloat((needNum! as NSString).floatValue)
            let a:CGFloat = CGFloat((currentNum! as NSString).floatValue)
            progView.progress = a/all
           
        }
 
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        progView.background = UIColor(fromHexString: "CCCCCC")
        progView.color = UIColor(fromHexString: "ED533B")
        progView.showText = false;
        progView.showBackgroundInnerShadow = false
        progView.showStroke = false
        progView.flat = false
        progView.type = LDProgressSolid
        progView.animate = false
        
        
        self.buyNumTextField.delegate = self

        chartView.delegate = self
        numLeftBtn.addTarget(self, action: #selector(subBuyNum), for: .touchUpInside)
        numRightBtn.addTarget(self, action: #selector(addBuyNum), for: .touchUpInside)
        
        chartNumLeftBtn.addTarget(self, action: #selector(subLook), for: .touchUpInside)
        
        chartNumRightBtn.addTarget(self, action: #selector(addLook), for: .touchUpInside)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 禁止左拉
        if scrollView.contentOffset.x <= 0 {
            scrollView.contentOffset.x = 0
        }
        print("?????????")
        // 禁止右拉
        if scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.bounds.size.width {
            scrollView.contentOffset.x = scrollView.contentSize.width - scrollView.bounds.size.width
        }
    }
   
    
    func createChart(dataArr:[ChartWinListModel],isBuyNum:Bool) {
        
        var xLabelArray:[String] = []
        var yLabelArray:[String] = []
        var yValueArray:[Int] = []
        for model in dataArr {
            if yLabelArray.count == 0{
                yLabelArray =  ["0","\(Int(model.need_people!)!/4)","\(2*Int(model.need_people!)!/4)","\(3*Int(model.need_people!)!/4)","\(model.need_people!)"]
            }
            
            let x = model.good_period
            xLabelArray.append(x!)
            if (!isBuyNum){
                let y = Int(model.buy_seating!)!+1
                yValueArray.append(y)
            }else{
                let y = Int(model.win_num!)!%10000000
                yValueArray.append(y)
            }
        }
        
        //控制显示的期数x
        var xArray:[String] = []
        
        for (i,item) in xLabelArray.enumerated() {
            if (i<lookNum!){
//                print("ii>>>>>>>",i)
                xArray.append(item)

            }
        }

        self.chartView.backgroundColor = UIColor.white
        self.chartView.isScrollEnabled = true
         let w = UIScreen.main.bounds.width
        
        lineChart = PNLineChart(frame: CGRect(x: 0, y: 0, width:self.chartView.frame.width, height: self.chartView.frame.height))
        lineChart?.backgroundColor = UIColor.white
        lineChart?.yLabelFont = UIFont.systemFont(ofSize: 10)
        lineChart?.xLabelFont = UIFont.systemFont(ofSize: 10)
        lineChart?.chartCavanWidth = self.chartView.frame.width
        lineChart?.chartCavanHeight = self.chartView.frame.size.height-50
        lineChart?.yLabelFormat = "1"
        lineChart?.setXLabels(xArray, withWidth: (w-80)/CGFloat(lookNum!))
        lineChart?.isShowCoordinateAxis = false
        lineChart?.axisColor = UIColor.black
        lineChart?.yGridLinesColor = UIColor.gray
        lineChart?.showYGridLines = true
        lineChart?.yFixedValueMax = CGFloat((yLabelArray.last! as NSString).floatValue)
        lineChart?.yFixedValueMin = 0
        lineChart?.yLabels = yLabelArray

        var data:[Int] = []
        //控制显示的期数。然后倒叙
        for (i,item) in yValueArray.enumerated() {
            if (i<lookNum!){
               data.append(item)
            }
        }
       
        let pnData = PNLineChartData()
        pnData.color = UIColor(fromHexString: "EF2F48")
        pnData.itemCount = UInt(data.count)
        pnData.inflexionPointColor =  UIColor(fromHexString: "EF2F48")
        pnData.inflexionPointStyle = .circle
        pnData.showPointLabel = true
        pnData.pointLabelFont = UIFont.systemFont(ofSize: 12)
        pnData.pointLabelColor = UIColor.black
        
        pnData.getData = {
            (index) in
            let a = Int(index)
            let yValue:NSString = data[a].description as NSString
            return PNLineChartDataItem(y: CGFloat(yValue.floatValue))
        }
        lineChart?.chartData = [pnData]
        
        lineChart?.stroke()
        self.chartView.addSubview(lineChart!)
        
        let b:Double = ((goodModel?.now_people)! as NSString).doubleValue
        let a:Double = b/((goodModel?.need_people)! as NSString).doubleValue
        lineChart?.nowY = (lineChart?.chartMarginTop)!-1+(lineChart?.chartCavanHeight)!-CGFloat(a)*(lineChart?.chartCavanHeight)! 
        
        lineChart?.zeroY = (lineChart?.chartMarginTop)!-1+(lineChart?.chartCavanHeight)!
        
        if ((goodModel?.need_people)! as NSString).doubleValue == b {
             lineChart?.buyY = (lineChart?.chartMarginTop)!-1+(lineChart?.chartCavanHeight)!-CGFloat(a)*(lineChart?.chartCavanHeight)!
        }else{
             lineChart?.buyY = (lineChart?.chartMarginTop)!-1+(lineChart?.chartCavanHeight)!-CGFloat(a)*(lineChart?.chartCavanHeight)!-CGFloat(Double(buyNum!)/((goodModel?.need_people)! as NSString).doubleValue)*(lineChart?.chartCavanHeight)!
        }
       

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        self.delegate?.sendBuyNum(num: (textField.text! as NSString).integerValue)
        self.delegate?.startTimer()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.delegate?.stopTimer()
        return true
    }
    
    
    func subBuyNum() {
        if buyNum!<=1 {
            buyNum = 1
        }else{
            buyNum!-=1
        }
        buyNumTextField.text = String(buyNum!)
        self.delegate?.sendBuyNum(num: buyNum!)
    }
    
    
    
    func addBuyNum() {
        buyNum!+=1
        buyNumTextField.text = String(buyNum!)
        self.delegate?.sendBuyNum(num: buyNum!)
    }
    
    func subLook() {
        if lookNum!<=1 {
            lookNum = 1
        }else{
            lookNum!-=1
        }
        chartNumLabel.text = String(lookNum!)
        self.delegate?.sendChartNum(num: lookNum!)
        
    }
    
    func addLook() {
        if lookNum! >= 30 {
           lookNum = 30
        }else{
          lookNum! += 1
        }
        
     chartNumLabel.text = String(lookNum!)
     self.delegate?.sendChartNum(num: lookNum!)
    }

   
}
