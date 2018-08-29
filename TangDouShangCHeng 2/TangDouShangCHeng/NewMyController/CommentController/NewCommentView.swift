//
//  NewCommentView.swift
//  TaoPiao
//
//  Created by 黎应明 on 2018/3/13.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class NewCommentView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate {
    @IBOutlet weak var goodImageView: UIImageView!
    
    @IBOutlet weak var commentStarsView: UIView!
    //    @IBOutlet weak var commentStarsView: CommentStars!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var noTextLabel: UILabel!
    @IBOutlet weak var collectHeight: NSLayoutConstraint!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    var imageArr:[String] = []
    var starView:CommentStars?
    var activityIndicator:UIActivityIndicatorView?
    var photoArr:[UIImage] = []
    
    var orderModel:OrderModel?{
        didSet{
            
            goodImageView.sd_setImage(with: URL(string: (orderModel?.good_header)!), placeholderImage: nil)
        }
    }
    override func awakeFromNib() {

        let starView = CommentStars(frame:CGRect(x: 0, y: 0, width: 120, height: 30))
        
        commentStarsView.addSubview(starView)
        self.starView = starView
        self.commentTextView.delegate = self
        initCollectionView()
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: kWidth/2-40, y: kHeight/2-60, width: 80, height: 80))
        self.activityIndicator?.backgroundColor = UIColor(white: 0, alpha: 0.25)
        self.activityIndicator?.layer.masksToBounds = true
        self.activityIndicator?.layer.cornerRadius = 10
        self.activityIndicator?.activityIndicatorViewStyle = .gray
        self.addSubview(self.activityIndicator!)
    }
    
    
    func addComment() {
        activityIndicator?.startAnimating()
        var content = ""
        
        if commentTextView.text == "" {
            content = ""
        }else{
            content = commentTextView.text
        }
        
        var imgStrs = ""
        if !self.imageArr.isEmpty {
            for img in self.imageArr{
                imgStrs += img+","
            }
        }
        print(imgStrs)
        var rate =  ""
        if ((self.starView?.currentValue) != nil) {
            
            rate = String(format: "%.1f", (self.starView?.currentValue)!)
        }else{
            rate = "5"
        }
        print(rate)
        
//        HttpHelper.publicShaiDan(withUserId: ShareManager.shareInstance().userinfo.id,order_id:self.orderModel?.id,goods_id: self.orderModel?.good_id, title: "", content: content, imgs: imgStrs,rate:rate, success: { (data) in
//            let dict = data! as NSDictionary
//             print("??dict???",dict)
//            let status = dict["status"] as! NSString
//            self.activityIndicator?.stopAnimating()
//            if status == "0"{
//                print("bingo")
//                let vc = self.next?.next?.next as! UIViewController
//                let pvc = NewCommentSuccesViewController(nibName: "NewCommentSuccesViewController", bundle: nil)
//                pvc.num = ((dict["data"] as! NSDictionary)["present_num"] as! String)
//                vc.navigationController?.pushViewController(pvc, animated: true)
//               Tool.showPromptContent("提交成功")
//            }else{
////                print("??????",dict["desc"])
//            }
//        }) { (error) in
//             print("error")
//            self.activityIndicator?.stopAnimating()
//            Tool.showPromptContent("网络请求失败")
//        }
    }
    
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.noTextLabel.isHidden = true
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            self.noTextLabel.isHidden = false
        }
    }
    
    func initCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let width = 76
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
                let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
                
                let alertConfirm = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (alertConfirm) -> Void in
                    // 点击确定时
                    self.photoArr.remove(at: indexPath.row)
                    self.imageArr.remove(at: indexPath.row)
                    let width:CGFloat = CGFloat(40 + (self.photoArr.count+1)*76)
                    if (width < kWidth){
                        self.collectHeight.constant = 76
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
                    self.collectHeight.constant = 76+76
                }
                self.photoCollectionView.reloadData()
                
            })
        }else{
            Tool.showPromptContent("最多只能上传8张照片")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(10, 0, 0, 0)
    }

}
