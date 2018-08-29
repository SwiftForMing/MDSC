//
//  PurchaseNumberViewController.h
//  DuoBao
//
//  Created by clove on 4/7/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "BaseViewController.h"

@protocol PurchaseNumberViewControllerDelegate <NSObject>

- (void)purchaseNumberDidSelected:(id)data;

@end

@interface PurchaseNumberViewController : UIViewController
@property (nonatomic, weak) id delegate;
@property (nonatomic, copy) NSDictionary *data;

- (void)reloadWithData:(NSDictionary *)data;

@end
