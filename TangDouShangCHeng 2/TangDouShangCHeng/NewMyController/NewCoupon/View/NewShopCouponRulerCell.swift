//
//  NewShopCouponRulerCell.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/27.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewShopCouponRulerCell: UITableViewCell {

    @IBOutlet weak var rulerTX: UITextView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        let str = """
                    1. 兑换码转让需在5分钟内于个人中心优惠券处兑换；
                    2. 转让后此优惠券将不属于您，平台不会以任何形式泄露您的兑换码，若兑换码发生泄漏所产生的任何问题，米豆商城平台概不负责。
                  """ as NSString
        let attributeText = NSMutableAttributedString.init(string: str as String)
        let afterRange = str.range(of: str as String)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributeText.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: afterRange)
        attributeText.addAttributes([NSForegroundColorAttributeName: UIColor.gray], range:afterRange)
        rulerTX.attributedText = attributeText

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
