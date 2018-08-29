//
//  SearchView.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/21.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class SearchView: UIView {

    @IBOutlet weak var inputTF: UITextField!
    
    @IBOutlet weak var getCouponBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.getCouponBtn.layer.masksToBounds = true
        self.getCouponBtn.layer.cornerRadius = 5
        self.inputTF.layer.masksToBounds = true
        self.inputTF.layer.cornerRadius = 5
        self.inputTF.layer.borderColor =  UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 0.7).cgColor
        self.inputTF.layer.borderWidth = 1
        self.getCouponBtn.layer.borderColor =  UIColor(fromHexString: "E26650").cgColor
        self.getCouponBtn.layer.borderWidth = 1
        
    }
    
}
