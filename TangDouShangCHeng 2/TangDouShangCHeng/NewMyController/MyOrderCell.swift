//
//  MyOrderCell.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/21.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class MyOrderCell: UITableViewCell {

    @IBOutlet weak var kfNumLabel: UILabel!
    @IBOutlet weak var commentNumLabel: UILabel!
    @IBOutlet weak var sendNumLabel: UILabel!
    @IBOutlet weak var waitSendNumLabel: UILabel!
    @IBOutlet weak var waitNumLabel: UILabel!
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var waitSendView: UIView!
    @IBOutlet weak var waitPayView: UIView!
    @IBOutlet weak var kfView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }

    func getNumWith(orderCountModel model:OrderCountModel) {
        if model.afterSale == "0" {
            kfNumLabel.isHidden = true
        }else{
             kfNumLabel.isHidden = false
            kfNumLabel.text = model.afterSale
        }
        
        if model.backOrder == "0" {
             waitSendNumLabel.isHidden = true
        }else{
            waitSendNumLabel.isHidden = false
            waitSendNumLabel.text = model.backOrder
        }
        
        if model.delivered == "0" {
           sendNumLabel.isHidden = true
        }else{
           sendNumLabel.isHidden = false
           sendNumLabel.text = model.delivered
        }
        
        if model.evaluate == "0" {
           commentNumLabel.isHidden = true
        }else{
           commentNumLabel.isHidden = false
           commentNumLabel.text = model.evaluate
        }
        
        if model.obligations == "0" {
            waitNumLabel.isHidden = true
        }else{
           waitNumLabel.isHidden = false
           waitNumLabel.text = model.obligations
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        kfNumLabel.layer.masksToBounds = true
        kfNumLabel.layer.cornerRadius = 7.5
        
        waitSendNumLabel.layer.masksToBounds = true
        waitSendNumLabel.layer.cornerRadius = 7.5
        
        sendNumLabel.layer.masksToBounds = true
        sendNumLabel.layer.cornerRadius = 7.5
        
        commentNumLabel.layer.masksToBounds = true
        commentNumLabel.layer.cornerRadius = 7.5
        
        waitNumLabel.layer.masksToBounds = true
        waitNumLabel.layer.cornerRadius = 7.5
        
       
        // Configure the view for the selected state
    }
    
}
