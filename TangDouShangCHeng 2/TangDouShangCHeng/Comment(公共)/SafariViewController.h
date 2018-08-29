//
//  SafariViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/12.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SafariViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString *urlStr;
@property (assign, nonatomic) BOOL isRotaryGame;
@end
