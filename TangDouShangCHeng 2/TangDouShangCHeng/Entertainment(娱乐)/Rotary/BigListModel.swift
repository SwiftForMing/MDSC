//
//  BigListModel.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/11/23.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class BigListModel: NSObject {
//    "nick_name" = "\U865e\U7f8e\U4eba\U4e0d\U5403\U9c7c";
//    "user_header" = "";
//    "user_id" = 1232159;
//    "win_money" = 55500;
    var create_time = ""
    var user_id = ""
    var win_money = "0"{
        didSet{
            let num = Int(win_money)!
            if num>10000 {
                win_money = "\(Double(num)/10000.0) 万"
            }
        }
    }
    var nick_name = ""
    var user_header = ""
}
