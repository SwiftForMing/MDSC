//
//  NewShopOrderStautView.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/29.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class NewShopOrderStautView: UIView {

    var falge=0
    var falgeCenterx:CGFloat = 0
    
    @IBOutlet weak var flageLabel: UILabel!
    @IBOutlet weak var allBtn: UIButton!
    @IBOutlet weak var waitPayBtn: UIButton!
    @IBOutlet weak var waitSendBtn: UIButton!
    @IBOutlet weak var hadSendBtn: UIButton!
    @IBOutlet weak var waitCommentBtn: UIButton!
    
    var contentView:UIView?
    override func awakeFromNib() {
//        super.awakeFromNib()
//        allBtn.addTarget(self, action: #selector(setFlageLabel), for: .touchUpInside)
        
        allBtn.whenTapped {
           
            self.falge = 0
            self.falgeCenterx = self.allBtn.center.x
            self.setFlageLabel()
        }
        
        waitPayBtn.whenTapped {
            
            self.falge = 1
            self.falgeCenterx = self.waitPayBtn.center.x
            self.setFlageLabel()
        }
        
        waitSendBtn.whenTapped {
            
            self.falge = 2
            self.falgeCenterx = self.waitSendBtn.center.x
            self.setFlageLabel()
        }
        
        hadSendBtn.whenTapped {
            
            self.falge = 3
            self.falgeCenterx = self.hadSendBtn.center.x
            self.setFlageLabel()
            
        }
        
        waitCommentBtn.whenTapped {
            
            self.falge = 4
            self.falgeCenterx = self.waitCommentBtn.center.x
            self.setFlageLabel()
        }
       
 
    }
    
    
    
    
    func setFlageLabel() {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.flageLabel.center.x = self.falgeCenterx
        })
    }
   

}
