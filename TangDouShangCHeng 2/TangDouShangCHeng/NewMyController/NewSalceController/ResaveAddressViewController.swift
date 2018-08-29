//
//  ResaveAddressViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2018/3/6.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit
protocol ResaveAddressDelegate {
    func addAddress(addresModel:AfterAddressModel)
    
    
}
class ResaveAddressViewController: UIViewController {
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var tellText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    var delegate:ResaveAddressDelegate?
    
    var addressModel:AfterAddressModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "商品退回地址"
        if addressModel != nil {
            self.nameText.text = addressModel?.name
            self.tellText.text = addressModel?.tell
            self.addressText.text = addressModel?.address
            
            self.nameText.isUserInteractionEnabled = false
            self.tellText.isUserInteractionEnabled = false
            self.addressText.isUserInteractionEnabled = false
        }
       
        
        
        let rightItemControl = UIControl(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        rightItemControl.addTarget(self, action: #selector(self.delayMethod), for: .touchUpInside)
        let label = UILabel(frame: CGRect(x: 0, y: 13, width: 60, height: 18))
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "确定"
        label.textAlignment = .right
        rightItemControl.addSubview(label)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightItemControl)
        
        let leftControl = UIControl(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        leftControl.addTarget(self, action: #selector(back), for: .touchUpInside)
        let imageView  = UIImageView(frame: CGRect(x: 0, y: 13, width: 10, height: 18))
        imageView.image = UIImage(named: "shopBack")
        leftControl.addSubview(imageView)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftControl)
    }
    
    func delayMethod()  {
        if nameText.text == "" || tellText.text == "" || addressText.text == ""{
            Tool.showPromptContent("请输入收件人信息")
            return
        }else{
            let model = AfterAddressModel()
            model.name = nameText.text
            model.tell = tellText.text
            model.address = addressText.text
            self.delegate?.addAddress(addresModel: model)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func back() {
        
        self.navigationController?.popViewController(animated: true)
       
    }
   

}
