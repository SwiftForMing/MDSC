//
//  RecommendedCell.swift
//  NewShopTest
//
//  Created by 黎应明 on 2017/12/11.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class RecommendedCell: UITableViewCell {

    @IBOutlet weak var buyNowBtn: UIButton!
    @IBOutlet weak var beanLabel: UILabel!
    @IBOutlet weak var couponPriceLabel: UILabel!
    @IBOutlet weak var goodPriceLabel: UILabel!
    @IBOutlet weak var goodNameLabel: UILabel!
    @IBOutlet weak var couponNameLabel: UILabel!
    @IBOutlet weak var goodHeader: UIImageView!
    
    var goodModel:HomeGoodModel?{
        didSet{
            
            let url = URL(string: (goodModel?.good_header)!)
            goodHeader.sd_setImage(with: url, placeholderImage: nil)
            
            let deviceName = UIDevice.current.model
            if deviceName.hasSuffix("iPad") {
                couponNameLabel.font = UIFont.systemFont(ofSize: 8)
            }
            couponNameLabel.text = goodModel?.coupons_name
//            goodNameLabel.text = goodModel?.good_name
            
            ///*
            let pricrStr = "\((goodModel?.coupons_price)!)元直减券"
            let rect = pricrStr.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 16), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.init(name: "PingFangSC-Regular", size: 10)!], context: nil)
            let priceLabel = UILabel(frame: CGRect(x: 0, y: 0, width: rect.size.width+10, height: 16))
            priceLabel.text = pricrStr
            priceLabel.layer.masksToBounds = true
            priceLabel.layer.cornerRadius = 3
            
            priceLabel.textAlignment = .center
            priceLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 10)
            priceLabel.backgroundColor = UIColor(fromHexString: "F0A023")
            priceLabel.textColor = UIColor.white
            goodNameLabel.addSubview(priceLabel)
            
            let sendStr = "赠送\(Int((goodModel?.coupons_price)!)!*100)豆"
            let sendRect = sendStr.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 16), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.init(name: "PingFangSC-Regular", size: 10)!], context: nil)
            let sendLabel = UILabel(frame: CGRect(x: rect.size.width+20, y: 0, width: sendRect.size.width+10, height: 16))
            sendLabel.text = sendStr
            sendLabel.layer.masksToBounds = true
            sendLabel.layer.cornerRadius = 3
            
            sendLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 10)
            sendLabel.textAlignment = .center
            sendLabel.layer.borderWidth = 1
            sendLabel.layer.borderColor = UIColor(fromHexString: "F0A023").cgColor
            sendLabel.textColor = UIColor(fromHexString: "F0A023")
            goodNameLabel.addSubview(sendLabel)
            //*/
            
            let afterPricr = Int((goodModel?.good_price)!)!-Int((goodModel?.coupons_value)!)!
            let text = "¥\(afterPricr)"+"  "+(goodModel?.good_price)! as NSString
            let attributeText = NSMutableAttributedString.init(string: text as String)
            let after = "¥\(afterPricr)"
            let price = (goodModel?.good_price)!
            let afterRange = text.range(of: after)
            let range = text.range(of: price)
            attributeText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)], range: afterRange)
            attributeText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 10)], range: range)
            //设置删除线
            attributeText.addAttributes([NSStrikethroughStyleAttributeName: 1], range: range)
            //设置删除线颜色
            attributeText.addAttributes([NSStrikethroughColorAttributeName: UIColor.gray], range: range)
            attributeText.addAttributes([NSForegroundColorAttributeName: UIColor.gray], range:range)
             goodPriceLabel.attributedText = attributeText
            
            couponPriceLabel.text = "¥"+(goodModel?.coupons_price)!
            beanLabel.text = "领券即送\(Int((goodModel?.coupons_price)!)!*100)豆"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.buyNowBtn.layer.masksToBounds = true
        self.buyNowBtn.layer.cornerRadius = 5
        
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.goodNameLabel.removeAllSubviews()
    }
    
    
}
