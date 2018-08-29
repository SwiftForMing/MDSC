//
//  MyNewIconCell.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/21.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class MyNewIconCell: UITableViewCell {
    @IBOutlet weak var couponView: UIView!
    
    @IBOutlet weak var newGetLabel: UILabel!
    @IBOutlet weak var couponNunLabel: UILabel!
    @IBOutlet weak var beanView: UIView!
    @IBOutlet weak var beanNumLabel: UILabel!
    @IBOutlet weak var collectView: UIView!
    @IBOutlet weak var collectNumLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
