//
//  GoodsFightModel.h
//  DuoBao
//
//  Created by clove on 5/11/17.
//  Copyright © 2017 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsModel.h"
#import "TypeDefine.h"

/*
 "good_imgs": "",
 "bean_price": 159,
 "good_name": "1箱8袋 | 百草味 在一起礼盒 坚果干果零食大礼包",
 "id": 522860622579,
 "order_num": 900,
 "good_header": "",
 "goods_type_id": "100194"
 
 */
@interface GoodsFightModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) GoodsModel *goodsModel;
@property (nonatomic, copy) NSString *good_period;
@property (nonatomic, copy) NSString *need_people;
@property (nonatomic, copy) NSString *now_people;
@property (nonatomic, copy) NSString *progress;
@property (nonatomic, copy) NSString *good_single_price;
@property (nonatomic, copy) NSString *is_happybean_goods;       // 商品类型
@property (nonatomic, copy) NSString *part_sanpei;
@property (nonatomic, copy) NSString *add_caipiao;

@property (nonatomic, copy) NSString *good_imgs;
@property (nonatomic, copy) NSString *bean_price;
@property (nonatomic, copy) NSString *good_name;
@property (nonatomic, copy) NSString *good_id;
@property (nonatomic, copy) NSString *order_num;
@property (nonatomic, copy) NSString *good_header;
@property (nonatomic, copy) NSString *goods_type_id;
//@property (nonatomic, copy) NSString *id;

+ (GoodsFightModel *)createWithDictionary:(NSDictionary *)dictionary;

- (int)minCount;
- (int)maxCount;
- (int)remainderCount;
- (int)cardinalNumber;  // 每人次的价值(小米／小米)
- (NSArray *)recommendedPurchaseOptions;

// 货币单位  元／小米
- (NSString *)unitCurrency;

- (GoodsType)goodsType;

// 还需要的小米／小米
- (int)remainderCoin;


@end
