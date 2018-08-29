//
//  NewShopOrderFooterView.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/29.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewShopOrderFooterView: UIView {

    @IBOutlet weak var priceNumLabel: UILabel!
    @IBOutlet weak var cancelOrderBtn: UIButton!
    @IBOutlet weak var cancelPayBtn: UIButton!
   
    @IBOutlet weak var cancelWidth: NSLayoutConstraint!
    @IBOutlet weak var btnWidth: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        cancelPayBtn.layer.masksToBounds = true
        cancelPayBtn.layer.cornerRadius = 4
        cancelPayBtn.layer.borderWidth = 1
        cancelPayBtn.layer.borderColor = UIColor(fromHexString: "E26650").cgColor
        btnWidth.constant = 80*(kWidth/375)
        cancelWidth.constant = 80*(kWidth/375)
        cancelOrderBtn.layer.masksToBounds = true
        cancelOrderBtn.layer.cornerRadius = 4
        cancelOrderBtn.layer.borderWidth = 1
        cancelOrderBtn.layer.borderColor = UIColor(fromHexString: "999999").cgColor
    }

}
