//
//  CommentStars.swift
//  CommentStarDemo
//
//  Created by 黎应明 on 2018/3/13.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit
protocol CommentStarsDelegate {
    // 代理方法 动态获取评分
//    - (void)starEvaluator:(StarEvaluator *)evaluator currentValue:(float)value;
    func starEvaluator(evaluator:CommentStars,currentValue value:CGFloat)
}
@objc(CommentStars)
class CommentStars: UIControl {

    let starSpace:CGFloat = 10
    /**
     *一个星星+间隙的宽度
     */
    var aWidth:CGFloat = 0
    /**
     *一个星星的宽度
     */
    var delegate:CommentStarsDelegate?
    
    var aStarWidth:CGFloat = 0
    /**
     *手势所在的点的距离
     */
    var touchX:CGFloat = 0

    
    var currentValue:CGFloat = 0{
        didSet{
            self.touchX = currentValue/5.0*self.frame.size.width
            self.setNeedsDisplay()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.currentValue = 0
        self.backgroundColor = UIColor.clear
        self.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   // 手势点击时评分动态变化
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        let t = (touchPoint.x)/self.aWidth
        var f = ((touchPoint.x)-t*starSpace-t*aStarWidth)/self.aStarWidth
        f = f>1.0 ? 1.0:f
        self.currentValue = t+f
        self.touchX = (touchPoint.x)
        self.setNeedsDisplay()
        return true
    }
    
      // 手势移动是评分动态变化
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        var touchPoint = touch.location(in: self)
        //防止越界
        touchPoint.x = touchPoint.x >= self.frame.size.width ? self.frame.size.width:touchPoint.x
        touchPoint.x = touchPoint.x <= 0 ? 0:touchPoint.x
        //根据拖动的位置计算出分数
        let t = touchPoint.x/self.aWidth
        var f = ((touchPoint.x)-t*starSpace-t*aStarWidth)/self.aStarWidth
        f = f>1.0 ? 1.0:f
        self.currentValue = t+f
        self.touchX = (touchPoint.x)
        self.setNeedsDisplay()
        return true
    }
     // 绘制出评分星星
    override func draw(_ rect: CGRect) {
        let width = (self.bounds.size.width - starSpace*4)/5
        self.aStarWidth = width
        self.aWidth = width + starSpace
        
        let image = UIImage(named: "evaStar.png")
        for  i in 0...4 {
            let rect = CGRect(x: CGFloat(i)*(width+starSpace), y: 0, width: width, height: width)
            image?.draw(in: rect)
        }
        
        //未评分区间颜色
        UIColor.lightGray.setFill()
        UIRectFillUsingBlendMode(rect, .sourceIn)
        
        //评分区间颜色
        
        let newRect = CGRect(x: 0, y: 0, width: self.touchX, height:rect.size.height)
        UIColor(fromHexString: "E26650").setFill()
        UIRectFillUsingBlendMode(newRect, .sourceIn)
        
        if ((self.delegate?.starEvaluator(evaluator: self, currentValue: self.currentValue)) != nil) {
            self.delegate?.starEvaluator(evaluator: self, currentValue: currentValue)
        }
        
    }
    
}
