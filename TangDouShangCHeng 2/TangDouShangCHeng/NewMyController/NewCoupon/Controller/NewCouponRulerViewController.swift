//
//  NewCouponRulerViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/27.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewCouponRulerViewController: BaseViewController {

    var textView:UITextView?
    var tableView:UITableView?
    var str:String?
    var titleStr:String?{
        didSet{
            if self.titleStr == "使用规则" {
               
                self.str = """
                欢乐豆使用规则：
                1. 通过充值活动、平台活动、签到系统、转让等都可获得欢乐豆。
                2. 欢乐豆与小米比例为1:1
                3. 用户账户有欢乐豆余额，投注时固定抵扣10%（欢乐豆剩余量低于投注额10%不可抵扣，如：投注额为10000米  欢乐豆剩余1200豆  支付时则可抵扣1000米）。
                4. 购物车不可使用欢乐豆抵扣！
                5. 最终解释权归米豆商城所有。
                """
            }else if self.titleStr == "如何获豆" {
                self.str = """
                1. 购物、购券
                   购买消费金额越大，附赠获取的小米越多
                
                2. 购物评价
                   商品晒单、活动晒单：通过晒单贴向其他网友分享所购商品或所参加活动的经历、心得、真实照片等，在符合以下情形时，米豆商城视晒单价值，可给予奖励获取相应的券
                
                3. 参与游戏
                   玩游戏、领小米：玩游戏获取小米，该活动面向所有米豆商城用户，每位会员都有一定概率得到小米
                
                本规则未尽事宜，依据米豆商城《用户服务协议》和国家相关法律法规及规章制度予以解释\n
                """
            }else if self.titleStr == "小米使用规则"{
                self.str = """
                一. 关于小米
                    小米是米豆商城用户在米豆商城平台购物、购券、评价、晒单等相关活动给予的、附赠的免费奖励、赠送；小米仅可在米豆商城平台使用；如用户帐号暂停使用，则米豆商城将取消该用户帐号内小米相关使用权益
                
                二. 小米用途
                    1 参加游戏，娱乐身心；
                    2 兑换商品；折抵购物；
                    3 作为有奖销售促销活动参与凭证。
                
                三. 如何获取小米
                    1、购物，购券 购买消费金额越大，附赠获取的小米越多。 小米发放时间：订单完成后； 订单完成是指：订单已显示完成且未办理退货手续；
                    2、活动参与 积极且成功参与平台组织的活动，平台将赠送相应数量 小米。
                    3、商品晒单、活动晒单 通过晒单贴向其他网友分享所购商品或所参加活动的经 历、心得、真实照片等，在符合以上情形时，米豆商城视晒 单价值，可给予奖励。
                    4、玩游戏、领小米 玩游戏抽取小米，该活动面向所有米豆商城用户，每位会员 都有一定概率得到小米。
                
                四、关于小米的使用限制
                    1、小米不具有财产性质，并且不以金钱衡量其经济价值，小米任何时候均不可用于兑换现金；
                    2、小米权益仅限用户本人享有，小米不具有可让与性，不可转赠也不得为本人以外的任何人实现小米权益；
                    3、用户通过小米实现小米权益时，系统将消耗到期日最早的小米；
                    4、用户通过专享折扣让利购物行为实现其小米权益的，若发生退货退款情况，用户于购物行为中所消耗的小米，于成功退货退款时，直接消灭，不再退还。
                    5、当米豆商城停止运营或因该用户未遵守米豆商城使用规则或有其他违反相关法规的行为出现时，因小米并不具有财产价值，用户获赠的小米及相关权益将同步消灭。
                
                """
            }else{

                self.str = """
                温馨提示：\n
                1. 通过转让功能可将您中奖商品转让到您所输入的手机号对应 的账户下，确认转让后不可撤回；\n
                2. 转让由用户私人发起纯属个人行为，转让过程中所产生任何 问题与米豆商城平台无关，概不负责；\n
                3. 确认转让，米豆商城平台将是为用户同意转让，任何问题所产生 的损失由用户自行承担。\n
                """
            }
             self.title = self.titleStr!
            
           
            self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.size.height-64))
            self.tableView?.separatorStyle = .none
            self.textView = UITextView(frame:CGRect(x: 20, y: 0, width: (self.tableView?.frame.width)!-40, height: (self.tableView?.frame.size.height)!-40-20))
            self.textView?.text = self.str!
            self.textView?.font = UIFont(name: "PingFangSC-Regular", size: 16)
            self.textView?.textColor = UIColor(fromHexString: "666666")
            self.textView?.isUserInteractionEnabled = false
            
            
            if self.titleStr == "小米使用规则"{
            let label = UILabel(frame: CGRect(x: 20, y: (textView?.height)!, width: kWidth-40, height: 40))
            label.font = UIFont.init(name: "PingFangSC-Regular", size: 8)
            label.numberOfLines = 0
            let text:NSString = "本规则未尽事宜，依据米豆商城《用户服务协议》和国家相关法律法规及规章制度予以解释。" as NSString

            let attributeText = NSMutableAttributedString.init(string: "本规则未尽事宜，依据米豆商城《用户服务协议》和国家相关法律法规及规章制度予以解释。")
            let afterRange = text.range(of: "《用户服务协议》")
            attributeText.addAttributes([NSFontAttributeName: UIFont.init(name: "PingFangSC-Regular", size: 12)!,NSForegroundColorAttributeName:UIColor(fromHexString: "E26650")], range: afterRange)
           label.attributedText = attributeText
            label.whenTapped {
//                let vc = SafariViewController(nibName: "SafariViewController", bundle: nil)
//                vc.title = "服务协议"
//                vc.urlStr = "\(URL_Server)\(Wap_AboutDuobao)id=6&is_show_message=y"
//                self.navigationController?.pushViewController(vc, animated: true)
            }
            self.tableView?.addSubview(label)
            }
            
            self.tableView?.addSubview(self.textView!)
            self.view.addSubview(self.tableView!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftItemControl = UIControl(frame: CGRect(x: 0, y: 0, width: 20, height: 44))
        leftItemControl.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        let back = UIImageView(frame: CGRect(x: 0, y: 13, width: 10, height: 18))
        back.image = UIImage(named: "new_back")
        leftItemControl.addSubview(back)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftItemControl)
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }

    

}
