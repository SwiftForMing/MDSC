//
//  NewCouponHeader.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/21.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit
protocol NewCouponHeaderDelegate {
    func selectLabelWith(tag:Int)
}
class NewCouponHeader: UIView {

    @IBOutlet weak var notUseLabel: UILabel!
    @IBOutlet weak var notUseBottomLabel: UILabel!
    
    @IBOutlet weak var useedLabel: UILabel!
    @IBOutlet weak var useedBottomLabel: UILabel!
    
    @IBOutlet weak var outOfDataLabel: UILabel!
    @IBOutlet weak var outOfDataBottomLabel: UILabel!
    
    
    @IBOutlet weak var transformLabel: UILabel!
    @IBOutlet weak var transformBottomLabel: UILabel!
    var delegate:NewCouponHeaderDelegate?
    var num = 0
    @IBAction func NotUseClick(_ sender: Any) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = true
        self.notUseLabel.isUserInteractionEnabled = true
        self.useedLabel.isUserInteractionEnabled = true
        self.outOfDataLabel.isUserInteractionEnabled = true
        self.transformLabel.isUserInteractionEnabled = true
        self.notUseLabel.whenTapped {
            self.num = 0
            self.selectLabel(tag: self.num)
            self.delegate?.selectLabelWith(tag: self.num)
        }
        
        self.useedLabel.whenTapped {
            self.num = 1
            self.selectLabel(tag: self.num)
            self.delegate?.selectLabelWith(tag: self.num)
        }
        
        self.outOfDataLabel.whenTapped {
            self.num = 2
            self.selectLabel(tag: self.num)
            self.delegate?.selectLabelWith(tag: self.num)
        }
        
        self.transformLabel.whenTapped {
            self.num = 3
            self.selectLabel(tag: self.num)
            self.delegate?.selectLabelWith(tag: self.num)
            
        }
    }
   
    
    func clearLabel() {
        notUseBottomLabel.isHidden = true
        useedBottomLabel.isHidden = true
        outOfDataBottomLabel.isHidden = true
        transformBottomLabel.isHidden = true
    }
    
    func selectLabel(tag:Int) {
        self.clearLabel()
        if tag == 0 {
            notUseBottomLabel.isHidden = false
        }
        if tag == 1 {
            useedBottomLabel.isHidden = false
        }
        if tag == 2 {
            outOfDataBottomLabel.isHidden = false
        }
        if tag == 3 {
            transformBottomLabel.isHidden = false
        }
        
       
    }
    
    
    
    
}
