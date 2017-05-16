//
//  LZBAdjustTableViewCell.h
//  LZBGPUImageTool
//
//  Created by zibin on 2017/5/5.
//  Copyright © 2017年 Apple. All rights reserved.
////  简书主页：http://www.jianshu.com/u/268ed1ef819e
//  共享demo资料QQ群：490658347
//  git地址：https://github.com/lzbgithubcode/LZBGPUImageTool


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LZBAdjustType)
{
    LZBAdjustType_None,  //无类型
    LZBAdjustType_Brightness,  //亮度
    LZBAdjustType_Exposures,  //曝光
    LZBAdjustType_Contrast,  //对比度
    LZBAdjustType_Saturation,  //饱和度
    LZBAdjustType_Gamma,  //灰度
};

@interface LZBAdjustTableViewCellModel : NSObject
@property (nonatomic, assign) LZBAdjustType adjustType;
@property (nonatomic, strong)  NSString *title;
@property (nonatomic, assign)  CGFloat value;
@property (nonatomic, assign)  CGFloat minValue;
@property (nonatomic, assign)  CGFloat maxValue;
@end

@interface LZBAdjustTableViewCell : UITableViewCell

@property (nonatomic, strong) LZBAdjustTableViewCellModel *adjustModel;

@property (nonatomic, copy) void(^slideBlock)(LZBAdjustTableViewCellModel *model);
- (void)setSlideBlock:(void (^)(LZBAdjustTableViewCellModel *model))slideBlock;

+ (CGFloat)getAdjustTableViewCellHeight;
@end
