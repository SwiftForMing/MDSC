//
//  ChartWinListModel.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/11/6.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class ChartWinListModel: NSObject {
    /*
    "buy_seating" = 74;
    "buy_time" = 44;
    "good_period" = 4;
    "goods_fight_id" = 1000007766;
    "goods_id" = 522860622728;
    id = 175;
    interzone = 2;
    "nick_name" = "\U4f1f\U5927\U7684\U83e0\U83dc";
    "win_num" = 10000019;
    "win_user_id" = 1220085;
 */
    var buy_seating:String?//y坐标
    var buy_time:String?//买的次数
    var good_period:String?
    var goods_fight_id:String?
    var goods_id:String?
    var id:String?
    var interzone:String?{
        didSet{
            if interzone == "0" {
                interzone = "头"
            }
            if interzone == "1" {
                interzone = "前"
            }
            if interzone == "2" {
                interzone = "中"
            }
            if interzone == "3" {
                interzone = "后"
            }
        }
    }
    var nick_name:String?
    var win_num:String?
    var win_user_id:String?
    var need_people:String?

}
