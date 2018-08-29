//
//  SixRulerViewController.swift
//  TangDouShangCHeng
//
//  Created by 黎应明 on 2018/7/27.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class SixRulerViewController: UIViewController {
    var rulerView:SixRluer?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.whenTapped {
            self.dismiss(animated: true, completion: nil)
        }
        
        let bg =  UIView(frame: self.view.frame)
        bg.backgroundColor = UIColor.clear
        
        self.view.addSubview(bg)
        
        let bgView = UIView(frame: CGRect(x: 30, y: 150, width: UIScreen.main.bounds.size.width-60, height: 300))
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 10
        bgView.backgroundColor = UIColor(fromHexString: "102914")
        bgView.layer.borderColor = UIColor.green.cgColor
        bgView.layer.borderWidth = 2
        
        self.rulerView = Bundle.main.loadNibNamed("SixRluer", owner: self, options: nil)?.first as? SixRluer
        
        self.rulerView?.textView.isUserInteractionEnabled = false
        self.rulerView?.frame = CGRect(x: 0, y: 0, width: bgView.frame.size.width, height: 300)
        bgView.addSubview(self.rulerView!)
        bg.addSubview(bgView)
        
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        backBtn.setImage(UIImage(named:"lottery_charge"), for: .normal)
        backBtn.transform = CGAffineTransform(rotationAngle: CGFloat((90/360)*Double.pi))
        backBtn.center = CGPoint(x: bgView.frame.size.width+25, y: bgView.frame.origin.y+5)
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        bg.addSubview(backBtn)
    }
    
    func back() {
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
