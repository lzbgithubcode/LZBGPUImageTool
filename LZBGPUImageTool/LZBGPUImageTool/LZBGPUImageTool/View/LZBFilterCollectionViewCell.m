//
//  LZBFilterCollectionViewCell.m
//  LZBGPUImageTool
//
//  Created by zibin on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.
//  简书主页：http://www.jianshu.com/u/d21698127416
//  共享demo资料QQ群：490658347
//  git地址：https://github.com/lzbgithubcode/LZBGPUImageTool

#import "LZBFilterCollectionViewCell.h"

@implementation LZBFilterModel
@end

@interface LZBFilterCollectionViewCell()
@property (nonatomic, strong) UIImageView *filterImgView;
@property (nonatomic, strong) UILabel *filterLabel;

@end
@implementation LZBFilterCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
  if(self = [super initWithFrame:frame])
  {
     [self addSubview:self.filterImgView];
     [self addSubview:self.filterLabel];
  }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat filterImgViewW = self.contentView.bounds.size.width - 20;
    CGFloat filterImgViewH = filterImgViewW;
    CGFloat filterImgViewX = (self.contentView.bounds.size.width -filterImgViewW)*0.5;
    CGFloat filterImgViewY = 0;
    
    self.filterImgView.frame = CGRectMake(filterImgViewX, filterImgViewY, filterImgViewW, filterImgViewH);
    self.filterLabel.frame = CGRectMake(0, CGRectGetMaxY(self.filterImgView.frame), self.contentView.bounds.size.width, 20);
}

- (void)setFilterModel:(LZBFilterModel *)filterModel
{
    _filterModel = filterModel;
    self.filterLabel.text = filterModel.filterName;
    self.filterImgView.image = filterModel.filterImage;
}


#pragma mark - lazy
+ (CGFloat)getFilterCollectionViewCellHeight
{
    return 60+20;
}

- (UIImageView *)filterImgView {
    if (!_filterImgView) {
        _filterImgView = [[UIImageView alloc] init];
        _filterImgView.contentMode = UIViewContentModeScaleToFill;
        
    }
    return _filterImgView;
}

- (UILabel *)filterLabel {
    if (!_filterLabel) {
        _filterLabel = [[UILabel alloc] init];
        _filterLabel.textColor = [UIColor lightGrayColor];
        _filterLabel.font = [UIFont systemFontOfSize:12.0];
        _filterLabel.textAlignment = NSTextAlignmentCenter;
        _filterLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_filterLabel];
    }
    return _filterLabel;
}

@end
