//
//  LZBPlayerViewController.m
//  LZBGPUImageTool
//
//  简书主页：http://www.jianshu.com/u/268ed1ef819e
//  共享demo资料QQ群：490658347
//  git地址：https://github.com/lzbgithubcode/LZBGPUImageTool


#import "LZBPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface LZBPlayerViewController ()
@property (nonatomic, strong) AVPlayerLayer *avplayer;
@property (nonatomic, strong) UIButton *button;
@end

@implementation LZBPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.button];
    self.button.frame = CGRectMake(20, 20, 40, 40);
    _avplayer = [AVPlayerLayer playerLayerWithPlayer:[AVPlayer playerWithURL:[NSURL fileURLWithPath:self.videoPath]]];
    _avplayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:_avplayer atIndex:0];
    [_avplayer.player play];
}
- (void)buttonClick
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
}


- (UIButton *)button
{
   if(_button == nil)
   {
       _button = [UIButton buttonWithType:UIButtonTypeCustom];
       [_button setTitle:@"返回" forState:UIControlStateNormal];
       [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
   }
    return _button;
}

@end
