//
//  AgreementCheckbox.h
//  DuoBao
//
//  Created by clove on 4/9/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgreementCheckbox : UIView

@property (nonatomic, readonly) BOOL isSelected;
@property (nonatomic, strong) UIButton *checkboxButton;

- (instancetype)initWithController:(UIViewController *)viewController;

@end
