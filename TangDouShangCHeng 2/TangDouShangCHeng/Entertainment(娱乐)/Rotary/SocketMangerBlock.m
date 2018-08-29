//
//  SocketMangerBlock.m
//  socketTest
//
//  Created by 黎应明 on 2017/11/20.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "SocketMangerBlock.h"

@implementation SocketMangerBlock
-(id)initWithIdentify:(NSString *)matchID block:(MessageReplyBlock)block{
    self = [super init];
    if (self) {
        self.matchMessageID = matchID;
        self.messageBlock = block;
        self.isRunning = NO;
    }
    return self;
}

-(void)performBlockdata:(id)data{
    _isRunning = YES;
    self.messageBlock(data);
}

-(BOOL)matchWithIdenify:(NSString *)value{
    
    return [value isEqualToString:self.matchMessageID];
    
}

-(void)cancel{
    if (!self.isRunning) {
        _messageBlock(nil);
    }
}


@end
