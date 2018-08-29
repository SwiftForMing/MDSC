//
//  RHRefreshControlViewCustom.h
//  Luxy
//
//  Created by justin on 3/25/15.
//  Copyright (c) 2015 robyzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHRefreshControlView.h"

typedef enum : NSUInteger {
    RefreshControlStyleDark,
    RefreshControlStyleLight
} RefreshControlStyle;


@interface RHRefreshControlViewCustom : UIView<RHRefreshControlView>

- (id)initWithFrame:(CGRect)frame style:(RefreshControlStyle)style;

@end
