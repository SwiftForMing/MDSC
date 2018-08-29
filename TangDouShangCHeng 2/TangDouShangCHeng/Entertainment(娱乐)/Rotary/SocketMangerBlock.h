//
//  SocketMangerBlock.h
//  socketTest
//
//  Created by 黎应明 on 2017/11/20.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^MessageReplyBlock)(id data);

@interface SocketMangerBlock : NSObject{
    
}

@property (nonatomic) NSString *matchMessageID;//方法id
@property (nonatomic,strong) MessageReplyBlock messageBlock;
@property (nonatomic) BOOL isRunning;
//初始化block
-(id)initWithIdentify:(NSString *)matchID block:(MessageReplyBlock)block;
//
-(void)performBlockdata:(id)data;
//判断是回调还是push
-(BOOL)matchWithIdenify:(NSString *)value;
//关闭
-(void)cancel;
@end
