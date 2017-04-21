//
//  LZBFilterCollectionViewCell.h
//  LZBGPUImageTool
//
//  Created by zibin on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

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
