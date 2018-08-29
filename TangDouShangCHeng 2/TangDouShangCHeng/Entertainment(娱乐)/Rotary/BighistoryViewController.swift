//
//  BighistoryViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/11/24.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class BighistoryViewController: BaseTableViewController {

    var listModelArr:[BigListModel] = []
    var headerView:BigListHeader?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        self.view.whenTapped {
            self.dismiss(animated: true, completion: nil)
        }
       let bg =  UIView(frame: self.view.frame)
           bg.backgroundColor = UIColor.clear
        
        self.view.addSubview(bg)
        
        let bgView = UIView(frame: CGRect(x: 30, y: 150, width: kWidth-60, height: kHeight-300))
        bgView.backgroundColor = UIColor(fromHexString: "102914")
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 10
        bgView.layer.borderColor = UIColor.green.cgColor
        bgView.layer.borderWidth = 2
        
       self.headerView = Bundle.main.loadNibNamed("BigListHeader", owner: self, options: nil)?.first as? BigListHeader
        self.headerView?.frame = CGRect(x: 0, y: 0, width: bgView.frame.size.width, height: 100)
        bgView.addSubview(self.headerView!)
        bg.addSubview(bgView)
        
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))

        backBtn.setImage(UIImage(named:"lottery_charge"), for: .normal)
        backBtn.transform = CGAffineTransform(rotationAngle: CGFloat((90/360)*Double.pi))
        backBtn.center = CGPoint(x: bgView.frame.size.width+25, y: bgView.frame.origin.y+5)
        backBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
        bg.addSubview(backBtn)
        
        self.tableView.register( UINib(nibName: "BigListCell", bundle: nil), forCellReuseIdentifier: "listCell")
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.showsHorizontalScrollIndicator = true
        self.tableView.frame = CGRect(x: 10, y: 100, width: bgView.frame.width-20, height: bgView.frame.size.height-100)
        bgView.addSubview(self.tableView)

        
        
        
        
        
        
    }
    
    func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listModelArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"listCell", for: indexPath) as! BigListCell
        let model = listModelArr[indexPath.row]
        cell.listModel = model
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear

        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
