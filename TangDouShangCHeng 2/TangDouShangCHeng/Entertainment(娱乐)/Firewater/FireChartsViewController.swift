//
//  FireChartsViewController.swift
//  TangDouShangCHeng
//
//  Created by 黎应明 on 2018/5/14.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class FireChartsViewController: UIViewController {

    var modelArr:[HisteryModel] = []
    var deateArr:[HisteryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.whenTapped {
            self.dismiss(animated: true, completion: nil)
        }
        let bg =  UIView(frame: self.view.frame)
        bg.backgroundColor = UIColor.clear
        
        self.view.addSubview(bg)
        
        let bgView = UIView(frame: CGRect(x: 30, y: 100, width: kWidth-60, height: 400))
        bgView.backgroundColor = UIColor(fromHexString: "102914")
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 10
        bgView.layer.borderColor = UIColor.green.cgColor
        bgView.layer.borderWidth = 2
    
        bg.addSubview(bgView)
        
        self.createChartView(bgView: bgView, isWin: true)
       
        let winBtn = UIButton(frame: CGRect(x: 80, y: 120, width: 50, height: 30))
        let deathBtn = UIButton(frame: CGRect(x: kWidth-120, y: 120, width: 50, height: 30))
        
        winBtn.setTitle("赢", for: .normal)
        winBtn.backgroundColor = UIColor.red
        winBtn.layer.masksToBounds = true
        winBtn.layer.cornerRadius = 15
        winBtn.layer.borderColor = UIColor.white.cgColor
        winBtn.layer.borderWidth = 1
        
        deathBtn.setTitle("卒", for: .normal)
        deathBtn.backgroundColor = UIColor.red
        deathBtn.layer.masksToBounds = true
        deathBtn.layer.cornerRadius = 15
        
        
        winBtn.whenTapped {
            bgView.removeAllSubviews()
            self.createChartView(bgView: bgView, isWin: true)
            deathBtn.layer.borderColor = UIColor.clear.cgColor
            deathBtn.layer.borderWidth = 1
            winBtn.layer.borderColor = UIColor.white.cgColor
            winBtn.layer.borderWidth = 1
            
        }
        
        
        deathBtn.whenTapped {
            bgView.removeAllSubviews()
             self.createChartView(bgView: bgView, isWin: false)
            deathBtn.layer.borderColor = UIColor.white.cgColor
            deathBtn.layer.borderWidth = 1
            winBtn.layer.borderColor = UIColor.clear.cgColor
            winBtn.layer.borderWidth = 1
        }
        
        bg.addSubview(winBtn)
        bg.addSubview(deathBtn)
        
       
    }

    func createChartView(bgView:UIView,isWin:Bool) {
        let lineChart = PNLineChart(frame: CGRect(x: 0, y: 80, width:bgView.frame.width, height: 300))
        lineChart.backgroundColor = UIColor.clear
        //     控制显示的期数。然后倒叙
        var xArray:[String] = []
        var data:[Int] = []
        var deathData2:[Int] = []
        
        for (_,item) in modelArr.enumerated(){
            xArray.append(item.turn_period)
            if item.win_choice == "1"{
                data.append(1)
                deathData2.append(1)
            }
            if item.win_choice == "2"{
                data.append(2)
                deathData2.append(3)
            }
            if item.win_choice == "3"{
                data.append(3)
                deathData2.append(4)
            }
            if item.win_choice == "4"{
                data.append(4)
                deathData2.append(5)
            }
            if item.win_choice == "5"{
                data.append(5)
                deathData2.append(6)
            }
            if item.win_choice == "6"{
                data.append(6)
                deathData2.append(2)
            }
        }
        
        lineChart.yLabelFont = UIFont.systemFont(ofSize: 10)
        lineChart.xLabelFont = UIFont.systemFont(ofSize: 10)
        lineChart.chartCavanWidth = kWidth
        lineChart.chartCavanHeight = 250
        lineChart.yLabelFormat = "1"
        
        lineChart.isFire = true
        
        lineChart.setXLabels(xArray, withWidth: (kWidth-100)/CGFloat(xArray.count))
        lineChart.isShowCoordinateAxis = true
        lineChart.axisColor = UIColor.white
        lineChart.yGridLinesColor = UIColor.white
        lineChart.xLabelColor = UIColor.white
        lineChart.yLabelColor = UIColor.white
        
        //        lineChart.showLabel = false
        lineChart.showYGridLines = true
        lineChart.yFixedValueMax = 6
        lineChart.yFixedValueMin = 1
        
        
        let yLabels:[String] = ["太极","金","木","土","水","火"]
        lineChart.yLabels = yLabels
        
        
        let pnData = PNLineChartData()
        
        if isWin {
            pnData.color = UIColor(fromHexString: "EF2F48")
            pnData.itemCount = UInt(data.count)
            pnData.inflexionPointColor =  UIColor(fromHexString: "EF2F48")
            pnData.inflexionPointStyle = .circle
            pnData.showPointLabel = true
            pnData.pointLabelFont = UIFont.systemFont(ofSize: 12)
            pnData.pointLabelColor = UIColor.white
            
            pnData.getData = {
                (index) in
                let a = Int(index)
                print("qwertyuio",a)
                let yValue:NSString = data[a].description as NSString
                return PNLineChartDataItem(y: CGFloat(yValue.floatValue))
                
            }
        }else{
            pnData.color = UIColor(fromHexString: "EF2F48")
            pnData.itemCount = UInt(data.count)
            pnData.inflexionPointColor =  UIColor(fromHexString: "EF2F48")
            pnData.inflexionPointStyle = .circle
            pnData.showPointLabel = true
            pnData.pointLabelFont = UIFont.systemFont(ofSize: 12)
            pnData.pointLabelColor = UIColor.white
            
            pnData.getData = {
                (index) in
                let a = Int(index)
                print("qwertyuio",a)
                let yValue:NSString = deathData2[a].description as NSString
                return PNLineChartDataItem(y: CGFloat(yValue.floatValue))
                
            }
        }
        
        lineChart.chartData = [pnData]
        lineChart.stroke()
        bgView.addSubview(lineChart)
        
    }
    
}
