//
//  HistoryCell.swift
//  TaoPiao
//
//  Created by 黎应明 on 2017/11/25.
//  Copyright © 2017年 黎应明. All rights reserved.
//

import UIKit

class HistoryCell: UICollectionViewCell {

    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var bgView: UIImageView!
    var model:HisteryModel?{
        didSet{
            if model?.win_choice == "1" {
                self.bgView.image = UIImage(named: "bet_type_0")
            }
            if model?.win_choice == "2" {
                self.bgView.image = UIImage(named: "bet_type_1")
            }
            if model?.win_choice == "3" {
                self.bgView.image = UIImage(named: "bet_type_2")
            }
            if model?.win_choice == "4" {
                self.bgView.image = UIImage(named: "bet_type_3")
            }
            if model?.win_choice == "5" {
                self.bgView.image = UIImage(named: "bet_type_4")
            }
            if model?.win_choice == "6" {
                self.bgView.image = UIImage(named: "bet_type_5")
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
