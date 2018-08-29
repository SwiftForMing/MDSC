//
//  SixUpCell.swift
//  TangDouShangCHeng
//
//  Created by 黎应明 on 2018/7/27.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class SixUpCell: UICollectionViewCell {

    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var labelWidth: NSLayoutConstraint!
    @IBOutlet weak var prollView: UIView!
    @IBOutlet weak var prollessLabel: UILabel!
    @IBOutlet weak var goodNameLabel: UILabel!
   
    @IBOutlet weak var goodImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prollView.layer.cornerRadius = prollView.frame.size.height/2
        self.prollView.layer.masksToBounds = true
        // Initialization code
    }

}
