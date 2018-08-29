//
//  ChartGoodCell.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/11/6.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class ChartGoodCell: UITableViewCell {

    @IBOutlet weak var needNumLabel: UILabel!
    @IBOutlet weak var goodNameLabel: UILabel!
    @IBOutlet weak var goodHeaderimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
