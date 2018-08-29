//
//  UITabBar+Badge.h
//  TangDouShangCHeng
//
//  Created by 黎应明 on 2018/7/3.
//  Copyright © 2018年 黎应明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)
- (void)showBadgeOnItmIndex:(int)index;
- (void)hideBadgeOnItemIndex:(int)index;
@end
