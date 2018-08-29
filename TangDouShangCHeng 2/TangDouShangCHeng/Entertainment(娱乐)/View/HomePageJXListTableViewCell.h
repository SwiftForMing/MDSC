//
//  HomePageJXListTableViewCell.h
//  DuoBao
//
//  Created by gthl on 16/2/14.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayoutCollectView.h"

@protocol HomePageJXListTableViewCellDelegate <NSObject>
@optional
- (void)selectJXGoodsInfo:(NSInteger)index;

@end

@interface HomePageJXListTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@property (nonatomic, assign) id<HomePageJXListTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;




- (void)initImageCollectView;

- (void)updateTimeLabelUI:(NSString *)timeStr index:(NSInteger)index;
@end
