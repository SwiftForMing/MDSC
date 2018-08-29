//
//  MySearchBar.swift
//  TaoPiao
//
//  Created by 黎应明 on 2018/1/11.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class MySearchBar: UISearchBar {

   
    override func layoutSubviews() {
        super.layoutSubviews()
       
        for view in self.subviews {
            if view.isKind(of: NSClassFromString("UIView")!)&&view.subviews.count>0{
                for subview in view.subviews{
                    print("")
                    
                    if subview.isKind(of: NSClassFromString("UITextField")!){
                        let textField = subview as! UITextField
                        var frame = textField.frame
                        frame.size.height  = 30
                        textField.frame = frame
                        textField.font = UIFont.systemFont(ofSize: 12)
//                        break
                    }else if subview.isKind(of: NSClassFromString("UIButton")!){
                        let btn = subview as! UIButton
                        var frame = btn.frame
                        frame.size.height  = 30
                        btn.frame = frame
                        btn.setTitle("取消", for: .normal)
                        btn.setTitleColor(UIColor.gray, for: .normal)
                        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
//                        break
                    }else{
                         subview.backgroundColor = UIColor.clear
                        subview.alpha = 0
                    }
                }
                break
            }
        }
        
    }

}
