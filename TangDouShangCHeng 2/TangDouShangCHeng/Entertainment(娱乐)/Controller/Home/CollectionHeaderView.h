//
//  CollectionHeaderView.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/22.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleScrollView.h"
@interface CollectionHeaderView : UIView
@property (weak, nonatomic) IBOutlet CycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControler;

@end
