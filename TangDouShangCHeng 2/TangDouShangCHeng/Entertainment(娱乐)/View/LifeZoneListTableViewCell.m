//
//  LifeZoneListTableViewCell.m
//  YCSH
//
//  Created by linqsh on 15/12/4.
//  Copyright © 2015年 linqsh. All rights reserved.
//

#import "LifeZoneListTableViewCell.h"
#import "ImageListCollectionViewCell.h"

@implementation LifeZoneListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)initImageCollectView
{
    [_imageCollectView registerClass:[ImageListCollectionViewCell class] forCellWithReuseIdentifier:@"ImageListCollectionViewCell"];
    
    
}


#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count;
}


- (CGFloat)minimumInteritemSpacing {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageListCollectionViewCell *cell = (ImageListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageListCollectionViewCell" forIndexPath:indexPath];

    cell.imageView.clipsToBounds = YES;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[_imageArray objectAtIndex:indexPath.row]] placeholderImage:PublicImage(@"defaultImage")];

    return cell;
    
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake( (FullScreen.size.width-100)/3,(FullScreen.size.width - 100)/3);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *tableView = [self tableView];
    NSIndexPath *index = [tableView indexPathForCell:self];
    ImageListCollectionViewCell *cell = (ImageListCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if([self.delegate respondsToSelector:@selector(clickImageToSeeTableIndex: image:collectIndex:)]){
        
        [self.delegate clickImageToSeeTableIndex:index image:cell.imageView collectIndex:indexPath];
    }

}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

@end
