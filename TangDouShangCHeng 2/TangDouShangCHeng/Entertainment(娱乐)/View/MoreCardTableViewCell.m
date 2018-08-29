
//
//  MoreCardTableViewCell.m
//  DuoBao
//
//  Created by clove on 11/29/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "MoreCardTableViewCell.h"

@implementation MoreCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonAction:(id)sender {
    
    NSString *str = self.textLabel.text;
    str = [str substringFromIndex:3];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = str;
    [Tool showPromptContent:@"复制成功"];
}

- (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

- (void)reloadWithString:(NSString *)string
{
    self.textLabel.text = string;
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.backgroundColor = [UIColor clearColor];
//    _label.text = string;
}

@end
