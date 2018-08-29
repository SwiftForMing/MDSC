//
//  ShoppingCarCell.m
//  ShoppingCarDemo
//
//  Created by huanglianglei on 15/11/5.
//  Copyright © 2015年 huanglianglei. All rights reserved.
//

#import "ShoppingCarCell.h"
#import "UConstants.h"
#import "UIViewExt.h"
@implementation ShoppingCarCell{
    NSMutableArray *btnArr;
    
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        
        [self createSubViews];
    }
    return self;
}



-(void)createSubViews{
    
    self.checkImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, (150-30)/2.0, 20, 20)];
   
    self.checkImg.image =[UIImage imageNamed:@"check_p"];
    [self addSubview:self.checkImg];
    
    self.shopImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.checkImg.right+10,15, 100, 80)];
    
    self.shopImageView.image = [UIImage imageNamed:@"img"];
    
    [self addSubview:self.shopImageView];
    
    
    
    self.shopNameLab = [[UILabel alloc]initWithFrame:CGRectMake(self.shopImageView.right+10,self.shopImageView.top-10,kScreenWidth-self.shopImageView.right-20, 40)];
    self.shopNameLab.text = @"合生元金装3段1-3岁";
    self.shopNameLab.numberOfLines = 0;
    self.shopNameLab.font = SYSTEMFONT(14);
    [self addSubview:self.shopNameLab];
    
    self.shopTypeLab = [[UILabel alloc]initWithFrame:CGRectMake(self.shopNameLab.left,self.shopNameLab.bottom,self.shopNameLab.width-120, 20)];
    self.shopTypeLab.text = @"通用型号";
    self.shopTypeLab.textColor = [UIColor darkGrayColor];
    self.shopTypeLab.font = SYSTEMFONT(12);
    [self addSubview:self.shopTypeLab];
    _lefeNewProcess = [[LDProgressView alloc]initWithFrame:CGRectMake(self.shopTypeLab.right+5, self.shopTypeLab.top+8, 100, 5)];
    _lefeNewProcess.background = [UIColor colorFromHexString:@"CCCCCC"];
    _lefeNewProcess.color = [UIColor colorFromHexString:@"e6322c"];
    [LDProgressView appearance].showBackgroundInnerShadow = @NO;
    [LDProgressView appearance].showText = @NO;
    [LDProgressView appearance].showStroke = @NO;
    [LDProgressView appearance].showText = @NO;
    [LDProgressView appearance].flat = @NO;
    [LDProgressView appearance].showText = @NO;
    _lefeNewProcess.type = LDProgressSolid;
    _lefeNewProcess.animate = @NO;
    
    [self addSubview:_lefeNewProcess];
   

    
    self.addNumberView = [[AddNumberView alloc]initWithFrame:CGRectMake(self.shopTypeLab.left, self.shopTypeLab.bottom+5, 140, 40)];
    self.addNumberView.delegate = self;
    self.addNumberView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.addNumberView];
    
    CGFloat btnWidth = (ScreenWidth-180)/5;
    CGFloat y = self.shopImageView.bottom+20;
    btnArr = [NSMutableArray array];
    for (int i = 0; i<4; i++) {
        CGFloat x = 50+(btnWidth+20)*i;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, btnWidth, 30)];
        [btn setTitle:@"包尾" forState:0];
        [btn setTitleColor:[UIColor blackColor] forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.layer.cornerRadius = 3;
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClickWith:) forControlEvents:UIControlEventTouchUpInside];
        [btnArr addObject:btn];
        [self addSubview:btn];
    }
   
    _line = [[UILabel alloc]initWithFrame:CGRectMake(0, self.shopImageView.bottom+20+35, ScreenWidth, 1)];
    _line.backgroundColor = [UIColor grayColor];
    [self addSubview:_line];
}

-(void)btnClickWith:(UIButton *)btn{
    MLog(@"btnClickWith%ld",(long)btn.tag);
    if (btn.tag == 4) {
        _buynum = (int)(_shoplistModel.need_people-_shoplistModel.now_people);
        self.addNumberView.numberString = [NSString stringWithFormat:@"%d",_buynum];
        
        [self .delegate btnClick:self andFlag:14 andNum:_buynum];
    }else{
        _buynum = [[_shoplistModel recommendedPurchaseOptions][btn.tag] intValue];
        if(_buynum>((int)(_shoplistModel.need_people-_shoplistModel.now_people))){
            _buynum = (int)(_shoplistModel.need_people-_shoplistModel.now_people);
            self.addNumberView.numberString = [NSString stringWithFormat:@"%d",_buynum];
            [self .delegate btnClick:self andFlag:13 andNum:_buynum];
        }else{
            self.addNumberView.numberString = [NSString stringWithFormat:@"%d",_buynum];
            [self .delegate btnClick:self andFlag:13 andNum:_buynum];
        }
        
        
    }
    
}
/**
 * 点击减按钮数量的减少
 *
 * @param sender 减按钮
 */
- (void)deleteBtnAction:(UIButton *)sender addNumberView:(AddNumberView *)view{
    
//    NSLog(@"减按钮");
    //判断是否选中，选中才能操作
    if (self.selectState == YES)
    {
        if (_buynum == 0) {
            _buynum = 0;
        }else{
           _buynum = _buynum-1;
        }
         self.addNumberView.numberString = [NSString stringWithFormat:@"%d",_buynum];

         [self .delegate btnClick:self andFlag:(int)sender.tag andNum:_buynum];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"先选中商品哦！亲😊" delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
}
/**
 * 点击加按钮数量的增加
 *
 * @param sender 加按钮
 */
- (void)addBtnAction:(UIButton *)sender addNumberView:(AddNumberView *)view{
    
    NSLog(@"加按钮");
    //判断是否选中，选中才能操作
    if (self.selectState == YES)
    {
        
//        MLog(@"++++++++%d",_buynum);
        if(_buynum == (_shoplistModel.need_people - _shoplistModel.now_people)){
            _buynum = (int)(_shoplistModel.need_people - _shoplistModel.now_people);
            self.addNumberView.numberString = [NSString stringWithFormat:@"%d",_buynum];
            [self .delegate btnClick:self andFlag:(int)sender.tag andNum:_buynum];
        }else{
            _buynum = _buynum+1;
            self.addNumberView.numberString = [NSString stringWithFormat:@"%d",_buynum];
            [self .delegate btnClick:self andFlag:(int)sender.tag andNum:_buynum];
        }
        
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"先选中商品哦！亲😊" delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)changeNum:(NSString *)num addNumberView:(AddNumberView *)view{
    
    NSLog(@"改变num");
    //判断是否选中，选中才能操作
    if (self.selectState == YES)
    {
        int buy = [num intValue];
        int rema = (int)(_shoplistModel.need_people-_shoplistModel.now_people);
        if (buy > 0) {
            if (buy < rema) {
                _buynum = buy;
                self.addNumberView.numberString = [NSString stringWithFormat:@"%d",_buynum];
                [self .delegate btnClick:self andFlag:13 andNum:_buynum];
            }else{
                _buynum = (int)(_shoplistModel.need_people - _shoplistModel.now_people);
                self.addNumberView.numberString = [NSString stringWithFormat:@"%d",_buynum];
                [self .delegate btnClick:self andFlag:13 andNum:_buynum];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请正确输入哦！亲😊" delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil, nil];
            [alert show];
        }

        
    }
    else{
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"先选中商品哦！亲😊" delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}



-(void)setShoplistModel:(ShopCartInfo *)shoplistModel{
    _shoplistModel = shoplistModel;
    self.shopNameLab.text = shoplistModel.good_name;
    
    if (shoplistModel.selectState)
    {
        self.checkImg.image = [UIImage imageNamed:@"check_p"];
        self.selectState = YES;
        
    }else{
        self.selectState = NO;
        self.checkImg.image = [UIImage imageNamed:@"check_n"];
    }
    self.shopTypeLab.text  = [NSString stringWithFormat:@"%@%ld",@"剩余:",shoplistModel.need_people-shoplistModel.now_people];
    
    _lefeNewProcess.progress = [shoplistModel.progress doubleValue]/100.0;
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:shoplistModel.good_header] placeholderImage:nil];
    NSArray *strArr = [shoplistModel recommendedPurchaseOptions];
    for (int i = 0; i<strArr.count; i++) {
        [btnArr[i] setTitle:(NSString *)strArr[i] forState:0];
    }
    MLog(@"_buynum%d",[shoplistModel.goods_buy_num intValue]);
    
//    _buynum = [shoplistModel.goods_buy_num intValue] < (shoplistModel.need_people-shoplistModel.now_people) ? [shoplistModel.goods_buy_num intValue]:(int)(shoplistModel.need_people-shoplistModel.now_people);
    
    if([shoplistModel.goods_buy_num intValue] < (shoplistModel.need_people-shoplistModel.now_people)){
        _buynum = [shoplistModel.goods_buy_num intValue];
    }else{
        _buynum = (int)(shoplistModel.need_people-shoplistModel.now_people);
        shoplistModel.goods_buy_num = [NSString stringWithFormat:@"%d",_buynum];;
        
    }
    
    self.addNumberView.numberString = [NSString stringWithFormat:@"%d",_buynum];
}

- (void)setBuynum:(int)buynum{
    MLog(@"?????????");
}



@end
