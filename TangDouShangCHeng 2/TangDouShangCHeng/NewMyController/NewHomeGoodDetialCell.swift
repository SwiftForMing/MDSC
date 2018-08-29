//
//  NewHomeGoodDetialCell.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/13.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewHomeGoodDetialCell: UITableViewCell {

//    @IBOutlet weak var newAfterLabel: UILabel!
//    @IBOutlet weak var newCouponLabel: UILabel!
    @IBOutlet weak var nameHight: NSLayoutConstraint!
//    @IBOutlet weak var treatWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var goodNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
//    @IBOutlet weak var beanConstraint: NSLayoutConstraint!
//    @IBOutlet weak var treatmentLabel: UILabel!
    
//    @IBOutlet weak var beanLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var goodModel:HomeGoodModel?{
        didSet{
//            goodNameLabel.text = goodModel?.good_name
            let pricrStr = "\((goodModel?.coupons_value)!)元直减券"
            let rect = pricrStr.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 16), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.init(name: "PingFangSC-Regular", size: 10)!], context: nil)
            let pricelabel = UILabel(frame: CGRect(x: 0, y: 0, width: rect.size.width+10, height: 16))
            pricelabel.text = pricrStr
            pricelabel.layer.masksToBounds = true
            pricelabel.layer.cornerRadius = 3
            
            pricelabel.textAlignment = .center
            pricelabel.font = UIFont.init(name: "PingFangSC-Regular", size: 10)
            pricelabel.backgroundColor = UIColor(fromHexString: "F0A023")
            pricelabel.textColor = UIColor.white
            goodNameLabel.addSubview(pricelabel)
            
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
            nameLabel.text = goodModel?.good_name
            
//            let beanStr = "购券立送\(Int((goodModel?.coupons_price)!)!*100)豆" as NSString
//            let beanRect = beanStr.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 25), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 12)], context: nil)
//            beanConstraint.constant = beanRect.width+10
//
//            beanLabel.setzGradient(leftColor: "ED533B", right: "EF2F48")
//            newAfterLabel.text = "购券立送\(Int((goodModel?.coupons_price)!)!*100)豆"
//            beanLabel.alpha = 0.8
//            beanLabel.layer.masksToBounds = true
//            beanLabel.layer.cornerRadius = 5
//
//            treatmentLabel.setzGradient(leftColor: "ED533B", right: "EF2F48")
//
//            newCouponLabel.text = "立减"+(goodModel?.coupons_value)!+"元"
//
//            treatmentLabel.alpha = 0.9
//            treatmentLabel.layer.masksToBounds = true
//            treatmentLabel.layer.cornerRadius = 5
            
            let text = "¥ "+(goodModel?.coupons_price)!+"   "+"商品原价："+(goodModel?.good_price)! as NSString
            let attributeText = NSMutableAttributedString.init(string: text as String)
            let after = "¥ "+(goodModel?.coupons_price)!
            let price = "商品原价："+(goodModel?.good_price)!
            let afterRange = text.range(of: after)
            let range = text.range(of: price)
            attributeText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)], range: afterRange)
            attributeText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)], range: range)
            //设置删除线

            attributeText.addAttributes([NSForegroundColorAttributeName: UIColor.gray], range:range)
            priceLabel.attributedText = attributeText
        
           
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.goodNameLabel.removeAllSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
