//
//  MoveView.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/11/27.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class MoveView: UIView {
    @IBOutlet weak var beanNumsLabbel: UILabel!
    @IBOutlet weak var bgView: UIImageView!
    var bgAlpha = 0.2
    var timer:Timer?
   
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.5
        animation.autoreverses = true
        animation.repeatCount = MAXFLOAT
        animation.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
        animation.beginTime = CACurrentMediaTime()
        self.bgView.layer.add(animation, forKey: "animation dsf")
        
        self.whenTapped {
            self.hide()
        }
    }
    
   

}
