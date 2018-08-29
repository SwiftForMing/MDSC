//
//  NewBaseShopCollectionView.swift
//  NewShopTest
//
//  Created by 黎应明 on 2017/12/11.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

protocol NewBaseCollectionDelegate {
    func pushToDouBaoWith(_ tag:Int)
    func pushToGoodDetialWith(_ goodId:String)
    
    
}
@objc(NewBaseShopCollectionView)
class NewBaseShopCollectionView:
UIView,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var collectionView:UICollectionView?
    var modelArr:[ShowModel] = []
    var delegate:NewBaseCollectionDelegate?
    var cellName:String?
    
    init(frame: CGRect,modelArr:[ShowModel],cell:String) {
        self.modelArr = modelArr
        self.cellName = cell
        super.init(frame: frame)
        let layout = UICollectionViewFlowLayout()
        if self.cellName == "NewShopCollectionCell" {
           layout.itemSize = CGSize(width: 157, height: 250)
        }else if self.cellName == "NewHomeDuoBaoCell"{
            if modelArr.count <= 4{
                layout.itemSize = CGSize(width: (UIScreen.main.bounds.width-40)/CGFloat(modelArr.count), height: 100)
            }else{
               layout.itemSize = CGSize(width: (UIScreen.main.bounds.width-40)/4, height: 100)
            }
        }
       
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.addSubview(self.collectionView!)
        self.collectionView?.isScrollEnabled = false
        self.collectionView?.register(UINib(nibName:cell, bundle: nil), forCellWithReuseIdentifier: "shopCell")
       
    }
    
   
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
            return modelArr.count
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.cellName == "NewShopCollectionCell" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopCell", for: indexPath) as! NewShopCollectionCell
            cell.disCountLabel.text = "好多优惠券"
            
            return cell;
        }else if self.cellName == "NewHomeDuoBaoCell" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopCell", for: indexPath) as! NewHomeDuoBaoCell
            cell.typeImageView.image = UIImage(named: modelArr[indexPath.row].showImg!)
            cell.typeLabel.text = modelArr[indexPath.row].showTitle!

            return cell;
        }else{
            let cell = UICollectionViewCell()
            
            return cell
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 20, 5, 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.cellName == "NewHomeDuoBaoCell" {
            //根据tag进行跳转
            let model = modelArr[indexPath.row]
            print("model.tag",model.tag)
            if model.tag != "0"{
               self.delegate?.pushToDouBaoWith(Int(model.tag!)!)
            }else{
              
            }
        }
        
        if self.cellName == "NewShopCollectionCell"{
            self.delegate?.pushToGoodDetialWith("collectionpush")
            
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
