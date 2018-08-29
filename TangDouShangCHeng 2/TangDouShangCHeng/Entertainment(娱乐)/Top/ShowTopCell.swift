//
//  ShowTopCell.swift
//  TangDouShangCHeng
//
//  Created by 黎应明 on 2018/7/17.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class ShowTopCell: UITableViewCell {
    @IBOutlet weak var headerImage: UIImageView!
    
    @IBOutlet weak var beanLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var topLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
