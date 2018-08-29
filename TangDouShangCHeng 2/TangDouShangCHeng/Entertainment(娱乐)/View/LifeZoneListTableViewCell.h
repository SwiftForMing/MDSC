//
//  LifeZoneListTableViewCell.h
//  YCSH
//
//  Created by linqsh on 15/12/4.
//  Copyright © 2015年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LifeZoneListTableViewCellDelegate <NSObject>
@optional

- (void)clickImageToSeeTableIndex:(NSIndexPath *)tindex image:(UIImageView *)image collectIndex:(NSIndexPath *)cindex ;


@end

@interface LifeZoneListTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray *imageArray;

@property (nonatomic, assign) id<LifeZoneListTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectViewWidth;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsNameLabelHeight;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;

- (void)initImageCollectView;

@end
