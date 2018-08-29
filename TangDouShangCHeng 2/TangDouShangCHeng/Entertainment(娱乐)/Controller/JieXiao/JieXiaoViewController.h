//
//  JieXiaoViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayoutCollectView.h"

@interface JieXiaoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectView;

- (void)beginRefreshTop;

@end
