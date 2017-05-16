//
//  LZBCircleProcessView.m
//  LZBGPUImageTool
//
//  Created by zibin on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.
//
//  简书主页：http://www.jianshu.com/u/268ed1ef819e
//  共享demo资料QQ群：490658347
//  git地址：https://github.com/lzbgithubcode/LZBGPUImageTool

#import "LZBCircleProcessView.h"
#define LZBCircleProcessView_ProcessWidth 5.0f
#define LZBCircleProcessView_TimeMargin 0.1
#define LZBCircleProcessView_DefaultMargin 20

#define LZBColorRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
@interface LZBCircleProcessView()
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *processLayer;
@property (nonatomic, assign) CGSize circleSize;
@property (nonatomic, copy) void(^processBlock)(NSInteger current);
@property (nonatomic, strong) UIImageView *centerView;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat timeCount;
@property (nonatomic, assign) CGFloat maxTime;
@end

@implementation LZBCircleProcessView
- (instancetype)initWithMaxTime:(CGFloat)maxTime circleSize:(CGSize)circleSize callBackCurrentProcessTime:(void(^)(NSInteger current))processBlock;
{
   if(self = [super init])
   {
       self.circleSize = circleSize;
       self.processBlock = processBlock;
       if(maxTime == 0)
           maxTime = 15.0;
       self.maxTime = maxTime;
       [self.layer insertSublayer:self.circleLayer atIndex:0];
       [self.layer addSublayer:self.processLayer];
       [self addSubview:self.centerView];
   }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.circleLayer.frame = self.layer.bounds;
    self.processLayer.frame = self.layer.bounds;
    self.centerView.center = CGPointMake(self.circleSize.width *0.5, self.circleSize.height *0.5);
    
}


#pragma mark - handel
//开始动画
-(void)startAnimation
{
    self.timeCount = 0;
       __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1.0 animations:^{
       weakSelf.transform = CGAffineTransformScale(self.transform,1.2, 1.2);
       weakSelf.centerView.bounds = CGRectMake(0, 0, weakSelf.circleSize.width-LZBCircleProcessView_DefaultMargin, weakSelf.circleSize.height-LZBCircleProcessView_DefaultMargin);
    }];
    [self startTimer];
    
}

//停止动画
-(void)stopAnimation
{
    [self stopTimer];
    self.transform = CGAffineTransformIdentity;
    self.centerView.bounds = CGRectZero;
    self.processLayer.strokeEnd =0;
}

- (void)updateProcess
{
    self.timeCount +=LZBCircleProcessView_TimeMargin;
    self.processLayer.strokeEnd += LZBCircleProcessView_TimeMargin/self.maxTime;
    
    if(self.timeCount>=self.maxTime)
    {
        [self stopAnimation];
    }
    
}
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:LZBCircleProcessView_TimeMargin target:self selector:@selector(updateProcess) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    [self.timer invalidate];
     self.timer = nil;
    self.timeCount = 0;
}

#pragma mark - lazy
- (CAShapeLayer *)circleLayer
{
  if(_circleLayer == nil)
  {
      _circleLayer = [CAShapeLayer layer];
      UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.circleSize.width *0.5, self.circleSize.height *0.5) radius:self.circleSize.width *0.5 startAngle:0 endAngle:2 * M_PI clockwise:YES];
      _circleLayer.path = path.CGPath;
      _circleLayer.lineWidth = LZBCircleProcessView_ProcessWidth;
      _circleLayer.fillColor = nil;
      _circleLayer.strokeColor = [UIColor whiteColor].CGColor;
  }
    return _circleLayer;
}

- (CAShapeLayer *)processLayer
{
  if(_processLayer == nil)
  {
      _processLayer = [CAShapeLayer layer];
      _processLayer.fillColor =nil;
      _processLayer.lineWidth = LZBCircleProcessView_ProcessWidth;
      _processLayer.strokeColor = LZBColorRGB(33,201,152).CGColor;
      _processLayer.strokeStart = 0;
      _processLayer.strokeEnd = 0;
      _processLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.circleSize.width, self.circleSize.height) cornerRadius:self.circleSize.width *0.5].CGPath;
  }
    return _processLayer;
}


-(UIImageView *)centerView
{
  if(_centerView == nil)
  {
      _centerView = [UIImageView new];
      _centerView.backgroundColor = LZBColorRGB(33,201,152);
      _centerView.layer.cornerRadius = (self.circleSize.width-LZBCircleProcessView_DefaultMargin) *0.5;
      _centerView.layer.masksToBounds = YES;
  }
    return _centerView;
}
@end
