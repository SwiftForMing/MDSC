//
//  NewMyHeaderView.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/21.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewMyHeaderView: UIView {
    
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var beanBgWidth: NSLayoutConstraint!
    
    var userInfo:UserInfo?{
        didSet{
            if (userInfo?.nick_name != nil) {

                userNameLabel.text = userInfo?.nick_name
            }else{
                userNameLabel.text = "匿名"
            }
            
            if (userInfo?.user_header != nil) {
                let headerUrl = URL(string: (userInfo?.user_header)!)
                if headerUrl != nil{
                    userHeader.sd_setImage(with: headerUrl!, placeholderImage: UIImage(named:"avatar_header"))
                }else{
                     userHeader.image = UIImage(named:"avatar_header")
                }
            }else{
                userHeader.image = UIImage(named:"avatar_header")
            }
            
            if userInfo?.user_money != nil {
                let str = "\(Int((userInfo?.user_money)!))" as NSString
                let rect = str.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 21), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.init(name: "PingFangSC-Medium", size: 14)!], context: nil)
                beanBgWidth.constant = rect.width+30
                beanNumLabel.text = str as String
            }else{
                beanBgWidth.constant = 30
                beanNumLabel.text = "0"
            }
            
            
        }
    }
    
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var buyCouponBtn: UIButton!
    @IBOutlet weak var userHeader: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var beanNumLabel: UILabel!
    @IBOutlet weak var beanBgView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        userHeader.layer.masksToBounds = true
        userHeader.layer.cornerRadius = 30
        beanBgView.layer.masksToBounds = true
        beanBgView.layer.cornerRadius = 3
    }
   

}
