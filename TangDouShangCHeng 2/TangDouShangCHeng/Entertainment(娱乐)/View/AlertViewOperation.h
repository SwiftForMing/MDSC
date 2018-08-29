//
//  AlertViewOperation.h
//  DuoBao
//
//  Created by clove on 4/21/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncOperation.h"

@interface AlertViewOperation : SyncOperation
@property (nonatomic, copy) NSDictionary *data;
@property (nonatomic) BettingType bettingType;

- (instancetype)initWithWinningThriceData:(NSDictionary *)data;
- (instancetype)initWithWinningCrowdfundingData:(NSDictionary *)data;


@end
