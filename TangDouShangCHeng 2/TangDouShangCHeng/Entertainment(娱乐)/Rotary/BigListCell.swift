//
//  BigListCell.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/11/24.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class BigListCell: UITableViewCell {

    @IBOutlet weak var beanNumLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    var listModel:BigListModel?{
        
        didSet{
            self.beanNumLabel.text = listModel?.win_money
            self.nameLabel.text = listModel?.nick_name
           
            self.timeLabel.text = Tool.timeString(toDateSting: listModel?.create_time, format: "HH:mm:ss")
            self.userImageView.sd_setImage(with: URL(string: (listModel?.user_header)!), placeholderImage: UIImage(named:"avatar_header"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImageView.layer.masksToBounds = true
        self.userImageView.layer.cornerRadius = 15
        
        self.bgView.layer.masksToBounds = true
        self.bgView.layer.cornerRadius = 20
        self.bgView.layer.borderWidth = 1
        self.bgView.layer.borderColor = UIColor.green.cgColor
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
