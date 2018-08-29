//
//  FireRulerViewController.swift
//  TangDouShangCHeng
//
//  Created by 黎应明 on 2018/5/21.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class FireRulerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "活动规则"
        self.view.whenTapped {
            self.dismiss(animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }

}
