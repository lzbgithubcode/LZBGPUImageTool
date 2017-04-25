//
//  LZBCircleProcessView.h
//  LZBGPUImageTool
//
//  Created by zibin on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.

//  简书主页：http://www.jianshu.com/u/d21698127416
//  共享demo资料QQ群：490658347
//  git地址：https://github.com/lzbgithubcode/LZBGPUImageTool


#import <UIKit/UIKit.h>

@interface LZBCircleProcessView : UIView

/**
  初始化进度条，设置进度完成时间maxTime，返回当前时间

 @param maxTime 设置进度完成时间
 @param circleSize 圆心框的尺寸
 @param processBlock ，返回当前时间
 @return LZBCircleProcessView
 */
- (instancetype)initWithMaxTime:(CGFloat)maxTime circleSize:(CGSize)circleSize callBackCurrentProcessTime:(void(^)(NSInteger current))processBlock;

//开始动画
-(void)startAnimation;

//停止动画
-(void)stopAnimation;

@end
