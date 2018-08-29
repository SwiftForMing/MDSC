//
//  CouponCodeCell.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/27.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class CouponCodeCell: UITableViewCell {

    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var shareCodeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        copyBtn.layer.masksToBounds = true
        copyBtn.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
