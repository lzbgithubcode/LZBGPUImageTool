//
//  LZBFilterHandleTool.h
//  LZBGPUImageTool
//
//  Created by zibin on 2017/4/21.
//  Copyright © 2017年 Apple. All rights reserved.
////  简书主页：http://www.jianshu.com/u/268ed1ef819e
//  共享demo资料QQ群：490658347
//  git地址：https://github.com/lzbgithubcode/LZBGPUImageTool


#import <AVFoundation/AVFoundation.h>
#import <GPUImage.h>
#import "LZBBeautyFilter.h"
#import "InstaFilters.h"
typedef NS_ENUM(NSInteger,LZBFilterType)
{
    LZBFilterType_None = 0,
    LZBFilterType_Beauty = 1, //美白
    LZBFilterType_HEIBAI = 2, //黑白
    LZBFilterType_FUGU = 3, //鲜亮
    LZBFilterType_DANYA = 4, //胶片
    LZBFilterType_QINGNING = 5, //少女
    LZBFilterType_GETE = 6, //暖暖
    
    
};

@interface LZBFilterHandleTool : NSObject
+ (LZBFilterHandleTool *)sharedInstance;


/**
 通过index返回LZBFilterType滤镜类型

 @param index index
 @return 滤镜类型
 */
- (LZBFilterType)getFilterTypeForIndex:(NSInteger)index;


/**
 根据类型返回滤镜名字

 @param type 滤镜类型
 @return 滤镜名字
 */
- (NSString *)getFilterNameWithFilterType:(LZBFilterType)type;


/**
 根据滤镜类型，返回的滤镜效果

 @param orginImage 原图
 @param filterType 滤镜类型
 @return ，返回的滤镜效果
 */
- (UIImage *)getFilterImageForOrginImage:(UIImage *)orginImage filterType:(LZBFilterType)filterType;


/**
  根据类型获得滤镜方式

 @param filterType 滤镜类型
 @return 滤镜效果
 */
- (GPUImageOutput<GPUImageInput> *)getFilterWithfilterType:(LZBFilterType)filterType;
@end
