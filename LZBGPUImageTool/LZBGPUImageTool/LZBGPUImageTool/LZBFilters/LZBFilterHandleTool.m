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
