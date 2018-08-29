//
//  PaySelectedCell.h
//  DuoBao
//
//  Created by clove on 3/10/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PaySelectedData;

@interface PaySelectedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

- (void)relaodWithData:(PaySelectedData *)data;

@end
