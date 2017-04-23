//
//  LZBBeautyFilter.h
//  LZBGPUImageTool
//
//  Created by zibin on 2017/4/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#if __has_include(<GPUImage/GPUImage.h>)
#import <GPUImage/GPUImage.h>
#elif __has_include("GPUImage/GPUImage.h")
#import "GPUImage/GPUImage.h"
#else
#import "GPUImage.h"
#endif

@interface LZBBeautyFilter : GPUImageFilter
/** 美颜程度 */
@property (nonatomic, assign) CGFloat beautyLevel;
/** 美白程度 */
@property (nonatomic, assign) CGFloat brightLevel;
/** 色调强度 */
@property (nonatomic, assign) CGFloat toneLevel;
@end
