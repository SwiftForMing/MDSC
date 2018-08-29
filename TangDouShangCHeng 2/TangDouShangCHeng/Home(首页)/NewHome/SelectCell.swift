//
//  SelectCell.swift
//  NewShopTest
//
//  Created by 黎应明 on 2017/12/11.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class SelectCell: UITableViewCell {

    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightDesTitle: UILabel!
    @IBOutlet weak var rightTitle: UILabel!
    @IBOutlet weak var leftTitle: UILabel!
    
    @IBOutlet weak var leftDesTitle: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
