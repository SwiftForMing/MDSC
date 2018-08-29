//
//  PaySelectedCell.m
//  DuoBao
//
//  Created by clove on 3/10/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "PaySelectedCell.h"
#import "PaySelectedData.h"

@implementation PaySelectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textLabel.textColor = [UIColor colorFromHexString:@"474747"];
    self.textLabel.font = [UIFont systemFontOfSize:13];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)relaodWithData:(PaySelectedData *)data
{
    NSString *imageName = @"icon_checkbox_circle_normal";
    
    if (data.isSelected) {
        imageName = @"icon_checkbox_circle_selected";
    } else {
        imageName = @"icon_checkbox_circle_normal";
    }
    _checkImageView.image = [UIImage imageNamed:imageName];
    [self.contentView bringSubviewToFront:_checkImageView];
    
    MLog(@"_checkImageView%@",data.pay_img);
   
    
    if (data.pay_img) {
        [self.imageView sd_setImageWithURL:[[NSURL alloc]initWithString:data.pay_img] placeholderImage:[data image]];
    } else {
        
        NSString *imagePath = data.imagePath;
        if (imagePath.length > 0) {
            __weak typeof(self) wself = self;
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (cacheType == SDImageCacheTypeNone && image) {
                    
                    [UIView transitionWithView:wself.imageView
                                      duration:0.25
                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                    animations:^{
                                        wself.imageView.image = image;
                                    } completion:^(BOOL finished) {
                                        
                                    }];
                    
                    [wself.imageView setNeedsLayout];
                }
            }];
        }
    }

    self.textLabel.text = data.title;
    self.textLabel.backgroundColor = [UIColor clearColor];
}

@end
