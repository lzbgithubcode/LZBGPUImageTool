//
//  ViewController.m
//  LZBGPUImageTool
//
//  Created by zibin on 2017/4/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "LZBImageView.h"
#import "LZBImageFilterGroup.h"
#import "LZBImageVideoCamera.h"
#import "LZBImageMovieWriter.h"
#import "LZBCircleProcessView.h"
#import "LZBFilterCollectionViewCell.h"
#import "LZBFilterHandleTool.h"


#define LZBImageViewWidth  720
#define LZBImageViewHeight  1280
#define collectionViewHeight  80

static NSString *LZBFilterCollectionViewCellID = @"LZBFilterCollectionViewCellID";
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

//媒体属性
@property (nonatomic, strong) NSString *videoPath;
@property (nonatomic, strong) NSMutableDictionary *videoSettings;
@property (nonatomic, strong) AVPlayerLayer *avplayer;

//相机
@property (nonatomic, strong) LZBImageVideoCamera *videoCamera;
@property (nonatomic, strong) LZBImageFilterGroup *filterGroup;
@property (nonatomic, strong) LZBImageView *videoImageView;
@property (nonatomic, strong) LZBImageMovieWriter *videoWriter;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *currentFilter;

//UI
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) LZBCircleProcessView *circleView;
@property (nonatomic, strong) UICollectionView *collectionView;


//data
@property (nonatomic, strong) NSMutableArray *filterModels;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFilterData];
    [self.view insertSubview:self.videoImageView atIndex:0];
    [self.view addSubview:self.filterButton];
    [self.view addSubview:self.circleView];
    [self.view addSubview:self.collectionView];

    self.videoWriter = [[LZBImageMovieWriter alloc] initWithMovieURL:[NSURL fileURLWithPath:self.videoPath] size:CGSizeMake(LZBImageViewWidth , LZBImageViewHeight) fileType:AVFileTypeMPEG4 outputSettings:self.videoSettings];
    self.videoCamera.audioEncodingTarget = self.videoWriter;
    [self.videoCamera addAudioInputsAndOutputs];
    [self.videoCamera startCameraCapture];
    [self changeFilter:self.currentFilter];
   
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.videoImageView.frame = self.view.bounds;
    self.filterButton.frame = CGRectMake(0, self.view.bounds.size.height - 60, 60   , 30);
    self.circleView.bounds = CGRectMake(0, 0, 80, 80);
    self.circleView.center = CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height -80-30);
}




- (void)filterButtonAction:(UIButton *)filterButton
{
       filterButton.selected = !filterButton.isSelected;
    if(filterButton.selected)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.collectionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -250, [UIScreen mainScreen].bounds.size.width, collectionViewHeight);
        }];
    }
    else
    {
        self.collectionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -250, [UIScreen mainScreen].bounds.size.width, collectionViewHeight);
        [UIView animateWithDuration:0.25 animations:^{
            self.collectionView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -250, [UIScreen mainScreen].bounds.size.width, collectionViewHeight);
        }];
    }
}

- (void)circleViewLongTouch:(UILongPressGestureRecognizer *)longGesture
{
    if(longGesture.state == UIGestureRecognizerStateBegan)
    {
        [self beginRecord];
    }
    else if (longGesture.state == UIGestureRecognizerStateEnded)
    {
        [self endRecord];
    }
}

- (void)beginRecord
{
    unlink([self.videoPath UTF8String]);
    if(self.currentFilter != nil)
    [self.currentFilter addTarget:self.videoWriter];
    [self.videoWriter startRecording];
    [self.circleView startAnimation];
}

- (void)endRecord
{
    if(self.currentFilter != nil)
        [self.currentFilter removeTarget:self.videoWriter];
    
    [self.circleView stopAnimation];
    __weak typeof(self) weakSelf = self;
    // 储存到图片库,并且设置回调.
    [self.videoWriter finishRecordingWithCompletionHandler:^{
        [weakSelf createNewWritter];
        dispatch_async(dispatch_get_main_queue(), ^{
            _avplayer = [AVPlayerLayer playerLayerWithPlayer:[AVPlayer playerWithURL:[NSURL fileURLWithPath:weakSelf.videoPath]]];
            _avplayer.frame = weakSelf.view.bounds;
            [weakSelf.view.layer insertSublayer:_avplayer above:weakSelf.videoImageView.layer];
            [_avplayer.player play];
        });
    }];
}
- (void)createNewWritter {
    
    self.videoWriter = [[LZBImageMovieWriter alloc] initWithMovieURL:[NSURL fileURLWithPath:self.videoPath] size:CGSizeMake(LZBImageViewWidth , LZBImageViewHeight) fileType:AVFileTypeMPEG4 outputSettings:self.videoSettings];
    /// 如果不加上这一句，会出现第一帧闪现黑屏
    [_videoCamera addAudioInputsAndOutputs];
    _videoCamera.audioEncodingTarget = self.videoWriter;
}


#pragma mark - collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filterModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LZBFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LZBFilterCollectionViewCellID forIndexPath:indexPath];
    cell.filterModel = self.filterModels[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([LZBFilterCollectionViewCell getFilterCollectionViewCellHeight], [LZBFilterCollectionViewCell getFilterCollectionViewCellHeight]);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >=self.filterModels.count) return;
    GPUImageOutput<GPUImageInput> *filter = [[LZBFilterHandleTool sharedInstance] getFilterWithfilterType:indexPath.row];
    [self changeFilter:filter];
}


- (void)changeFilter:(GPUImageOutput<GPUImageInput>*)filter
{
    if(filter == nil)
    {
        [self.videoCamera removeAllTargets];
        [self.videoCamera addTarget:self.videoImageView];
        return;
    }
    [self.videoCamera removeAllTargets];
    [self.videoCamera addTarget:filter];
    [filter addTarget:self.videoImageView];
    self.currentFilter = filter;
}

#pragma mark- lazy
- (LZBImageVideoCamera *)videoCamera
{
  if(_videoCamera == nil)
  {
      // 创建视频源
      // SessionPreset:屏幕分辨率，AVCaptureSessionPresetHigh会自适应高分辨率
      // cameraPosition:摄像头方向
      _videoCamera = [[LZBImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionFront];
      _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
      _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
  }
    return _videoCamera;
}

- (LZBImageFilterGroup *)filterGroup
{
  if(_filterGroup == nil)
  {
      _filterGroup = [[LZBImageFilterGroup alloc]init];
  }
    return _filterGroup;
}
- (LZBImageView *)videoImageView
{
  if(_videoImageView == nil)
  {
      _videoImageView= [[LZBImageView alloc] initWithFrame:self.view.bounds];
      [_videoImageView setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
  }
    return _videoImageView;
}

- (NSMutableDictionary *)videoSettings {
    if (!_videoSettings) {
        _videoSettings = [[NSMutableDictionary alloc] init];
        [_videoSettings setObject:AVVideoCodecH264 forKey:AVVideoCodecKey];
        [_videoSettings setObject:[NSNumber numberWithInteger:LZBImageViewWidth] forKey:AVVideoWidthKey];
        [_videoSettings setObject:[NSNumber numberWithInteger:LZBImageViewHeight] forKey:AVVideoHeightKey];
    }
    return _videoSettings;
}

- (UIButton *)filterButton
{
  if(_filterButton == nil)
  {
      _filterButton =[UIButton buttonWithType:UIButtonTypeCustom];
      [_filterButton addTarget:self action:@selector(filterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
      _filterButton.backgroundColor = [UIColor grayColor];
      [_filterButton setTitle:@"滤镜" forState:UIControlStateNormal];
      [_filterButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
  }
    return _filterButton;
}

- (NSString *)videoPath
{
  if(_videoPath == nil)
  {
      _videoPath =  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Movie.mp4"];
  }
    return _videoPath;
}
- (LZBCircleProcessView *)circleView
{
  if(_circleView == nil)
  {
     _circleView = [[LZBCircleProcessView alloc]initWithMaxTime:15 circleSize:CGSizeMake(80, 80) callBackCurrentProcessTime:^(NSInteger current) {
         
     }];
      [_circleView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(circleViewLongTouch:)]];
  }
    return _circleView;
}

- (UICollectionView *)collectionView
{
   if(_collectionView == nil)
   {
       UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
       [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
       flowLayout.minimumInteritemSpacing = 5;
       flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 0, 0);
       CGRect frame = CGRectMake([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height -250 , [UIScreen mainScreen].bounds.size.width, collectionViewHeight);
       _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
       _collectionView.backgroundColor = [UIColor whiteColor];
       _collectionView.delegate = self;
       _collectionView.dataSource = self;
       _collectionView.showsHorizontalScrollIndicator = NO;
       [_collectionView registerClass:[LZBFilterCollectionViewCell class] forCellWithReuseIdentifier:LZBFilterCollectionViewCellID];
   }
    return _collectionView;
}

- (void)initFilterData
{
    __weak typeof(self) weakSelf = self;
    UIImage *orginImage = [UIImage imageNamed:@"kxq_explore_image"];
    for (NSInteger i = 0;i < 7; i++) {
        LZBFilterModel *model = [[LZBFilterModel alloc]init];
        LZBFilterType type = [[LZBFilterHandleTool sharedInstance] getFilterTypeForIndex:i];
        model.filterName = [[LZBFilterHandleTool sharedInstance] getFilterNameWithFilterType:type];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *filterImage = [[LZBFilterHandleTool sharedInstance] getFilterImageForOrginImage:orginImage filterType:type];
            dispatch_async(dispatch_get_main_queue(), ^{
                model.filterImage = filterImage;
                [weakSelf.filterModels addObject:model];
                [weakSelf.collectionView reloadData];
            });
        });
    }
}

- (NSMutableArray *)filterModels
{
  if(_filterModels == nil)
  {
      _filterModels = [NSMutableArray array];
  }
    return _filterModels;
}

@end
