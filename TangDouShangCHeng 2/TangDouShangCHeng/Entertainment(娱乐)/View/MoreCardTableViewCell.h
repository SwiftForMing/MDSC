//
//  MoreCardTableViewCell.h
//  DuoBao
//
//  Created by clove on 11/29/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) NSString *cardNumber;


- (void)reloadWithString:(NSString *)string;

@end
