//
//  AfterSclesView.swift
//  TaoPiao
//
//  Created by 黎应明 on 2018/2/27.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class AfterSclesView: UIView,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ResaveAddressDelegate {
    @IBOutlet weak var backName: UILabel!
    @IBOutlet weak var backTell: UILabel!
    @IBOutlet weak var backAddress: UILabel!
    
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tellLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var collectionViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var goodImage: UIImageView!
    
    @IBOutlet weak var goodNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var numLabel: UILabel!
    
    @IBOutlet weak var payBackBtn: UIButton!
    @IBOutlet weak var backPayViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var workBtn: UIButton!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var rebackBtn: UIButton!
    var btnTag = 0
    
    @IBOutlet weak var qustionTextView: UITextView!
    
    @IBOutlet weak var wordNumLabel: UILabel!
    
    var imageArr:[String] = []
    
    var photoArr:[UIImage] = []
    
    var addressModel:AfterAddressModel?{
        didSet{
            nameLabel.text = addressModel?.name
            tellLabel.text = addressModel?.tell
            addressLabel.text = addressModel?.address
        }
    }
    
    var model:OrderModel?{
        didSet{
            
            self.goodImage.sd_setImage(with: URL(string: (model?.good_header)!), placeholderImage: nil)
            self.goodNameLabel.text = model?.good_name
            self.priceLabel.text = model?.good_price
            self.numLabel.text = model?.buy_num
            
//            self.nameLabel.text = model.n
        }
    }
    override func awakeFromNib() {
        self.getBtnRedBorder(with: 0)
        getRedborderColor(view: payBackBtn)
        
        commitBtn.layer.masksToBounds = true
        commitBtn.layer.cornerRadius = 4
        commitBtn.setzGradient(leftColor: "ED533B", right: "EF2F48")
        
        
        rebackBtn.whenTapped {
            self.btnTag = 0
            self.getBtnRedBorder(with: self.btnTag)
            self.backPayViewConstraint.constant = kWidth*(175/375)
        }
        
        changeBtn.whenTapped {
            self.btnTag = 1
            self.getBtnRedBorder(with: self.btnTag)
            self.backPayViewConstraint.constant = 0
        }
        
        workBtn.whenTapped {
            self.btnTag = 2
            self.getBtnRedBorder(with: self.btnTag)
            self.backPayViewConstraint.constant = 0
        }
        
        self.qustionTextView.delegate = self
        
        initCollectionView()
        
        addressView.whenTapped {
            let vc = ResaveAddressViewController(nibName: "ResaveAddressViewController", bundle: nil)
            vc.delegate = self
            let navVC = self.next?.next?.next as! UIViewController
            navVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func addAddress(addresModel: AfterAddressModel) {
        self.addressModel = addresModel
    }
    
    func initCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let width = 76*(kWidth/375)
        layout.itemSize = CGSize(width: width, height: width)

        self.photoCollectionView.collectionViewLayout = layout
        self.photoCollectionView?.delegate = self
        self.photoCollectionView?.dataSource = self
        self.photoCollectionView?.backgroundColor = UIColor.clear
        self.photoCollectionView?.showsHorizontalScrollIndicator = false
        self.photoCollectionView?.showsVerticalScrollIndicator = false
        self.photoCollectionView?.register(UINib(nibName: "AddPhotoCell", bundle: nil), forCellWithReuseIdentifier: "addCell")
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoArr.count < 8 ? photoArr.count+1 : 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as! AddPhotoCell
        if indexPath.row == photoArr.count {
            cell.photoImageView.image = UIImage(named: "addPhoto")
            cell.delateImageView.isHidden = true
        }else{
            cell.delateImageView.isHidden = false
            cell.delateImageView.whenTapped({
                let message = "确定要删除照片吗？"
                let alert = UIAlertController(title: "删除照片", message: message, preferredStyle: UIAlertControllerStyle.alert)
                
                let alertConfirm = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (alertConfirm) -> Void in
                    // 点击确定时
                    self.photoArr.remove(at: indexPath.row)
                    self.imageArr.remove(at: indexPath.row)
                    let width:CGFloat = CGFloat(40 + (self.photoArr.count+1)*76)
                    if (width < kWidth){
                        self.collectionViewConstraint.constant = 286
                    }
                    self.photoCollectionView.reloadData()
                   
                }
                alert.addAction(alertConfirm)
                let cancle = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (cancle) -> Void in
                    
                }
                alert.addAction(cancle)
                // 提示框弹出
                let vc  = self.next?.next?.next as! UIViewController
                vc.present(alert, animated: true) { () -> Void in
                    
                }
                
            })
            cell.photoImageView.image = photoArr[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == photoArr.count&&photoArr.count<9 {
            let vc = self.next?.next?.next as! UIViewController
            ShareManager.shareInstance().selectPicture(fromDevice: vc, isReduce: true, isSelect: true, isEdit: true, block: { (image, imageName) in
                self.photoArr.append(image!)
                
                HttpHelper.postImageHttp(with: image, success: { (data) in
                    let dict = data as! Dictionary<String, Any>
                    let status = dict["status"] as! NSNumber
                    if status == 0{
                        let imgstr = dict["data"] as! String
                        self.imageArr.append(imgstr)
                    }
//                    print("postImageHttp",data)
                }, fail: { (error) in
                    print("error",error!)
                })
                let width:CGFloat = CGFloat(40 + (self.photoArr.count+1)*76)
                if (width > kWidth){
                    self.collectionViewConstraint.constant = 286+80
                }
                self.photoCollectionView.reloadData()
                
            })
        }else{
            Tool.showPromptContent("最多只能上传8张图片")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(24, 0, 0, 0)
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let str = textView.text
//        if Int((str?.count)!)>10 {
//            return false
//        }else{
//            return true
//        }
//    }
    
    
    func textViewDidChange(_ textView: UITextView){
        
        let str = textView.text
        
        wordNumLabel.text = "\((str?.count)!)/200"
        
    }
    
    func getBtnGaryBorder() {
        self.getGrayborderColor(view: workBtn)
        self.getGrayborderColor(view: changeBtn)
        self.getGrayborderColor(view: rebackBtn)
    }
    
    func getBtnRedBorder(with tag:Int) {
        self.getBtnGaryBorder()
        if tag == 0 {
            self.getRedborderColor(view: rebackBtn)
            
        }
        if tag == 1 {
            self.getRedborderColor(view: changeBtn)
            
        }
        
        if tag == 2 {
            self.getRedborderColor(view: workBtn)
        }
    }
   
    
    func getGrayborderColor(view:UIView)  {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3
        view.layer.borderColor = UIColor(fromHexString: "999999").cgColor
        view.layer.borderWidth = 1
    }
    
    func getRedborderColor(view:UIView)  {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3
        view.layer.borderColor = UIColor(fromHexString: "E26650").cgColor
        view.layer.borderWidth = 1
    }
    
    //mark:提交
    @IBAction func comfirClick(_ sender: Any) {
        var type = ""
        switch self.btnTag {
        case 0:
            type = "退货"
            break
        case 1:
             type = "换货"
            break
        case 2:
             type = "维修"
            break
        default:
             type = ""
            break
        }
        
        if nameLabel.text == ""||tellLabel.text == ""||addressLabel.text == "" {
            Tool.showPromptContent("请填写收货信息")
            return
        }
        
        if qustionTextView.text == "" {
            Tool.showPromptContent("请填写问题描述")
            return
        }
        
        var imgStrs = ""
        if !self.imageArr.isEmpty {
            for img in self.imageArr{
                imgStrs += img+","
            }
        }
        
        print("imgStrs",imgStrs)
        
//        HttpHelper.postAfterScale(withId: self.model?.id, consignee_name: nameLabel.text, consignee_tel: tellLabel.text, consignee_address: addressLabel.text, retoure_type: type, problem_text: qustionTextView.text, problem_imgs: imgStrs, success: { (data) in
//            let dict = data! as NSDictionary
//            let status = dict["status"] as! String
//            if status == "0"{
//                let vc = SubmitResultsViewController(nibName: "SubmitResultsViewController", bundle: nil)
//                vc.stautes = type
//                let navVC = self.next?.next?.next as! UIViewController
//                navVC.navigationController?.pushViewController(vc, animated: true)
//            }
//            
//        }) { (error) in
//            print("error",error!)
//        }
        
        
        
        
    }
    
}
