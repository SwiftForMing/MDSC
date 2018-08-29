//
//  ChangeJiFenViewController.swift
//  TaoPiao
//
//  Created by 黎应明 on 2018/3/26.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class ChangeJiFenViewController: UIViewController,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var listView: UITableView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var getJiFenUserText: UITextView!
    @IBOutlet weak var jiFenNumText: UITextView!
    var detialModel:[ChangeDetailModel] = []
    var userId = ""
    var changeType = ""

    @IBOutlet weak var changeBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.changeType == "score"){
            self.title = "转让欢乐豆"
            typeLabel.text = "转让欢乐豆"
        }else{
            self.title = "转让小米"
            typeLabel.text = "转让小米"
        }
       
        getJiFenUserText.layer.masksToBounds = true
        getJiFenUserText.layer.cornerRadius = 5
        getJiFenUserText.layer.borderColor = UIColor(fromHexString: "f4f4f4").cgColor
        getJiFenUserText.layer.borderWidth = 1
        
        jiFenNumText.layer.masksToBounds = true
        jiFenNumText.layer.cornerRadius = 5
        jiFenNumText.layer.borderColor = UIColor(fromHexString: "f4f4f4").cgColor
        jiFenNumText.layer.borderWidth = 1
        
        changeBtn.layer.masksToBounds = true
        changeBtn.layer.cornerRadius = 20 
        getJiFenUserText.delegate = self
        changeBtn.whenTapped {
            self.changeJiFen()
        }
        
        self.listView.dataSource = self
        self.listView.delegate = self
        self.listView.separatorStyle = .none
        
        self.listView.register(UINib(nibName: "ChangeDetialCell", bundle: nil), forCellReuseIdentifier: "detialCell")
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
         self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav"), for: .default)
        self.getJiFenDetial()
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
       
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detialModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "detialCell", for: indexPath) as! ChangeDetialCell
        let model = self.detialModel[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        if changeType == "score" {
            cell.recordedLabel.text = "转让给\(model.adverse_id!)   \(model.score!)欢乐豆"
        }else{
           cell.recordedLabel.text = "转让给\(model.adverse_id!)   \(model.beans!)小米"
        }

        cell.timeLabel.text = Tool.timeString(toDateSting: model.create_time!, format: "yyyy-MM-dd hh:mm:ss")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func getJiFenDetial() {
        HttpHelper.getChangeJiFenDetial(withID:ShareManager.shareInstance().userinfo.id, success: { (data) in
            let dict = data! as NSDictionary
            print("getChangeJiFenDetial",dict)
            let arr = dict["data"] as! NSArray
            for arrDic in arr{
                let model = (arrDic as! NSDictionary).object(by: ChangeDetailModel.self) as! ChangeDetailModel
                if(self.changeType == "score"){
                    if(model.score != "0"){
                       self.detialModel.append(model)
                    }
                }else{
                    if(model.beans != "0"){
                        self.detialModel.append(model)
                    }
                }
            }
            self.listView.reloadData()
           
        }) { (error) in

        }
    }
    
  
    
    func textViewDidChange(_ textView: UITextView) {
        getJiFenUserText.textColor = UIColor.black
        if ShareManager.shareInstance().userinfo.id.count == textView.text.count{
        userId = getJiFenUserText.text
        self.getUserId()
        }
    }
    
    func getUserId()  {

        HttpHelper.getUserInfo(withUserId: getJiFenUserText.text, success: { (data) in
            let dict = data! as NSDictionary
            let status = dict["status"] as! String
            if status == "0"{
                let dic = dict["data"] as! NSDictionary
                self.handleloadUserInfoResult(dict: dic)
//                print("dic",dic)
            }else{
               Tool.showPromptContent("获取用户信息失败")
            }
            
        }) { (error) in

            Tool.showPromptContent("获取用户信息失败")
        }
        
    }
    
    func handleloadUserInfoResult(dict:NSDictionary) {
        let name = dict["nick_name"] as! String
        nameLabel.text = name
        
    }
  
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        if textView.text.count == ShareManager.shareInstance().userinfo.id.count {
            userId = textView.text
        }
        if textView.text.count > ShareManager.shareInstance().userinfo.id.count {
            textView.text = userId
        }
        return true
    }
    
    func changeJiFen() {
        getJiFenUserText.resignFirstResponder()
        jiFenNumText.resignFirstResponder()
        if getJiFenUserText.text.count != ShareManager.shareInstance().userinfo.id.count||getJiFenUserText.text == "" {
            Tool.showPromptContent("请输入正确的接受者id")
            return
        }
        
        if jiFenNumText.text.count > 10 {
            Tool.showPromptContent("超出金额")
            return
        }
        if changeType == "score" {
            HttpHelper.getChangeScores(withID: ShareManager.shareInstance().userinfo.id, getUserId: userId, changeScores: jiFenNumText.text, success: { (data) in
                let dict = data! as NSDictionary
                
                let status = dict["status"] as! String
                let desc = dict["desc"] as! String
                if status == "0"{
                    Tool.showPromptContent("转让成功")
                    Tool.getUserInfo()
                    self.perform(#selector(self.back), with: nil, afterDelay: 0.3)
                }else{
                    Tool.showPromptContent(desc, on: self.view)
                }
            }) { (error) in
                Tool.showPromptContent("转让失败", on: self.view)
            }
        }else{
        
        HttpHelper.getChangeJiFen(withID: ShareManager.shareInstance().userinfo.id, getUserId: userId, changeNum: jiFenNumText.text, success: { (data) in
            let dict = data! as NSDictionary
            
            let status = dict["status"] as! String
            let desc = dict["desc"] as! String
            if status == "0"{
                Tool.showPromptContent("转让成功")
                Tool.getUserInfo()
                self.perform(#selector(self.back), with: nil, afterDelay: 0.3)
            }else{
                 Tool.showPromptContent(desc, on: self.view)
            }
        }) { (error) in
            Tool.showPromptContent("转让失败", on: self.view)
            }
        }
    }
  
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
}


