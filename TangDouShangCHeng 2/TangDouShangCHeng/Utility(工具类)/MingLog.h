//
//  MingLog.h
//  TaoPiao
//
//  Created by 黎应明 on 2017/9/1.
//  Copyright © 2017年 黎应明. All rights reserved.
//

#ifndef MingLog_h
#define MingLog_h



#pragma mark - Developer

#if DEBUG
#define JustinTest 1

#else

#define MingTest 0
#endif

#if JustinTest
#define MLog(...) NSLog(__VA_ARGS__)
#define MingPrintSendMessage 1
#else
#define MLog(...) {}

#define MingPrintSendMessage 0
#endif


#endif /* MingLog_h */
