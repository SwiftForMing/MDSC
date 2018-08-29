//
//  NewShopCollectionCell.swift
//  NewShopTest
//
//  Created by 黎应明 on 2017/12/11.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewShopCollectionCell: UICollectionViewCell {

    @IBOutlet weak var goodBgImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var goodNameLabel: UILabel!
    @IBOutlet weak var goodHeaderImgView: UIImageView!
    @IBOutlet weak var disCountLabel: UILabel!
    var goodModel:HomeGoodModel?{
        didSet{
            goodHeaderImgView.sd_setImage(with: URL(string: (goodModel?.good_header)!), placeholderImage: UIImage(named:"good"))
            let deviceName = UIDevice.current.model
            if deviceName.hasSuffix("iPad") {
                goodNameLabel.font = UIFont.systemFont(ofSize: 8)
                print("deviceName",deviceName)
            }
            goodNameLabel.text = goodModel?.good_name
            
            disCountLabel.text = (goodModel?.coupons_value)! + "直减券"
            let afetrStr = Int((goodModel?.good_price)!)! - Int((goodModel?.coupons_value)!)!
            let text = "¥\(afetrStr)"+"  "+(goodModel?.good_price)! as NSString
            let attributeText = NSMutableAttributedString.init(string: text as String)
            let after = "¥\(afetrStr)"
            let price = (goodModel?.good_price)!
            let afterRange = text.range(of: after)
            let range = text.range(of: price)
            attributeText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)], range: afterRange)
            attributeText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 8)], range: range)
            //设置删除线
            attributeText.addAttributes([NSStrikethroughStyleAttributeName: 1], range: range)
            //设置删除线颜色
            attributeText.addAttributes([NSStrikethroughColorAttributeName: UIColor.gray], range: range)
            attributeText.addAttributes([NSForegroundColorAttributeName: UIColor.gray], range:range)
            priceLabel.attributedText = attributeText
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        goodBgImageView.layer.masksToBounds = true
        goodBgImageView.layer.cornerRadius = 5
    }

}
