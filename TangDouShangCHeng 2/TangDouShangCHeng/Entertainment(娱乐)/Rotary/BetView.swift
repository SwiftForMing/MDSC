//
//  BetView.swift
//  Rotarytable
//
//  Created by 黎应明 on 2017/11/14.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class BetView: UIView {

    @IBOutlet weak var fourBtn: UIButton!
    @IBOutlet weak var threeBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var oneBtn: UIButton!
   
    
    var sendMutlipyBlock:((Int)->Void)?
    
    var whereBtn:Int?{
        didSet{
          self.witchBorder(num: whereBtn!)
        }
    }
    
    var witchBtnSelected:Int?{
        didSet{
           self.witchBorder(num: witchBtnSelected!)
        }
    }
    
    func getBorder() {
        self.fourBtn.layer.borderColor = UIColor(fromHexString: "74bc34").cgColor
        self.fourBtn.setTitleColor(UIColor.white, for: .normal)
        self.fourBtn.layer.borderWidth = 1
        
        self.oneBtn.layer.borderColor = UIColor(fromHexString: "74bc34").cgColor
         self.oneBtn.setTitleColor(UIColor.white, for: .normal)
        self.oneBtn.layer.borderWidth = 1
        
        self.twoBtn.layer.borderColor = UIColor(fromHexString: "74bc34").cgColor
         self.twoBtn.setTitleColor(UIColor.white, for: .normal)
        self.twoBtn.layer.borderWidth = 1
        
        self.threeBtn.layer.borderColor = UIColor(fromHexString: "74bc34").cgColor
         self.threeBtn.setTitleColor(UIColor.white, for: .normal)
        self.threeBtn.layer.borderWidth = 1
    }
    
    func witchBorder(num:Int) {
        if num == 1 {
            self.oneBtn.layer.borderColor = UIColor(fromHexString: "f6ff8b").cgColor
            self.oneBtn.setTitleColor(UIColor(fromHexString: "f6ff8b"), for: .normal)
            self.oneBtn.layer.borderWidth = 2
        }
        if num == 10 {
            self.twoBtn.layer.borderColor = UIColor(fromHexString: "f6ff8b").cgColor
            self.twoBtn.setTitleColor(UIColor(fromHexString: "f6ff8b"), for: .normal)
            self.twoBtn.layer.borderWidth = 2
        }
        if num == 100{
            self.threeBtn.layer.borderColor = UIColor(fromHexString: "f6ff8b").cgColor
            self.threeBtn.setTitleColor(UIColor(fromHexString: "f6ff8b"), for: .normal)
            self.threeBtn.layer.borderWidth = 2
        }
        if num == 1000 {
            self.fourBtn.layer.borderColor = UIColor(fromHexString: "f6ff8b").cgColor
            self.fourBtn.setTitleColor(UIColor(fromHexString: "f6ff8b"), for: .normal)
            self.fourBtn.layer.borderWidth = 2
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.fourBtn.layer.masksToBounds = true
        self.fourBtn.layer.cornerRadius = self.fourBtn.frame.height/2
        
        self.oneBtn.layer.masksToBounds = true
        self.oneBtn.layer.cornerRadius = self.oneBtn.frame.height/2
        
        self.twoBtn.layer.masksToBounds = true
        self.twoBtn.layer.cornerRadius = self.twoBtn.frame.height/2
        
        self.threeBtn.layer.masksToBounds = true
        self.threeBtn.layer.cornerRadius = self.threeBtn.frame.height/2
    }
    
    @IBAction func twoBtnClick(_ sender: Any) {
        witchBtnSelected = 10
        self.getBorder()
        self.witchBorder(num: witchBtnSelected!)
        self.sendMutlipyBlock!(witchBtnSelected!)
        
    }
    
    @IBAction func oneBtnClick(_ sender: Any) {
        witchBtnSelected = 1
         self.getBorder()
        self.witchBorder(num: witchBtnSelected!)
        self.sendMutlipyBlock!(witchBtnSelected!)
        
        
    }
    
    @IBAction func threeBtnClick(_ sender: Any) {
        witchBtnSelected = 100
         self.getBorder()
        self.witchBorder(num: witchBtnSelected!)
        self.sendMutlipyBlock!(witchBtnSelected!)
        
        
    }
    
        
    @IBAction func fourBtn(_ sender: Any) {
        witchBtnSelected = 1000
         self.getBorder()
        self.witchBorder(num: witchBtnSelected!)
        self.sendMutlipyBlock!(witchBtnSelected!)
    
    }
}
