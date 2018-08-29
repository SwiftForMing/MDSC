//
//  AddPhotoCell.swift
//  TaoPiao
//
//  Created by 黎应明 on 2018/3/5.
//  Copyright © 2018年 黎应明. All rights reserved.
//

import UIKit

class AddPhotoCell: UICollectionViewCell {

    @IBOutlet weak var delateImageView: UIImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.cornerRadius = 4
        // Initialization code
    }

   
}
