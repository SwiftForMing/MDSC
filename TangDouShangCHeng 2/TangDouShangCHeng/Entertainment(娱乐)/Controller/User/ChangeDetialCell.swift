//
//  ChangeDetialCell.swift
//  TangDouShangCHeng
//
//  Created by 黎应明 on 2018/8/7.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class ChangeDetialCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordedLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
