//
//  LZBBeautyFilter.h
//  LZBGPUImageTool
//
//  Created by zibin on 2017/4/21.
//  Copyright © 2017年 Apple. All rights reserved.
////  简书主页：http://www.jianshu.com/u/268ed1ef819e
//  共享demo资料QQ群：490658347
//  git地址：https://github.com/lzbgithubcode/LZBGPUImageTool


#if __has_include(<GPUImage/GPUImage.h>)
#import <GPUImage/GPUImage.h>
#elif __has_include("GPUImage/GPUImage.h")
#import "GPUImage/GPUImage.h"
#else
#import "GPUImage.h"
#endif

@class GPUImageCombinationFilter;

@interface LZBBeautyFilter : GPUImageFilterGroup
{
    GPUImageBilateralFilter *bilateralFilter;    //双边模糊,磨皮
    GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;  //边缘检测
    GPUImageCombinationFilter *combinationFilter;
    GPUImageHSBFilter *hsbFilter;
}
@end
