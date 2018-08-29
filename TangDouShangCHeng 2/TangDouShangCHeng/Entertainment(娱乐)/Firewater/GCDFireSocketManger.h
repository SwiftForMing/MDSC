//
//  GCDSocketManger.h
//  socketTest
//
//  Created by 黎应明 on 2017/11/13.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@interface GCDFireSocketManger : NSObject
@property(nonatomic,strong) GCDAsyncSocket *socket;
//登陆
//@property(nonatomic,strong) BOOL *login;
@property (nonatomic,copy) void(^loginBlock)(NSDictionary *dict);

@property (nonatomic,copy) void(^buyBlock)(NSDictionary *dict);

@property (nonatomic,copy) void(^pushBlock)(NSDictionary *dict);

@property (nonatomic,copy) void(^resultsBlock)(NSDictionary *dict);
@property (nonatomic,copy) void(^danMuBlock)(NSDictionary *dict);
@property (nonatomic,copy) void(^myresultsBlock)(NSDictionary *dict);
@property (nonatomic,copy) void(^canNotBlock)(BOOL stop);


//单列
+(instancetype)sharedFireSocketManger;
-(NSData *)getCPackageDataWithModul:(uint16_t)moudel cmd:(uint16_t)cmd;

//链接
-(void)connectToServer;

//断开
-(void)cutOffSocket;

//重练
- (void)reconnectSocket;

@end
