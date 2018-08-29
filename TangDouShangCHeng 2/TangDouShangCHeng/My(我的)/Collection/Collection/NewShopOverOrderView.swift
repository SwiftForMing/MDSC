//
//  NewShopOverOrderView.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/29.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewShopOverOrderView: UIView {

    @IBOutlet weak var cancelOrderBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var lookLogisticBtn: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelOrderBtn.layer.masksToBounds = true
        cancelOrderBtn.layer.cornerRadius = 4
        cancelOrderBtn.layer.borderWidth = 1
        cancelOrderBtn.layer.borderColor = UIColor(fromHexString: "999999").cgColor
        
        commentBtn.layer.masksToBounds = true
        commentBtn.layer.cornerRadius = 4
        commentBtn.layer.borderWidth = 1
        commentBtn.layer.borderColor = UIColor(fromHexString: "999999").cgColor
        
        lookLogisticBtn.layer.masksToBounds = true
        lookLogisticBtn.layer.cornerRadius = 4
        lookLogisticBtn.layer.borderWidth = 1
        lookLogisticBtn.layer.borderColor = UIColor(fromHexString: "999999").cgColor
    }

}
