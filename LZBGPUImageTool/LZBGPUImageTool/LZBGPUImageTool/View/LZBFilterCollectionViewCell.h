//
//  LZBFilterCollectionViewCell.h
//  LZBGPUImageTool
//
//  Created by zibin on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.

//  简书主页：http://www.jianshu.com/u/d21698127416
//  共享demo资料QQ群：490658347
//  git地址：https://github.com/lzbgithubcode/LZBGPUImageTool


#import <UIKit/UIKit.h>
#import <GPUImage.h>

@interface LZBFilterModel : NSObject
@property (nonatomic, strong)   NSString *filterName;
@property (nonatomic, strong)   UIImage *filterImage;
@property (nonatomic, strong)   GPUImageOutput<GPUImageInput> *currentFilter;
@end

@interface LZBFilterCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) LZBFilterModel *filterModel;


+ (CGFloat)getFilterCollectionViewCellHeight;
@end
