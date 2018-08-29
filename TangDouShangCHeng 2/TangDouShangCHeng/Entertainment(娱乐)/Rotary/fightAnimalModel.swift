//
//  fightAnimalModel.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/11/23.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class fightAnimalModel: NSObject {
    var FightAnimal_1:String = "0"{
        didSet{
            let num:Int = Int(FightAnimal_1)!
            if num>10000 {
                FightAnimal_1 = "\(Double(num)/10000.0)万"
            }
            
        }
    }
    var FightAnimal_2:String = "0"{
        didSet{
            let num:Int = Int(FightAnimal_2)!
            if num>10000 {
                FightAnimal_2 = "\(Double(num)/10000.0)万"
            }
            
        }
    }
    var FightAnimal_3:String = "0"{
        didSet{
            let num:Int = Int(FightAnimal_3)!
            if num>10000 {
                FightAnimal_3 = "\(Double(num)/10000.0)万"
            }
            
        }
    }
    var FightAnimal_4:String = "0"{
        didSet{
            let num:Int = Int(FightAnimal_4)!
            if num>10000 {
                FightAnimal_4 = "\(Double(num)/10000.0)万"
            }
            
        }
    }
    var FightAnimal_5:String = "0"{
        didSet{
            let num:Int = Int(FightAnimal_5)!
            if num>10000 {
                FightAnimal_5 = "\(Double(num)/10000.0)万"
            }
            
        }
    }
    var FightAnimal_6:String = "0"{
        didSet{
            let num:Int = Int(FightAnimal_6)!
            if num>10000 {
                FightAnimal_6 = "\(Double(num)/10000.0)万"
            }
            
        }
    }
    

}
