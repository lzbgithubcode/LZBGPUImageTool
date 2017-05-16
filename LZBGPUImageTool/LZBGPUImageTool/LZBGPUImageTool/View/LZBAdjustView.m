//
//  LZBAdjustView.m
//  LZBGPUImageTool
//
//  Created by zibin on 2017/5/8.
//  Copyright © 2017年 Apple. All rights reserved.
////  简书主页：http://www.jianshu.com/u/268ed1ef819e
//  共享demo资料QQ群：490658347
//  git地址：https://github.com/lzbgithubcode/LZBGPUImageTool


#import "LZBAdjustView.h"

#define tableViewSignleCellHeight 40

static LZBAdjustView *_instanceView;
static NSString *LZBAdjustTableViewCellID = @"LZBAdjustTableViewCellID";
@interface LZBAdjustView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSArray *models;
@property (nonatomic, copy) void(^slideModelBlock)(LZBAdjustTableViewCellModel *model);

@end

@implementation LZBAdjustView
- (instancetype)initWithFrame:(CGRect)frame
{
  if(self = [super initWithFrame:frame])
  {
      [self addSubview:self.tableView];
      [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer)]];
  }
    return self;
}

+ (void)showWithModels:(NSArray<LZBAdjustTableViewCellModel *>* )models didSlideBlock:(void(^)(LZBAdjustTableViewCellModel *model))slideModel
{
    [self showInView:nil withModels:models didSlideBlock:slideModel];
}
+ (void)showInView:(UIView *)superView withModels:(NSArray<LZBAdjustTableViewCellModel *>* )models didSlideBlock:(void(^)(LZBAdjustTableViewCellModel *model))slideModel
{
    if(superView == nil)
        superView = [UIApplication sharedApplication].keyWindow;
    
    if(_instanceView == nil)
        _instanceView = [[self alloc]init];
    
    [ superView addSubview:_instanceView];
    _instanceView.models = models;
    _instanceView.slideModelBlock = slideModel;
    _instanceView.frame = [UIScreen mainScreen].bounds;
    
    //加载动画
    CGFloat tableVeiwHeight = models.count * tableViewSignleCellHeight;
    _instanceView.tableView.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height , [UIScreen mainScreen].bounds.size.width, tableVeiwHeight);
    
    [UIView animateWithDuration:0.25 animations:^{
         _instanceView.tableView.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height- tableVeiwHeight, [UIScreen mainScreen].bounds.size.width, tableVeiwHeight);
    } completion:^(BOOL finished) {
        [_instanceView layoutIfNeeded];
    }];
}

- (void)tapGestureRecognizer
{
    [[self class] dismissAdjustView];
}

+ (void)dismissAdjustView
{
    CGFloat tableVeiwHeight = _instanceView.models.count * tableViewSignleCellHeight;
    _instanceView.tableView.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height-tableVeiwHeight , [UIScreen mainScreen].bounds.size.width, tableVeiwHeight);
    [UIView animateWithDuration:0.25 animations:^{
        _instanceView.tableView.frame = CGRectMake(0,[UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, tableVeiwHeight);
    } completion:^(BOOL finished) {
           [_instanceView removeFromSuperview];
    }];
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZBAdjustTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LZBAdjustTableViewCellID];
    cell.adjustModel = self.models[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    [cell setSlideBlock:^(LZBAdjustTableViewCellModel *model) {
        [weakSelf processCellSliderValueWithModel:model];
    }];
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableViewSignleCellHeight;
}

- (void)processCellSliderValueWithModel:(LZBAdjustTableViewCellModel *)model
{
     if(self.slideModelBlock)
         self.slideModelBlock(model);
}


#pragma mark- lazy
- (UITableView *)tableView
{
  if(_tableView == nil)
  {
      _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
      _tableView.delegate = self;
      _tableView.dataSource = self;
      [_tableView registerClass:[LZBAdjustTableViewCell class] forCellReuseIdentifier:LZBAdjustTableViewCellID];
      _tableView.scrollEnabled = NO;
  }
    return _tableView;
}
@end
