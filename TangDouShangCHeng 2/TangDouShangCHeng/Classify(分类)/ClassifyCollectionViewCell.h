//
//  ClassifyCollectionViewCell.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/8/30.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodTypeModel.h"
@interface ClassifyCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) GoodTypeModel *typeModel;
//@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLine;

@end
