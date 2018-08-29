//
//  NewShopHomeListCell.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/26.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewShopHomeListCell: UITableViewCell {
    @IBOutlet weak var leftNameHight: NSLayoutConstraint!
    @IBOutlet weak var nameHight: NSLayoutConstraint!
    
//    @IBOutlet weak var rightbeanWidth: NSLayoutConstraint!
//    @IBOutlet weak var leftbeanWidth: NSLayoutConstraint!
    @IBOutlet weak var leftColorLabel: UILabel!

    @IBOutlet weak var leftColorWidth: NSLayoutConstraint!

    @IBOutlet weak var rightColorLabel: UILabel!

    @IBOutlet weak var rightWidth: NSLayoutConstraint!
    
//    @IBOutlet weak var leftBeanPriceLabel: UILabel!
//    @IBOutlet weak var leftPriceWidth: NSLayoutConstraint!
//
//    @IBOutlet weak var rightPriceWidth: NSLayoutConstraint!
//    @IBOutlet weak var rightBeanPriceLabel: UILabel!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var leftGoodNameLabel: UILabel!
    @IBOutlet weak var leftCouponLabel: UILabel!
    @IBOutlet weak var leftPriceLabel: UILabel!
    
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var rightGoodNameLabel: UILabel!
    @IBOutlet weak var rightCouponLabel: UILabel!
    @IBOutlet weak var rightPriceLabel: UILabel!
    
    var leftFightModel:GoodsFightModel?{
        didSet{
//            let leftStr:NSString = ""
//            if leftFightModel?.extra_money == "0" {
//                leftStr = ""
//            }else{
//                leftStr = "¥ \((leftFightModel?.extra_money)!) + " as NSString
//            }
//            let rect = leftStr.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 21), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.init(name: "PingFangSC-Regular", size: 13)!], context: nil)
//            leftBeanPriceLabel.text = leftStr as String
//            leftPriceWidth.constant = rect.width == 0 ? 0:(rect.width + 5)
//            leftbeanWidth.constant = 15
            leftNameHight.constant = 40
            leftImageView.sd_setImage(with: URL(string: (leftFightModel?.good_header)!), placeholderImage: nil)
            let str = (leftFightModel?.good_name)! as NSString
            let nameAttributeText = NSMutableAttributedString.init(string: str as String)
            let nameRange = str.range(of: str as String)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            nameAttributeText.addAttributes([NSParagraphStyleAttributeName: paragraphStyle,NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)], range: nameRange)
            leftGoodNameLabel.attributedText = nameAttributeText
            
            leftCouponLabel.text = ""

            let text = "赠送"+(leftFightModel?.good_single_price)! as NSString
           
            let beanRect = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 21), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.init(name: "PingFangSC-Regular", size: 11)!], context: nil)
            leftColorLabel.setzGradient(leftColor: "F7B92E", right: "F78B2D")
            leftColorLabel.layer.masksToBounds = true
            leftColorLabel.layer.cornerRadius = leftColorLabel.size.height/2
            leftColorWidth.constant = beanRect.width+25

            let attributeText = NSMutableAttributedString.init(string: text as String)
            let afterRange = text.range(of: text as String)
            attributeText.addAttributes([NSFontAttributeName: UIFont.init(name: "PingFangSC-Regular", size: 14)!,NSForegroundColorAttributeName:UIColor(fromHexString: "000000")], range: afterRange)
            leftPriceLabel.attributedText = attributeText
            
        }
    }
    
    var rightFightModel:GoodsFightModel?{
        didSet{
            var leftStr:NSString = ""
//            if rightFightModel?.extra_money == "0" {
//                leftStr = ""
//            }else{
//                leftStr = "¥\((rightFightModel?.extra_money)!)+" as NSString
//            }
            let rect = leftStr.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 21), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.init(name: "PingFangSC-Regular", size: 14)!], context: nil)
//            rightBeanPriceLabel.text = leftStr as String
//
//            rightPriceWidth.constant = rect.width == 0 ? 0:(rect.width + 5)
//            
//            nameHight.constant = 40
//            rightbeanWidth.constant = 15
            rightImageView.sd_setImage(with: URL(string: (rightFightModel?.good_header)!), placeholderImage: nil)
            let str = (rightFightModel?.good_name)! as NSString
            let nameAttributeText = NSMutableAttributedString.init(string: str as String)
            let nameRange = str.range(of: str as String)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            nameAttributeText.addAttributes([NSParagraphStyleAttributeName: paragraphStyle,NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)], range: nameRange)
            rightGoodNameLabel.attributedText = nameAttributeText
            rightCouponLabel.text = ""
            
            let text = ""+(rightFightModel?.good_single_price)! as NSString
            let beanRect = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 21), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.init(name: "PingFangSC-Regular", size: 14)!], context: nil)
            rightColorLabel.setzGradient(leftColor: "F7B92E", right: "F78B2D")
            rightColorLabel.layer.masksToBounds = true
            rightColorLabel.layer.cornerRadius = rightColorLabel.size.height/2
            rightWidth.constant = beanRect.width+25
            
            let attributeText = NSMutableAttributedString.init(string: text as String)
            let afterRange = text.range(of: text as String)
            attributeText.addAttributes([NSFontAttributeName: UIFont.init(name: "PingFangSC-Regular", size: 14)!,NSForegroundColorAttributeName:UIColor(fromHexString: "000000")], range: afterRange)
            rightPriceLabel.attributedText = attributeText
            
        }
    }
    
    var leftModel:HomeGoodModel?{
        didSet{
//            leftPriceWidth.constant = 0
//            leftbeanWidth.constant = 0
//            leftNameHight.constant = 60
            leftImageView.sd_setImage(with: URL(string: (leftModel?.good_header)!), placeholderImage: nil)
            let str = (leftModel?.good_name)! as NSString
            let nameAttributeText = NSMutableAttributedString.init(string: str as String)
            let nameRange = str.range(of: str as String)
            let paragraphStyle = NSMutableParagraphStyle()
//             paragraphStyle.lineSpacing = 3
             nameAttributeText.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: nameRange)
            let deviceName = UIDevice.current.model
            if deviceName.hasSuffix("iPad") {
                leftGoodNameLabel.font = UIFont.systemFont(ofSize: 8)
                print("deviceName",deviceName)
            }
            leftGoodNameLabel.attributedText = nameAttributeText
            
          
            let leftstr = "赠送\((leftModel?.coupons_price)!)00小米"
            let rect = leftstr.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 16), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.init(name: "PingFangSC-Regular", size: 11)!], context: nil)
            let strLabel = UILabel(frame: CGRect(x: 0, y: 0, width: rect.size.width+10, height: 16))
            strLabel.textColor = UIColor(fromHexString: "fd9b43")
            strLabel.text = leftstr
            strLabel.textAlignment = .center
            strLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 11)
//            strLabel.backgroundColor = UIColor(fromHexString: "F0A023")
//            strLabel.layer.masksToBounds = true
//            strLabel.layer.cornerRadius = 3
            leftCouponLabel.addSubview(strLabel)
 
//            leftCouponLabel.text = leftModel?.coupons_name
            
            
            let text = "券后价¥"+(leftModel?.after_coupons_price)!+"  ¥"+(leftModel?.good_price)! as NSString
            let attributeText = NSMutableAttributedString.init(string: text as String)
            let qhj = "券后价"
            let after = "¥"+(leftModel?.after_coupons_price)!
            let price = "¥"+(leftModel?.good_price)!
            
            let qhjRange = text.range(of: qhj)
            let afterRange = text.range(of: after)
            let range = text.range(of: price)
            
            attributeText.addAttributes([NSForegroundColorAttributeName: UIColor.gray], range:qhjRange)
            
            attributeText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 8)], range: qhjRange)
            attributeText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)], range: afterRange)
            attributeText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 8)], range: range)
            //设置删除线
            attributeText.addAttributes([NSStrikethroughStyleAttributeName: 1], range: range)
            //设置删除线颜色
            attributeText.addAttributes([NSStrikethroughColorAttributeName: UIColor.gray], range: range)
            attributeText.addAttributes([NSForegroundColorAttributeName: UIColor.gray], range:range)
           leftPriceLabel.attributedText = attributeText
        }
    }

    
    var rightModel:HomeGoodModel?{
        didSet{
//            rightPriceWidth.constant = 0
//            rightbeanWidth.constant = 0
//            nameHight.constant = 60
            rightImageView.sd_setImage(with: URL(string: (rightModel?.good_header)!), placeholderImage: nil)
            let str = (rightModel?.good_name)! as NSString
            let nameAttributeText = NSMutableAttributedString.init(string: str as String)
            let nameRange = str.range(of: str as String)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            nameAttributeText.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: nameRange)
            let deviceName = UIDevice.current.model
            if deviceName.hasSuffix("iPad") {
                rightGoodNameLabel.font = UIFont.systemFont(ofSize: 8)
                print("deviceName",deviceName)
            }
            rightGoodNameLabel.attributedText = nameAttributeText
//            rightCouponLabel.text = rightModel?.coupons_name
            
            let rightstr = "赠送\((rightModel?.coupons_price)!)00小米"
            let rect = rightstr.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 16), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.init(name: "PingFangSC-Regular", size: 11)!], context: nil)
            let strLabel = UILabel(frame: CGRect(x: 0, y: 0, width: rect.size.width+10, height: 16))
            strLabel.textColor = UIColor(fromHexString: "fd9b43")
            strLabel.text = rightstr
            strLabel.textAlignment = .center
            strLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 11)
//            strLabel.backgroundColor = UIColor(fromHexString: "F0A023")
//            strLabel.layer.masksToBounds = true
//            strLabel.layer.cornerRadius = 3
            rightCouponLabel.addSubview(strLabel)
            
            
            let text = "券后价¥"+(rightModel?.after_coupons_price)!+"  ¥"+(rightModel?.good_price)! as NSString
            let attributeText = NSMutableAttributedString.init(string: text as String)
            
            let qhj = "券后价"
            let after = "¥"+(rightModel?.after_coupons_price)!
            let price = "¥"+(rightModel?.good_price)!
            
            let qhjRange = text.range(of: qhj)
            let afterRange = text.range(of: after)
            let range = text.range(of: price)
            
            attributeText.addAttributes([NSForegroundColorAttributeName: UIColor.gray], range:qhjRange)
            attributeText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 8)], range: qhjRange)
            attributeText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)], range: afterRange)
            attributeText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 8)], range: range)
            //设置删除线
            attributeText.addAttributes([NSStrikethroughStyleAttributeName: 1], range: range)
            //设置删除线颜色
            attributeText.addAttributes([NSStrikethroughColorAttributeName: UIColor.gray], range: range)
            attributeText.addAttributes([NSForegroundColorAttributeName: UIColor.gray], range:range)
            rightPriceLabel.attributedText = attributeText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.leftCouponLabel.removeAllSubviews()
        self.rightCouponLabel.removeAllSubviews()
    }
  
    
}
