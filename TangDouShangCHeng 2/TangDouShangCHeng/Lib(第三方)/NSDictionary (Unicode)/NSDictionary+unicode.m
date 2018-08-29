//
//  NSDictionary+unicode.m
//  DuoBao
//
//  Created by clove on 11/11/16.
//  Copyright © 2016 linqsh. All rights reserved.
//

#import "NSDictionary+unicode.h"

@implementation NSDictionary (unicode)

- (NSString*)my_description {
    NSString *desc = [self description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}

@end
