//
//  GoodsListCollectionViewCell.m
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "GoodsListCollectionViewCell.h"
#import "UIView+Extend.h"

@implementation GoodsListCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
//    UIButton *button = _addButton;
//    [button setBorder:[UIColor defaultRedButtonColor] width:0.5];
//    button.layer.masksToBounds = YES;
//    UIColor *color = [UIColor defaultRedButtonColor];
//    
//    button.layer.cornerRadius = button.height * 0.1;
//    button.backgroundColor = [UIColor whiteColor];
//    [button setTitleColor:color forState:UIControlStateNormal];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"GoodsListCollectionViewCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}


@end
