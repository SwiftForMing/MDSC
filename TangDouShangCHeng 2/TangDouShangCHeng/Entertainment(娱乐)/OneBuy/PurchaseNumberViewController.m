
//
//  PurchaseNumberViewController.m
//  DuoBao
//
//  Created by clove on 4/7/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import "PurchaseNumberViewController.h"
#import "NumberInputField.h"
#import "ServerProtocol.h"

@interface PurchaseNumberViewController ()<NumberInputFieldDelegate>
{
    dispatch_once_t onceToken;
}
@property (weak, nonatomic) IBOutlet UIView *purchaseView;
@property (weak, nonatomic) IBOutlet UIView *goodsContainerView;
@property (weak, nonatomic) IBOutlet UIView *thriceContainerView1;
@property (weak, nonatomic) IBOutlet UIView *thriceContainerView2;
@property (weak, nonatomic) IBOutlet UIView *thriceContainerView3;
@property (weak, nonatomic) IBOutlet UIView *thriceContainerView4;
@property (weak, nonatomic) IBOutlet UIView *amountContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet NumberInputField *purchaseCrowdfundingField;
@property (weak, nonatomic) IBOutlet NumberInputField *purchaseThrice147Field;
@property (weak, nonatomic) IBOutlet NumberInputField *purchaseThrice258Field;
@property (weak, nonatomic) IBOutlet NumberInputField *purchaseThrice369Field;
@property (weak, nonatomic) IBOutlet NumberInputField *purchaseThrice0Field;
@property (weak, nonatomic) IBOutlet UILabel *leftCrowdfundingLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightCrowdfundingLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;


@end

@implementation PurchaseNumberViewController

- (void)dealloc
{
    // reset by default
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    MLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    __weak typeof(self) wself = self;
    [self.view whenTapped:^{
        [wself cancelPurchase];
        
        MLog(@"bg cancel");
    }];
    
    [_purchaseView whenTapped:^{

        MLog(@"_purchaseView cancel");
    }];
    
    self.purchaseView.bottom = self.view.height + self.purchaseView.height;
    
    NSDictionary *dict = _data;
    int crowdfundingCardinalNumber = [[dict objectForKey:@"good_single_price"] intValue];
    int remainderTimes = [ServerProtocol remainderCrowdfundingTimes:dict];

    NumberInputField *inputField = _purchaseCrowdfundingField;
    inputField.coinType = CoinTypeCrowdfunding;
    inputField.cardinalNumber = 5 * crowdfundingCardinalNumber;
    inputField.bettingType = BettingTypeCrowdfunding;
    inputField.exchangeRate = 1;
    inputField.delegate = self;
    inputField.min = 1;
    [inputField setDefaultValue:5 limit:remainderTimes];
    
    
    int defaultThriceValue = 10;
    int cardinalNumber = 10;

    inputField = _purchaseThrice147Field;
    inputField.coinType = CoinTypeThrice;
    inputField.cardinalNumber = cardinalNumber;
    inputField.bettingType = BettingTypeThrice147;
    inputField.exchangeRate = 100;
    inputField.delegate = self;
    [inputField setDefaultValue:1 limit:4000*100];
    
    inputField = _purchaseThrice258Field;
    inputField.bettingType = BettingTypeThrice258;
    inputField.coinType = CoinTypeThrice;
    inputField.cardinalNumber = cardinalNumber;
    inputField.exchangeRate = 100;
    inputField.delegate = self;
    [inputField setDefaultValue:0 limit:4000*100];
    
    inputField = _purchaseThrice369Field;
    inputField.coinType = CoinTypeThrice;
    inputField.cardinalNumber = cardinalNumber;
    inputField.bettingType = BettingTypeThrice369;
    inputField.exchangeRate = 100;
    inputField.delegate = self;
    [inputField setDefaultValue:0 limit:4000*100];
    
    inputField = _purchaseThrice0Field;
    inputField.bettingType = BettingTypeThrice0;
    inputField.coinType = CoinTypeThrice;
    inputField.cardinalNumber = cardinalNumber;
    inputField.exchangeRate = 100;
    inputField.delegate = self;
    [inputField setDefaultValue:0 limit:4000*100];
    
    //手势返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
 backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadWithData:_data];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self moveInAnimation];
    
    
//    static dispatch_once_t onceToken;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    dispatch_once(&onceToken, ^{
        [self UIAdapter];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadWithData:(NSDictionary *)dict
{
//    _data = dict;
    
//    int crowdfundingCardinalNumber = [[dict objectForKey:@"good_single_price"] intValue];
//    NSString *needRemainder = [dict objectForKey:@"now_people"];
    NSString *goodsImage = [dict objectForKey:@"good_header"];
    NSString *goodsTitle = [ServerProtocol periodAndGoodsName:dict];
//    int remainderTimes = [ServerProtocol remainderCrowdfundingTimes:dict];
//    NSString *needRemainderStr = [NSString stringWithFormat:@"还需%@", needRemainder];

    _goodsTitle.text = goodsTitle;
    
    __weak typeof(self) wself = self;
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsImage] placeholderImage:PublicImage(@"default") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (cacheType == SDImageCacheTypeNone && image) {
            [UIView transitionWithView:wself.goodsImageView
                              duration:0.25
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                wself.goodsImageView.image = image;
                            } completion:^(BOOL finished) {
                                
                            }];
            
            [wself.goodsImageView setNeedsLayout];
        }
    }];
    
    
    UIColor *redColor = [UIColor colorFromHexString:@"ff5e7e"];
    UIColor *whiteColor = [UIColor whiteColor];
    UIFont *font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
    
    
    int amountCrowdfundingCoin = [self amountCrowdfundingCoin];
    int amountThriceCoin = [self amountThriceCoin];
    
    
    // 总计小米
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"共计" attributes:@{NSForegroundColorAttributeName:redColor}];
    NSString *str = [NSString stringWithFormat:@" %d ", amountCrowdfundingCoin];
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:whiteColor, NSFontAttributeName:font}];
    [attr appendAttributedString:attr2];
    attr2 = [[NSMutableAttributedString alloc] initWithString:@"小米" attributes:@{NSForegroundColorAttributeName:redColor}];
    [attr appendAttributedString:attr2];
    _leftCrowdfundingLabel.attributedText = attr;
    
    
    // 总计小米
    str = [NSString stringWithFormat:@"%d ", amountThriceCoin];
    attr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:whiteColor, NSFontAttributeName:font}];
    attr2 = [[NSMutableAttributedString alloc] initWithString:@"小米" attributes:@{NSForegroundColorAttributeName:redColor}];
    [attr appendAttributedString:attr2];
    _rightCrowdfundingLabel.attributedText = attr;
}

- (void)updateUserInterface
{
    [self reloadWithData:_data];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    UIView *view = _purchaseView;
    NSDictionary *userInfo = [aNotification userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect newFrame = view.frame;
    newFrame.origin.y = self.view.height - view.height- keyboardRect.size.height;
    
    [UIView beginAnimations:@"ResizeTextView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    view.frame = newFrame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    UIView *view = _purchaseView;
    NSDictionary *userInfo = [aNotification userInfo];
    
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect newFrame = view.frame;
    newFrame.origin.y = self.view.height - view.height;
    
    [UIView beginAnimations:@"ResizeTextView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    view.frame = newFrame;
    
    [UIView commitAnimations];
}

- (void)cancelPurchase
{
    [Tool hideAllKeyboard];
    [self dismissAnimation];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self cancelPurchase];
}

- (IBAction)swipeDownGesture:(id)sender {
    [Tool hideAllKeyboard];
}

- (void)dismissAnimation
{
    [UIView animateWithDuration:0.1 animations:^{
        self.purchaseView.bottom = self.view.height + self.purchaseView.height;
    }];
}

- (void)moveInAnimation
{
    [UIView animateWithDuration:0.25 animations:^{
        self.purchaseView.bottom = self.view.height;
    }];
}

- (IBAction)purchaseButtonAction:(id)sender {
    
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(purchaseNumberDidSelected:)]) {
        
        NSDictionary *dict = [self bettingData];
        [self.delegate purchaseNumberDidSelected:dict];
    }
    
    [Tool hideAllKeyboard];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (NSDictionary *)bettingData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    int value = [self amountCrowdfundingCoin];
    if (value > 0) {
        NSNumber *number = [NSNumber numberWithInt:value];
        [dict setObject:number forKey:@"Crowdfunding"];
    }
    
    NSArray *array = [self thriceArray];
    if (array) {
        [dict setObject:array forKey:@"Thrice"];
    }
 
    return dict;
}

- (NSArray *)thriceArray
{
    NSMutableArray *array = [NSMutableArray array];
    
    NumberInputField *inputField = _purchaseThrice147Field;
    int value = [inputField value];
    if (value > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:value] forKey:@"count"];
        [dict setObject:@"1" forKey:@"type"];
        [array addObject:dict];
    }
    
    inputField = _purchaseThrice258Field;
    value = [inputField value];
    if (value > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:value] forKey:@"count"];
        [dict setObject:@"2" forKey:@"type"];
       [array addObject:dict];
    }
    
    inputField = _purchaseThrice369Field;
    value = [inputField value];
    if (value > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:value] forKey:@"count"];
        [dict setObject:@"3" forKey:@"type"];
        [array addObject:dict];
    }
    
    inputField = _purchaseThrice0Field;
    value = [inputField value];
    if (value > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:value] forKey:@"count"];
        [dict setObject:@"0" forKey:@"type"];
        [array addObject:dict];
    }

    return array;
}

- (int)amountThriceCoin
{
    NSArray *bettingArray = [self thriceArray];
    
    int count = 0;
    
    for (NSDictionary *dict in bettingArray) {
        NSNumber *number = [[dict allValues] firstObject];
        count += [number intValue];
    }
    
    return count;
}

- (int)amountCrowdfundingCoin
{
    NumberInputField *inputField = _purchaseCrowdfundingField;
    int value = [inputField value];

    return value;
}

- (void)UIAdapter
{
    if ([SDiPhoneVersion deviceSize] == iPhone4inch) {
        
        float littleHeight = 12;
        
        _goodsTitle.top -= 2;
        _purchaseCrowdfundingField.bottom += 8;
        
        _purchaseView.height = ScreenHeight - 216 - 64;
        _goodsContainerView.height -= 22;
        _thriceContainerView1.height -= littleHeight;
        _thriceContainerView2.height -= littleHeight;
        _thriceContainerView3.height -= littleHeight;
        _thriceContainerView4.height -= littleHeight;
        _amountContainerView.height -= 18;
        
        _thriceContainerView1.top = _goodsContainerView.bottom;
        _thriceContainerView2.top = _thriceContainerView1.bottom;
        _thriceContainerView3.top = _thriceContainerView2.bottom;
        _thriceContainerView4.top = _thriceContainerView3.bottom;
        _amountContainerView.top = _thriceContainerView4.bottom;
    }
}

#pragma mark - NumberInputFieldDelegate

- (void)numberInputFieldChanged:(NumberInputField *)numberInputField currentValue:(int)money
{
    [self updateUserInterface];
}

@end
