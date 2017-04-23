//
//  LZBFilterHandleTool.m
//  LZBGPUImageTool
//
//  Created by zibin on 2017/4/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "LZBFilterHandleTool.h"

static LZBFilterHandleTool *_sharedInstance = nil;
@implementation LZBFilterHandleTool
+ (LZBFilterHandleTool *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[LZBFilterHandleTool alloc] init];
    });
    return _sharedInstance;
}

- (LZBFilterType)getFilterTypeForIndex:(NSInteger)index
{
    LZBFilterType filterType = LZBFilterType_None;
    switch (index) {
        case 0:
            filterType = LZBFilterType_None;
            break;
        case 1:
            filterType = LZBFilterType_Beauty;
            break;
        case 2:
            filterType = LZBFilterType_HEIBAI;
            break;
        case 3:
            filterType = LZBFilterType_FUGU;
            break;
        case 4:
            filterType = LZBFilterType_DANYA;
            break;
        case 5:
            filterType = LZBFilterType_QINGNING;
            break;
        case 6:
            filterType = LZBFilterType_GETE;
            break;
            
            
        default:
            break;
    }
    return filterType;
}

- (NSString *)getFilterNameWithFilterType:(LZBFilterType)type
{
      NSString *filterName = @"";
    switch (type) {
        case LZBFilterType_None:
            filterName = @"原图";
            break;
        case LZBFilterType_Beauty:
            filterName = @"美白";
            break;
        case LZBFilterType_HEIBAI:
             filterName = @"黑白";
            break;
        case LZBFilterType_FUGU:
            filterName = @"鲜亮";
            break;
        case LZBFilterType_DANYA:
           filterName = @"胶片";
            break;
        case LZBFilterType_QINGNING:
            filterName = @"少女";
            break;
        case LZBFilterType_GETE:
            filterName = @"暖暖";
            break;
            
        default:
            break;
    }
    return filterName;
}

- (GPUImageOutput<GPUImageInput> *)getFilterWithfilterType:(LZBFilterType)filterType
{
    GPUImageOutput<GPUImageInput> *filter = nil;
    switch (filterType) {
        case LZBFilterType_None:
            break;
        case LZBFilterType_Beauty:
            filter = [[LZBBeautyFilter alloc]init];
            break;
        case LZBFilterType_HEIBAI:
            filter = [[IFBrannanFilter alloc] init];
            break;
        case LZBFilterType_FUGU:
            filter = [[IF1977Filter alloc] init];
            break;
        case LZBFilterType_DANYA:
            filter = [[IFAmaroFilter alloc] init];
            break;
        case LZBFilterType_QINGNING:
            filter = [[IFLordKelvinFilter alloc] init];
            break;
        case LZBFilterType_GETE:
            filter = [[IFInkwellFilter alloc] init];
            break;
      
        default:
            break;
    }
    return filter;
}

- (UIImage *)getFilterImageForOrginImage:(UIImage *)orginImage filterType:(LZBFilterType)filterType
{
    if(filterType == LZBFilterType_None) return orginImage;
    GPUImageOutput *filter =  [self getFilterWithfilterType:filterType];
    return [filter imageByFilteringImage:orginImage];
}
@end
