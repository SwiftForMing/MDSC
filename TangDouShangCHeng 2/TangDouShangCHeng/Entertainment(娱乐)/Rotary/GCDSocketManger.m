//
//  GCDSocketManger.m
//  socketTest
//
//  Created by 黎应明 on 2017/11/13.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#import "GCDSocketManger.h"
#import "SocketMangerBlock.h"
#import "YMSocketUtils.h"

#define SocketHost @"47.104.247.161"
#define SocketPort 10808

//#define SocketHost @"f2048837y3.51mypc.cn"
//#define SocketPort 16002

//测试服务器doug
//#define SocketHost @"192.168.31.186"
//#define SocketPort 10808

#define LengthOfPackageHeader 16
#define PackageFlag -21415431

@interface GCDSocketManger()<GCDAsyncSocketDelegate>{
    unsigned long long matchID;
    BOOL isConnected;
    NSMutableData *_packageData;
    NSMutableData *_currentData;
}
//握手次数
@property(nonatomic,assign) NSInteger pushCout;
//断开次数
@property(nonatomic,assign) NSInteger reconnectCount;



@end

@implementation GCDSocketManger

- (void)dealloc
{
    MLog(@"GCDSocketManger %@", NSStringFromSelector(_cmd));
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _packageData = [[NSMutableData alloc]init];
    }
    
    return self;
}

#pragma mark - 请求链接

-(void)connectToServer{
    
    // 初始化握手次数
    self.pushCout = 0;
    
    dispatch_queue_t queue = dispatch_queue_create("com.quanuqan.socket", NULL);
    // 初始化socket
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    
    // 开始链接
    [self connectSocket];
}


- (void)connectSocket
{
    NSError *error = nil;
    // 开始链接
    [self.socket connectToHost:SocketHost onPort:SocketPort error:&error];
    
    if (error) {
        MLog(@"ScoketConnectError:%@",error);
    }
}


- (void)reconnectSocket
{
    if (self.socket.isConnected == NO) {
        
        NSError *error = nil;
        [self.socket connectToHost:SocketHost onPort:SocketPort error:&error];
        if (error) {
            MLog(@"ScoketConnectError:%@",error);
            [self performSelector:@selector(reconnectSocket) withObject:nil afterDelay:1];
        }
    }
}

- (void)disconnectSocket
{
    GCDAsyncSocket *socket = self.socket;
    self.socket = nil;
    [socket disconnect];
}

#pragma mark -

- (SocketMangerBlock *)createMessageBlock:(MessageReplyBlock )block
{
    NSString *str = [NSString stringWithFormat:@"%lld", matchID++];
    return [[SocketMangerBlock alloc] initWithIdentify:str block:block];
}

#pragma mark - Socket

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    MLog(@"Socket连接成功，准备上传数据");
    [self sendDataToSever];
}

//链接成功想服务器发送数据后，服务器会有相应
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    MLog(@"didReadData = %ld", data.length);
   
    [_packageData appendData:data];
    
    uint32_t length = [self packageLength];
    
    if (length > 0) {
        
        // 检查是否获取到完整包
        if ([self isPackageFinish]) {
            
            // 分割包解包
            [self parseBuffer];
        }
        
        // 发生粘包，等待接收后续包
    } else if (length == -1){
        
    }
    
    // must
    [self.socket readDataWithTimeout:-1 tag:-1];
}


- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
    MLog(@"didWriteDataWithTag%ld",tag);
}


- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    MLog(@"sock.isConnected%id",sock.isConnected);
    
    if (sock == self.socket && sock.isConnected == NO) {
        [self reconnectSocket];
    }
}

#pragma mark -

-(void)sendDataToSever{
    
    if ([ShareManager shareInstance].token == nil) {
        [Tool loginWithAnimated:YES viewController:nil];
        return;
    }
    
    NSMutableData *josnData = [NSMutableData data];

    // 登录token
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[ShareManager shareInstance].token forKey:@"token"];
    NSData *dddd =[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    [josnData appendData:[self getCPackageDataWithModul:1 cmd:1]];
    [josnData appendData:[YMSocketUtils bytesFromUInt32:(uint32_t )[dddd length]]];
    [josnData appendData:dddd];

    MLog(@"josnData%@",parameters);
    [self.socket writeData:josnData withTimeout:-1 tag:200];
    [self.socket readDataWithTimeout:-1 tag:200];
}


//构造请求包头
-(NSData *)getCPackageDataWithModul:(uint16_t)moudel cmd:(uint16_t)cmd{
    
    NSMutableData *packData = [[NSMutableData alloc]init];
    int sch = -21415431;
    unsigned char valChar[4];
    memcpy(valChar,&sch, sizeof(int));
    
    unsigned char valChar1[2];
    memcpy(valChar1,&moudel, sizeof(uint16_t));
    
    unsigned char valChar2[2];
    memcpy(valChar2,&cmd, sizeof(uint16_t));
    
    [packData appendBytes:valChar2 length:2];
    [packData appendBytes:valChar1 length:2];
    [packData appendBytes:valChar length:4];
    MLog(@"packData%@",packData);
    return [YMSocketUtils dataWithReverse:packData];
}


// 获取当前处理包的长度，返回-1表示粘包（length被分割）
- (uint32_t)packageLength
{
    uint32_t length = 0;
    
    NSData *data = _packageData;
    uint32_t currentLength = (uint32_t)data.length;
    
    // 是否包含包头长度数据
    if (currentLength >= LengthOfPackageHeader) {
        NSData *temp1 = [data subdataWithRange:NSMakeRange(LengthOfPackageHeader-4, 4)];
        NSData *packageData1 = [YMSocketUtils dataWithReverse:temp1];
        unsigned char vchar[4];
        [packageData1 getBytes:vchar range:NSMakeRange(0, 4)];
        int32_t *m = (int32_t *)vchar;
        //        MLog(@"len>>>>>>>>%d", *m);
        length = *m + LengthOfPackageHeader;
        
    } else {
        
        length = -1;
    }
    
    //    MLog(@"packageLength>>>>>%u",length);
    return length;
}


- (BOOL)isPackageFinish
{
    BOOL result = NO;
    
    uint32_t length = [self packageLength];
    uint32_t currentLength = (uint32_t)_packageData.length;
    if (currentLength >= length && length > 0) {
        result = YES;
    }
    return result;
}

// 分割出完整包
- (NSData *)fullPackageFromBuffer
{
    NSData *data = nil;
    
    if ([self isPackageFinish]) {
        uint32_t length = [self packageLength];
        NSRange range = NSMakeRange(0, length);
        data = [_packageData subdataWithRange:range];
    }
    
    return data;
}

// buffer解构
- (void)parseBuffer
{
    if ([self isPackageFinish]) {

        NSData *fullData = [self fullPackageFromBuffer];
        [self loginCheckWithData:fullData];
        [self resetBuffer];
    }
    
    if ([self isPackageFinish]) {
        [self parseBuffer];
    }
}

// 分割出剩余包
- (void)resetBuffer
{
    if ([self isPackageFinish]) {
        
        uint32_t length = [self packageLength];
        NSRange range = NSMakeRange(length, _packageData.length - length);
        NSData *data = [_packageData subdataWithRange:range];
        
        _packageData = [NSMutableData dataWithData:data];
    }
}

-(void)loginCheckWithData:(NSData *)data
{
    NSData *jsonData = [data subdataWithRange:NSMakeRange(LengthOfPackageHeader, data.length - LengthOfPackageHeader)];
    NSData *modelData = [data subdataWithRange:NSMakeRange(4, 2)];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(6, 2)];
    NSData *codeData = [data subdataWithRange:NSMakeRange(8, 4)];
    int moudel = [YMSocketUtils uint16FromBytes:modelData];
    int cmd = [YMSocketUtils uint16FromBytes:cmdData];
    int code = [YMSocketUtils uint32FromBytes:codeData];
    
    if (moudel == 1&&cmd==1) {
        if (code == 0) {
            MLog(@"登陆成功");
            [self checkJasonDataWithData:jsonData code:1];
            
        }else if (code == 1){
            MLog(@"登陆失败");
        }else if (code == 13){
            [self checkJasonDataWithData:jsonData code:13];
            
            MLog(@"登陆成功，揭晓中。。。。");
        }else if (code == 8){
            MLog(@"重复登陆");
        }
    }
    
    if (moudel == 5&&cmd==3) {
        if (code == 0) {
            MLog(@"购买返回成功");
            [self checkJasonDataWithData:jsonData code:3];
            
        }else if (code == 1){
            MLog(@"购买返回失败");
        }else if(code == 14){
            self.canNotBlock(true);
            MLog(@"揭晓中无法购买");
            
        }
        
    }
    
    if (moudel == 4&&cmd==102) {
        
        if (code == 0) {
            MLog(@"推送成功");
            [self checkJasonDataWithData:jsonData code:102];
            
        }else if (code == 1){
            MLog(@"推送失败");
        }
    }
    if (moudel == 4&&cmd==103) {
        
        if (code == 0) {
            MLog(@"开奖推送成功");
            [self checkJasonDataWithData:jsonData code:103];
            
        }else if (code == 1){
            MLog(@"推送失败");
        }
    }
    
    if (moudel == 4&&cmd==104) {
        
        if (code == 0) {
            MLog(@"开奖推送成功");
            [self checkJasonDataWithData:jsonData code:104];
            
        }else if (code == 1){
            MLog(@"推送失败");
        }
    }
    
}


-(void)checkJasonDataWithData:(NSData *)data code:(int)code{
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
     MLog(@"json=========：%@",dict);
    if(err) {
        MLog(@"json解析失败：%@",err);
        
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (code == 1) {
                self.loginBlock(dict);
                MLog(@"%@", [dict my_description]);

            }
            
            if (code == 3) {
                //                MLog(@"time>>>>>>%@",dict[@"time"]);
                MLog(@"%@", [dict my_description]);

                self.buyBlock(dict);
            }
            //推送刷新
            if (code == 102) {
                
                long long time = [[dict objectForKey:@"time"] longLongValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
                NSInteger second = [date secondsAfterDate:[NSDate date]];
                NSLog(@"second different = %ld      %@", second, date);
                
                self.pushBlock(dict);
            }
            
            if (code == 13) {
                //                 self.cjieXiaoBlock(dict);
                self.loginBlock(dict);
            }
            
            //我中奖了
            if (code == 103) {
                self.myresultsBlock(dict);
                MLog(@"%@", [dict my_description]);

            }
            //结果，时间
            if (code == 104) {
                self.resultsBlock(dict);
                MLog(@"%@", [dict my_description]);

            }
        });
    }
}

- (void)cutOffSocket {
    
    MLog(@"socket断开连接");
    
    self.pushCout = 0;
    self.reconnectCount = 0;
    
    [self disconnectSocket];
}



@end

