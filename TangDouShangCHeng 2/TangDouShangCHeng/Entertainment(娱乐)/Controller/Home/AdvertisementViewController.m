
//  AdvertisementViewController.m
//  DuoBao
//
//  Created by 黎应明 on 2017/6/30.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "AdvertisementViewController.h"
//#import "RotaryGameRecordViewController.h"
@interface AdvertisementViewController ()<UIWebViewDelegate>{
    UIActivityIndicatorView* activityIndicator;
    UITextView* textView;
    UIImageView* imageView;
    UIScrollView *scrollView;
    UIWebView *webView;
   
}

@end

@implementation AdvertisementViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self leftNavigationItem];
    self.title = _myTitle;
//    if (_isRotaryGame) {
//        [self rightItemView];
//    }
    [self createUI];
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
}

-(void)createUI
{
    
    if ([_content_txt length]>0) {
            NSLog(@"_content_txt %@",_content_txt);
           [self createtextUI];
        return;
        }
    if ([_image_url  length]>0) {
            NSLog(@"_image_url %@",_image_url);
            [self createimageUI];
        return;
        }
    if ([_h5UrlStr length]>0) {
        NSLog(@"h5 %@",_h5UrlStr);
        [self createh5UI];
        return;
    }

}
-(void)createh5UI
{
    _h5UrlStr = [_h5UrlStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_h5UrlStr]];
    NSLog(@"url == %@",request);
    webView.delegate = self;
    [webView loadRequest:request];
    
    webView.scrollView.bounces = NO;
    [self.view addSubview:webView];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(FullScreen.size.width/2-40, FullScreen.size.height/2-60, 80, 80)];
    activityIndicator.backgroundColor = [UIColor clearColor];
    activityIndicator.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    activityIndicator.layer.masksToBounds =YES;
    activityIndicator.layer.cornerRadius = 10;
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
}
-(void)createtextUI
{
    textView = [[UITextView alloc]initWithFrame:(CGRectMake(10, 20, self.view.frame.size.width-20, self.view.frame.size.height))];
    //textView.backgroundColor = [UIColor blueColor];
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    textView.scrollEnabled = NO;
    textView.allowsEditingTextAttributes = YES;
    textView.userInteractionEnabled = NO;
    textView.textColor = [UIColor blackColor];
    
    NSArray *arr = [_content_txt componentsSeparatedByString:@"##"];
    NSString *arrStr = @"";
    NSString *lastStr = @"";

    for (int i = 0;i<arr.count;i++){
        NSLog(@"arr %@",arr[i]);
        if (i<arr.count-2) {
        arrStr = [arrStr stringByAppendingFormat:@"%@%@",arr[i], @"\n"];
        }else{
        lastStr = [lastStr stringByAppendingFormat:@"%@%@",arr[i], @"\n"];
        }
    }
    
    //动态计算时间之前的高
    CGRect rect = [arrStr boundingRectWithSize:
     CGSizeMake(self.view.frame.size.width-20, CGFLOAT_MAX)
                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                          attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18],NSFontAttributeName, nil] context:nil];
    //计算label的高
    CGRect lastRect = [lastStr boundingRectWithSize:
                   CGSizeMake(self.view.frame.size.width-20, CGFLOAT_MAX)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:18],NSFontAttributeName,nil] context:nil];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:(CGRectMake(0, rect.size.height+30, textView.frame.size.width, lastRect.size.height))];
    textLabel.numberOfLines = 0;
    //textLabel.backgroundColor = [UIColor yellowColor];
    [textView addSubview:textLabel];
    
    //textview 的富文本
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:arrStr];
    [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, text.length)];
    
     NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
     style.lineSpacing = 6;//行距
     style.firstLineHeadIndent = [UIFont systemFontOfSize:17].pointSize*2;
    style.alignment = NSTextAlignmentJustified;
     [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, arrStr.length)];
    
    //label的富文本
    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:lastStr];
    [text1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, text1.length)];
    
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    style1.lineSpacing = 6;//行距
    style1.firstLineHeadIndent = [UIFont systemFontOfSize:17].pointSize*2;
    style1.alignment = NSTextAlignmentRight;
    [text1 addAttribute:NSParagraphStyleAttributeName value:style1 range:NSMakeRange(0, lastStr.length)];
    
    textLabel.attributedText = text1;
    
    textView.attributedText = text;
    
    [self.view addSubview:textView];
}

-(void)createimageUI
{
    
    imageView = [[UIImageView alloc]init];
  
    [imageView sd_setImageWithURL:[NSURL URLWithString:_image_url] placeholderImage:PublicImage(@"good")];

    __block CGFloat itemW = self.view.frame.size.width;
    __block CGFloat itemH = 0;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    BOOL existBool = [manager diskImageExistsForURL:[NSURL URLWithString:_image_url]];//判断是否有缓存
    UIImage * image;
    if (existBool) {
        image = [[manager imageCache] imageFromDiskCacheForKey:[NSURL URLWithString:_image_url].absoluteString];
    }else{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_image_url]];
        image = [UIImage imageWithData:data];
    }
    //根据image的比例来设置高度
    if (image.size.width) {
        itemH = image.size.height / image.size.width * itemW;
        
    }
    imageView.frame = CGRectMake(0, 0, itemW, itemH);
    scrollView.userInteractionEnabled = YES;
    imageView.userInteractionEnabled = YES;
    imageView.frame = CGRectMake(0, 0, itemW, itemH);
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, itemW, itemH)];
    scrollView.contentSize = CGSizeMake(itemW, itemH);
    [scrollView addSubview:imageView];
    self.view = scrollView;
}
- (void)leftNavigationItem
{
    UIControl *leftItemControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [leftItemControl addTarget:self action:@selector(clickLeftItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 10, 18)];
    back.image = [UIImage imageNamed:@"new_back"];
    [leftItemControl addSubview:back];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemControl];
}

- (void)rightItemView
{
    UIView *rightItemView;
    rightItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,70, 44)];
    rightItemView.backgroundColor = [UIColor clearColor];
    UIButton *btnMoreItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, rightItemView.frame.size.height)];
    [btnMoreItem setTitle:@"大奖历史" forState:UIControlStateNormal];
    btnMoreItem.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnMoreItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMoreItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btnMoreItem setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0,8)];
    [btnMoreItem addTarget:self action:@selector(clickRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightItemView addSubview:btnMoreItem];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemView];
    
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButtonItem];
    
}
- (void)clickLeftItemAction:(id)sender
{
    if (webView.canGoBack) {
        [webView goBack];//返回前一画面
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)clickRightItemAction:(id)sender
{
//    RotaryGameRecordViewController *vc = [[RotaryGameRecordViewController alloc]initWithNibName:@"RotaryGameRecordViewController" bundle:nil];
//     
//    [self.navigationController pushViewController:vc animated:YES transition:magicMove];
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    [activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    [Tool showPromptContent:@"加载失败" onView:self.view];
    
}

@end
