//
//  LZBAdjustView.h
//  LZBGPUImageTool
//
//  Created by zibin on 2017/5/8.
//  Copyright © 2017年 Apple. All rights reserved.
////  简书主页：http://www.jianshu.com/u/268ed1ef819e
//  共享demo资料QQ群：490658347
//  git地址：https://github.com/lzbgithubcode/LZBGPUImageTool


#import <UIKit/UIKit.h>
#import "LZBAdjustTableViewCell.h"
@interface LZBAdjustView : UIView
+ (void)showInView:(UIView *)superView withModels:(NSArray<LZBAdjustTableViewCellModel *>* )models didSlideBlock:(void(^)(LZBAdjustTableViewCellModel *model))slideModel;
+ (void)showWithModels:(NSArray<LZBAdjustTableViewCellModel *>* )models didSlideBlock:(void(^)(LZBAdjustTableViewCellModel *model))slideModel;
+ (void)dismissAdjustView;
@end
