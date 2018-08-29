//
//  DataManager.swift
//  FMDBDemo
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 黎应明. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    //定义一个单列对象（类对象）
    //系统中shareManager、defaultManager、standardManager获取的对象都是单列对象
    static let shareManager = DataManager()
    
    //定义管理数据库的对象
    let fmdb:FMDatabase!
    
    //线程锁,通过枷锁和解锁，来保证所做操作数据的安全性
    let lock = NSLock()

    //1.重写父类的构造方法
    override init(){
        //1.设置数据库的路径,fmdb.sqlite是由自己命名
        let path = NSHomeDirectory() + "/Documents/fmdb.sqlite"
        //2.构造管理数据库的对象
        fmdb = FMDatabase(path: path)
        //3.判读数据库是否打开成功.如果打开失败需要创建数据库
        if !fmdb.open(){
        
        print("数据库打开失败")
            return
        }else{
//             print("1234567890")
        }
        //3.创建数据库
        //data1表示表明,id和neirong是需要收藏的模型中的字段，须更模型中保持一致,bolb表示二进制数据NSData
        let createSql = "create table if not exists data1(id varchar(1024),good_imgs varchar(1024),coupons_price varchar(1024),good_price varchar(1024),coupons_id varchar(1024),profit_price varchar(1024),goods_type_id varchar(1024),good_header varchar(1024),good_name varchar(1024),order_num varchar(1024),coupons_name varchar(1024),valid_date varchar(1024),after_coupons_price varchar(1024),coupons_value varchar(1024),coupons_type varchar(1024),coupons_condition varchar(1024))"
        

        //4.执行sql语句,进行数据库的创建
        do{
         try fmdb.executeUpdate(createSql, values: nil)
        }catch{
            
        print(fmdb.lastErrorMessage())
        }
    
    }
    //增
    func insertDataWith(_ model:HomeGoodModel) {
        //加锁操作
        lock.lock()
        //sql语句
        
        let insertSql = "insert into data1(id,good_imgs,coupons_price,good_price,coupons_id,profit_price,goods_type_id,good_header,good_name,order_num,coupons_name,valid_date,after_coupons_price,coupons_value,coupons_type,coupons_condition) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"

        //更新数控库
        do{
        try fmdb.executeUpdate(insertSql, values: [model.id,model.good_imgs,model.coupons_price,model.good_price,model.coupons_id,model.profit_price,model.goods_type_id,model.good_header,model.good_name,model.order_num,model.coupons_name,model.valid_date,model.after_coupons_price,model.coupons_value,model.coupons_type,model.coupons_condition])
//            try fmdb.executeUpdate(insertSql, values: [model.id,model.good_imgs])
             Tool.showPromptContent("收藏成功")
        }catch{
            
            print(fmdb.lastErrorMessage())
            Tool.showPromptContent("收藏失败")
        }
        
        
        //解锁操作
        lock.unlock()
        
    }
    //删
    func deleteDataWith(model:HomeGoodModel) {
        lock.lock()
        let deleteSql = "delete from data1 where id = ?"
        //更新数据库
        do{
        try fmdb.executeUpdate(deleteSql, values: [model.id])
        }catch{
            print(fmdb.lastErrorMessage())
        }
        
        
        lock.unlock()
    }
    
    //改
    func updateDataWith(model:HomeGoodModel,dataID:String) {
        lock.lock()
        //where id = ?"中的id可传可不传

        let updateSql = "update data1 set id = ?,good_imgs = ?,coupons_price = ?,good_price = ?,coupons_id = ?,profit_price = ?,goods_type_id = ?,good_header = ?,good_name = ?,order_num = ?,coupons_name = ?,valid_date = ?,after_coupons_price = ?,coupons_value = ?,coupons_type = ?,coupons_condition = ? where id = ?"
//         let updateSql = "update data1 set id = ?,good_imgs = ? where id = ?"
        //更新数据库
        do{
            try fmdb.executeUpdate(updateSql, values: [model.id,model.good_imgs,model.coupons_price,model.good_price,model.coupons_id,model.profit_price,model.goods_type_id,model.good_header,model.good_name,model.order_num,model.coupons_name,model.valid_date,model.after_coupons_price,model.coupons_value,model.coupons_type,model.coupons_condition])

            
        }catch{
            print(fmdb.lastErrorMessage())
        }
        lock.unlock()
        
    }
     //查找单条数据
    func isHasDataInTable(model:HomeGoodModel)->Bool {
       
        let isHasSql = "select * from data1 where id = ?"
        do{
            let set = try fmdb.executeQuery(isHasSql, values: [model.id])
            //查找当前行，如果数据存在接着查找下一行
            if set.next(){
            return true
            }else{
            return false
            }
        }catch{
            print(fmdb.lastErrorMessage())
        
        
        }
        
        
        return true
    }
    
    //查询所有数据
    func fetchAllData()->[HomeGoodModel] {
        lock.lock()
        let fetchSql = "select * from data1"
        
        var tempArry = [HomeGoodModel]()
        do{
            let set = try fmdb.executeQuery(fetchSql, values: nil)
            //循环遍历
            while set.next() {
                let model = HomeGoodModel()
                //给字段赋值
                model.id = set.string(forColumn: "id")
                model.good_imgs = set.string(forColumn: "good_imgs")
                model.coupons_price = set.string(forColumn: "coupons_price")
                model.good_price = set.string(forColumn: "good_price")
                model.coupons_id = set.string(forColumn: "coupons_id")
                model.profit_price = set.string(forColumn: "profit_price")
                model.goods_type_id = set.string(forColumn: "goods_type_id")
                model.good_header = set.string(forColumn: "good_header")
                model.good_name = set.string(forColumn: "good_name")
                model.order_num = set.string(forColumn: "order_num")
                model.coupons_name = set.string(forColumn: "coupons_name")
                model.valid_date = set.string(forColumn: "valid_date")
                model.after_coupons_price = set.string(forColumn: "after_coupons_price")
                model.coupons_value = set.string(forColumn: "coupons_value")
//                model.coupons_status = set.string(forColumn: "coupons_status")
                model.coupons_type = set.string(forColumn: "coupons_type")
                model.coupons_condition = set.string(forColumn: "coupons_condition")
//                model.status = set.string(forColumn: "status")
//                model.content_imgs = set.string(forColumn: "content_imgs")
                tempArry.append(model)
                
            }
            
        }catch{
            print(fmdb.lastErrorMessage())
        }
        
        
        lock.unlock()
        
        return tempArry
    }
}
