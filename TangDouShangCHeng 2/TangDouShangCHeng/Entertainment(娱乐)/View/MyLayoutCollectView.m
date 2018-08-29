//
//  MyLayoutCollectView.m
//  YCSH
//
//  Created by linqsh on 15/12/3.
//  Copyright © 2015年 linqsh. All rights reserved.
//

#import "MyLayoutCollectView.h"

@implementation MyLayoutCollectView
{
//    //这个数组就是我们自定义的布局配置数组
//    NSMutableArray * _attributeAttay;
}

////数组的相关设置在这个方法中
////布局前的准备会调用这个方法
//-(void)prepareLayout{
//    _attributeAttay = [[NSMutableArray alloc]init];
//    [super prepareLayout];
//    //演示方便 我们设置为静态的2列
//    //计算每一个item的宽度
//    float WIDTH = ([UIScreen mainScreen].bounds.size.width-self.sectionInset.left-self.sectionInset.right-self.minimumInteritemSpacing)/2;
//    //定义数组保存每一列的高度
//    //这个数组的主要作用是保存每一列的总高度，这样在布局时，我们可以始终将下一个Item放在最短的列下面
//    CGFloat colHight[2]={self.sectionInset.top,self.sectionInset.bottom};
//    //itemCount是外界传进来的item的个数 遍历来设置每一个item的布局
//    for (int i=0; i<_itemCount; i++) {
//        //设置每个item的位置等相关属性
//        NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
//        //创建一个布局属性类，通过indexPath来创建
//        UICollectionViewLayoutAttributes * attris = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
//        //随机一个高度 在40——190之间
//        CGFloat hight = arc4random()%150+40;
//        //哪一列高度小 则放到那一列下面
//        //标记最短的列
//        int width=0;
//        if (colHight[0]<colHight[1]) {
//            //将新的item高度加入到短的一列
//            colHight[0] = colHight[0]+hight+self.minimumLineSpacing;
//            width=0;
//        }else{
//            colHight[1] = colHight[1]+hight+self.minimumLineSpacing;
//            width=1;
//        }
//        
//        //设置item的位置
//        attris.frame = CGRectMake(self.sectionInset.left+(self.minimumInteritemSpacing+WIDTH)*width, colHight[width]-hight-self.minimumLineSpacing, WIDTH, hight);
//        [_attributeAttay addObject:attris];
//    }
//    
//    //设置itemSize来确保滑动范围的正确 这里是通过将所有的item高度平均化，计算出来的(以最高的列位标准)
//    if (colHight[0]>colHight[1]) {
//        self.itemSize = CGSizeMake(WIDTH, (colHight[0]-self.sectionInset.top)*2/_itemCount-self.minimumLineSpacing);
//    }else{
//        self.itemSize = CGSizeMake(WIDTH, (colHight[1]-self.sectionInset.top)*2/_itemCount-self.minimumLineSpacing);
//    }
//    
//}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for(int i = 1; i < [attributes count]; ++i) {
        //当前attributes
        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
        //上一个attributes
        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
        //我们想设置的最大间距，可根据需要改
        NSInteger maximumSpacing = 0;
        //前一个cell的最右边
        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = origin + maximumSpacing;
            currentLayoutAttributes.frame = frame;
        }
    }
    return attributes;
}


@end
