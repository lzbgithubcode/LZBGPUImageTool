//
//  LZBAdjustTableViewCell.m
//  LZBGPUImageTool
//
//  Created by zibin on 2017/5/5.
//  Copyright © 2017年 Apple. All rights reserved.
////  简书主页：http://www.jianshu.com/u/268ed1ef819e
//  共享demo资料QQ群：490658347
//  git地址：https://github.com/lzbgithubcode/LZBGPUImageTool

#import "LZBAdjustTableViewCell.h"

@implementation LZBAdjustTableViewCellModel

@end

@interface LZBAdjustTableViewCell()
@property (nonatomic, strong)  UILabel *titleLab;
@property (nonatomic, strong)  UISlider *slider;
@end

@implementation LZBAdjustTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
  {
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      [self.contentView addSubview:self.titleLab];
      [self.contentView addSubview:self.slider];
  }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
     CGFloat margin = 10;
    self.titleLab.frame = CGRectMake(margin, 0, 60, height);
    self.slider.frame = CGRectMake(CGRectGetMaxX(self.titleLab.frame)+margin, 0, width-(CGRectGetMaxX(self.titleLab.frame)+ 2*margin), height);
}

- (void)setAdjustModel:(LZBAdjustTableViewCellModel *)adjustModel
{
    _adjustModel = adjustModel;
    self.titleLab.text = adjustModel.title;
    self.slider.minimumValue = adjustModel.minValue;
    self.slider.maximumValue = adjustModel.maxValue;
    self.slider.value = adjustModel.value;
}

+ (CGFloat)getAdjustTableViewCellHeight
{
    return 40;
}

- (void)sliderValueChanged:(UISlider *)slider
{
    self.adjustModel.value = slider.value;
    if(self.slideBlock)
        self.slideBlock(self.adjustModel);
}


#pragma mark- lazy
- (UILabel *)titleLab
{
  if(_titleLab == nil)
  {
      _titleLab = [UILabel new];
      _titleLab.font = [UIFont systemFontOfSize:14.0];
      _titleLab.textColor = [UIColor blackColor];
  }
    return _titleLab;
}
- (UISlider *)slider
{
  if(_slider == nil)
  {
      _slider = [[UISlider alloc]init];
      _slider.continuous = YES;
      [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
  }
    return _slider;
}
@end
