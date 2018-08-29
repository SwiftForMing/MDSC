//
//  PopView.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/12/13.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class PopView: UIView {
    
    var _contentView: UIView?
    let UI_View_Width = UIScreen.main.bounds.width
    let UI_View_Height = UIScreen.main.bounds.height
    let XHHTuanNumViewHight:CGFloat = kHeight-150
    var hight:CGFloat = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupContent()
    }
    
    
    func setupContent() {
        self.frame = CGRect(x:0, y:0,width: UI_View_Width, height:XHHTuanNumViewHight)
        //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PopView.disMissView)))
        if _contentView == nil {
            _contentView = UIView(frame:CGRect(x: 0, y: UI_View_Height-XHHTuanNumViewHight, width: UI_View_Width, height: XHHTuanNumViewHight))
            _contentView?.backgroundColor = UIColor.white
            self.addSubview(_contentView!)
            // 右上角关闭按钮
            let closeBtn: UIButton = UIButton(type: .custom)
            
            closeBtn.frame = CGRect(x: (_contentView?.width)!-20-15, y: 15, width: 20, height: 20)
            closeBtn.setImage(UIImage(named: "guanbi"), for: .normal)
            closeBtn.addTarget(self, action: #selector(disMissView), for: .touchUpInside)
            _contentView?.addSubview(closeBtn)
        }
    }
    
    //展示从底部向上弹出的UIView（包含遮罩）
    func showInView(_ view: UIView,withChirdView:UIView,moveVaule:CGFloat) {
       
        view.addSubview(self)
        _contentView?.addSubview(withChirdView)
        
        view.addSubview(_contentView!)
        _contentView?.frame = CGRect(x: 0, y: UI_View_Height, width: UI_View_Width, height: XHHTuanNumViewHight)
        self.hight = withChirdView.frame.size.height-64
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
            let h = withChirdView.frame.size.height<self.UI_View_Height ? withChirdView.frame.size.height:self.UI_View_Height-64

             let y = self.UI_View_Height-withChirdView.frame.size.height>64 ? self.UI_View_Height-withChirdView.frame.size.height-64+moveVaule:0
           
              self._contentView?.frame = CGRect(x:0,y: y, width:self.UI_View_Width, height:h)
        })
    }
    
    //移除从上向底部弹下去的UIView（包含遮罩）
    func disMissView() {
        _contentView?.frame = CGRect(x:0,y: self.UI_View_Height-self.hight-64, width:UI_View_Width, height:XHHTuanNumViewHight)
        UIView.animate(withDuration: 0.3, animations: {    self.alpha = 0.0
            self._contentView!.frame = CGRect(x:0, y:self.UI_View_Height, width:self.UI_View_Width, height:self.XHHTuanNumViewHight)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
