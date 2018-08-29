//
//  ImageCollectionViewCell.h
//  SNJ
//
//  Created by linqsh on 15/11/8.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
