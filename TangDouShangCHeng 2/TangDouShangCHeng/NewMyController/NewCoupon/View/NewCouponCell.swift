//
//  NewCouponCell.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/21.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewCouponCell: UITableViewCell {
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var falgeImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var rightBtn: UIButton!
    
    var couponModel:CouponModel?{
        didSet{
            
            let text = "¥"+(couponModel?.coupons_price)! + "   "+"直减券" as NSString
            let attributeText = NSMutableAttributedString.init(string: text as String)
            let after = "¥"+(couponModel?.coupons_price)!
            let price = "直减券"
            let priceRang = text.range(of: after)
            let range = text.range(of: price)
            attributeText.addAttributes([NSKernAttributeName:3], range: priceRang)
            attributeText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)], range: range)
            attributeText.addAttributes([NSForegroundColorAttributeName: UIColor.black], range:range)
            priceLabel.attributedText = attributeText
            
//            priceLabel.text = "¥ "+(couponModel?.coupons_price)!
            nameLabel.text = couponModel?.coupons_name
            timeLabel.text = "有效期至："+(couponModel?.valid_date)!
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
