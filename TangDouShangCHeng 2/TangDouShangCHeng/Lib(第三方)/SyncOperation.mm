//
//  SyncOperation.m
//  Luxy
//
//  Created by justin on 2/13/15.
//  Copyright (c) 2015 robyzhou. All rights reserved.
//

#import "SyncOperation.h"

@implementation SyncOperation

- (void)main
{
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    } while (!_done);
}

@end
