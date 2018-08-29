//
//  BetSelectedViewController.swift
//  Rotarytable
//
//  Created by 黎应明 on 2017/11/14.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

protocol GetBetSelectedDelegate {
    
    func getBetNum(num:Int)
    
}
class BetSelectedViewController: UIViewController {
    var mutlipy:Int?
    var betView:BetView?
    var delegate:GetBetSelectedDelegate?
    override func viewDidLoad() {
        
        super.viewDidLoad()
      
        self.view.whenTapped {
            self.dismiss(animated: true, completion: nil)
        }
        self.betView = Bundle.main.loadNibNamed("BetView", owner: self, options: nil)?.first as? BetView
        self.betView?.getBorder()
        
        betView?.sendMutlipyBlock = {
            (num) in
           self.delegate?.getBetNum(num: num)
            self.dismiss(animated: true, completion: nil)
        }
        
        betView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-50, height: 200)
        betView?.center = self.view.center
        betView?.witchBtnSelected = mutlipy
        self.betView?.layer.cornerRadius = 10
        self.betView?.layer.masksToBounds = true
        self.betView?.layer.borderColor = UIColor.green.cgColor
        self.betView?.layer.borderWidth = 2
        
        self.view.addSubview(betView!)
        
        let backBtn = UIButton(frame: CGRect(x: (self.betView?.frame.origin.x)!+(self.betView?.frame.size.width)!-20, y: (self.betView?.frame.origin.y)!-10, width: 30, height: 30))
        backBtn.setImage(UIImage(named:"lottery_charge"), for: .normal)
        backBtn.transform = CGAffineTransform(rotationAngle: CGFloat((90/360)*Double.pi))
//        backBtn.center = CGPoint(x: bgView.frame.size.width+30, y: bgView.frame.origin.y)
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
    }

    func back() {
        self.dismiss(animated: true, completion: nil)
    }
    

}
