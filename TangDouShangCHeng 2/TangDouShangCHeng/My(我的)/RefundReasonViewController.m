//
//  RefundReasonViewController.m
//  YiDaMerchant
//
//  Created by linqsh on 15/11/12.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import "RefundReasonViewController.h"
#import "ProvinceInfo.h"

@interface RefundReasonViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    ProvinceInfo *typeInfo;
}

@end

@implementation RefundReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVariable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initVariable{
    typeInfo = [_contentArray objectAtIndex:0];
}


-(IBAction)clickControlAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)clickCancelButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)clickSureButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        
        if([self.delegate respondsToSelector:@selector(selectOverWithId:typeName:)])
        {
            [self.delegate selectOverWithId:typeInfo.id typeName:typeInfo.addr];
        }
        
    }];
    
    
}


#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 38;
}

/* return cor of pickerview*/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
/*return row number*/
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _contentArray.count;
}

/*return component row str*/
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    ProvinceInfo *info = [_contentArray objectAtIndex:row];
    return info.addr;
}

/*choose com is component,row's function*/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
     NSLog(@"font %ld is selected.",(long)row);
    typeInfo = [_contentArray objectAtIndex:row];
    
    
}

@end
