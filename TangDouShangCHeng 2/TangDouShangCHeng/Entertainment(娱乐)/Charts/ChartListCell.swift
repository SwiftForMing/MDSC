//
//  ChartListCell.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/11/6.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class ChartListCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var buyNumsLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var winUserLabel: UILabel!
    @IBOutlet weak var winNumLabel: UILabel!
    @IBOutlet weak var whereNumLabel: UILabel!
    var listModel:ChartWinListModel?{
        didSet{
           
            numLabel.textColor = UIColor(fromHexString: "474747")
            numLabel.text = listModel?.good_period
            winUserLabel.textColor = UIColor(fromHexString: "474747")
            winUserLabel.text = listModel?.nick_name
            winUserLabel.textAlignment = .left
            winNumLabel.textColor = UIColor(fromHexString: "474747")
            winNumLabel.text = listModel?.win_num
            buyNumsLabel.textColor = UIColor(fromHexString: "474747")
            
            buyNumsLabel.text = listModel?.buy_time
            
            whereNumLabel.textColor = UIColor(fromHexString: "474747")
            let str = ((listModel?.buy_seating)! as NSString).integerValue
            whereNumLabel.text = "\(str+1)"
            
//            whereNumLabel.text = "\(Int((listModel?.buy_time)!)!+Int((listModel?.buy_seating)!)!)"
            whereLabel.textColor = UIColor(fromHexString: "474747")
            whereLabel.text = listModel?.interzone
            bgView.backgroundColor = UIColor.white
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
