//
//  MusicPlayViewController.m
//  CloudMusicFake
//
//  Created by OurEDA on 2018/5/7.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import "MusicPlayViewController.h"

@interface MusicPlayViewController ()
//@property(nonatomic, strong) UILabel *title;
//@property(nonatomic, strong) UIButton *name;
@property(weak, nonatomic) IBOutlet UILabel *NowTime;
@property(weak, nonatomic) IBOutlet UILabel *TotalTime;
@property(weak, nonatomic) IBOutlet UIButton *Like;
@property(weak, nonatomic) IBOutlet UIButton *Download;
@property(weak, nonatomic) IBOutlet UIButton *Comment;
@property(weak, nonatomic) IBOutlet UIButton *MoreInfo;
@property(weak, nonatomic) IBOutlet UIButton *PlayMode;
@property(weak, nonatomic) IBOutlet UIButton *UpMusic;
@property(weak, nonatomic) IBOutlet UIButton *PlayOrStop;
@property(weak, nonatomic) IBOutlet UIButton *NextMusic;
@property(weak, nonatomic) IBOutlet UIButton *PlayList;
@property(weak, nonatomic) IBOutlet UIImageView *AlbumBackImage;
@property(weak, nonatomic) IBOutlet UIImageView *AlbumImage;

@property(nonatomic, strong) NSDictionary *songDic;
@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) AVPlayerItem *songItem;
@property(nonatomic, strong) NSMutableArray *musicInfoArray;
@property(nonatomic, strong) NSURL *musicUrl;
@property(nonatomic, assign) NSMutableDictionary *songInfo;
@property(nonatomic, assign) NSTimer *_timer;
@property(nonatomic, assign) id _playTimeObserver;
@property(weak, nonatomic) IBOutlet UISlider *ProgressBar;

// 播放状态
@property(nonatomic, assign) BOOL isPlaying;
@property(nonatomic, assign) BOOL isSliding; // 是否正在滑动

// 是否横屏
@property(nonatomic, assign) BOOL isLandscape;

// 是否锁屏
@property(nonatomic, assign) BOOL isLock;

// 传入视频地址
- (void)updatePlayerWithURL:(NSURL *)url;

// 移除通知
- (void)removeObserveAndNOtification;

// 播放
- (void)play;

// 暂停
- (void)pause;
@end

@implementation MusicPlayViewController
- (IBAction)Like:(id)sender {
}

- (IBAction)Download:(id)sender {
}

- (IBAction)Comment:(id)sender {
}

- (IBAction)MoreInfo:(id)sender {
}

- (IBAction)PlayMode:(id)sender {
}

- (IBAction)UpMusic:(id)sender {
    [self removeObserveAndNOtification];
    extern NSMutableArray *playingList;
    extern NSInteger playingIndex;
    self.songInfo = [playingList objectAtIndex:(playingIndex-1)%playingList.count];
    [self setMusicPicByInfo];
    [self playMusicById:[self.songInfo valueForKey:@"song_id"]];
    [self addObserverAndNotification]; // 添加观察者，发布通知
}

- (IBAction)PlayOrStop:(id)sender {
    if (_isPlaying) {
        [self pause];
    } else {
        [self play];
    }
}

- (IBAction)NextMusic:(id)sender {
    [self removeObserveAndNOtification];
    extern NSMutableArray *playingList;
    extern NSInteger playingIndex;
    self.songInfo = [playingList objectAtIndex:(playingIndex+1)%playingList.count];
    [self setMusicPicByInfo];
    [self playMusicById:[self.songInfo valueForKey:@"song_id"]];
    [self addObserverAndNotification]; // 添加观察者，发布通知
}
-(void)setMusicPicByInfo{
    NSURL *albumPicUrl = [NSURL URLWithString:[self.songInfo valueForKey:@"album_500_500"]];
    NSData *albumPicData = [NSData dataWithContentsOfURL:albumPicUrl];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgView.image = [[UIImage alloc] initWithData:albumPicData];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, bgImgView.frame.size.width, bgImgView.frame.size.height);
    [bgImgView addSubview:effectView];
    bgImgView.tag=111;
    UIView *subviews=[self.view viewWithTag:111];
    [subviews removeFromSuperview];
    [self.view insertSubview:bgImgView atIndex:0];
    self.AlbumBackImage.image = [UIImage imageNamed:@"cm2_play_disc"];
    self.AlbumImage.image = [[UIImage alloc] initWithData:albumPicData];
}

- (IBAction)PlayList:(id)sender {
}

- (IBAction)playerSliderTouchDown:(id)sender {
    [self pause];
    self.isSliding = YES;
}

- (IBAction)playerSliderTouchUpInside:(id)sender {
    self.isSliding = NO; // 滑动结束
    NSLog(@"player slider touch up inside");
    NSLog(@"not sliding");
    [self play];
//    [self monitoringPlayback:self.songItem]; // 监听播放
}

- (IBAction)playerSliderValueChanged:(id)sender {
//    self.isSliding = YES;
    NSLog(@"isSliding continue on");
    CMTime changedTime = CMTimeMakeWithSeconds(self.ProgressBar.value, 1.0);
    NSLog(@"%.2f", self.ProgressBar.value);
    [self.songItem seekToTime:changedTime completionHandler:^(BOOL finished) {
    }];
}

- (void)dealloc {
    [self removeObserveAndNOtification];
    [self.player removeTimeObserver:self._playTimeObserver]; // 移除playTimeObserver
}

- (void)removeObserveAndNOtification {
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.songItem removeObserver:self forKeyPath:@"status"];
    [self.songItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.player removeTimeObserver:self._playTimeObserver];
    self._playTimeObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addObserverAndNotification {
    [self.songItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil]; // 观察status属性， 一共有三种属性
    [self.songItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil]; // 观察缓冲进度
    [self monitoringPlayback:self.songItem]; // 监听播放
    [self addNotification]; // 添加通知
}

// 观察播放进度
- (void)monitoringPlayback:(AVPlayerItem *)item {
    __weak typeof(self) WeakSelf = self;

    // 播放进度, 每秒执行30次， CMTime 为30分之一秒
    self._playTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        // 当前播放秒
        float currentPlayTime = (double) item.currentTime.value / item.currentTime.timescale;
        // 更新slider, 如果正在滑动则不更新

        if (self.isSliding == NO) {
            NSLog(@"not sliding");
            [WeakSelf updateVideoSlider:currentPlayTime];
        } else {
            NSLog(@"is sliding");
        }
    }];
}

// 更新滑动条
- (void)updateVideoSlider:(float)currentTime {
    self.ProgressBar.value = currentTime;
    NSDate *dateS = [NSDate dateWithTimeIntervalSince1970:currentTime];
    NSDateFormatter *formatterS = [[NSDateFormatter alloc] init];
    [formatterS setDateFormat:@"mm:ss"];
    self.NowTime.text =[formatterS stringFromDate:dateS];
//    self.NowTime.text = [[NSString alloc] initWithFormat:@"%.2f", currentTime];
}

- (void)addNotification {
    // 播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)playbackFinished:(NSNotification *)notification {
    NSLog(@"播放完成通知");
    self.songItem = [notification object];
    // 是否无限循环
//    [self.songItem seekToTime:kCMTimeZero]; // 跳转到初始
//    [self.player play]; // 是否无限循环
}

// 设置最大时间
- (void)setMaxDuration:(CGFloat)duration {
    self.ProgressBar.maximumValue = duration; // maxValue = CMGetSecond(item.duration)
    NSDate *dateS = [NSDate dateWithTimeIntervalSince1970:duration];
    NSDateFormatter *formatterS = [[NSDateFormatter alloc] init];
    [formatterS setDateFormat:@"mm:ss"];
    self.TotalTime.text =[formatterS stringFromDate:dateS];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Add glass effect background picture.
    extern NSMutableArray *playingList;
    extern NSInteger playingIndex;
    self.songInfo = [playingList objectAtIndex:playingIndex];
    NSLog(@"now songInfo is %@", self.songInfo);
    [self setMusicPicByInfo];
    [self playMusicById:[self.songInfo valueForKey:@"song_id"]];

}

- (void)playMusicById:(NSString *)musicId {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = @"http://music.baidu.com/data/music/links";
    self.ProgressBar.value = 0.0;
    [manager GET:url parameters:@{@"songIds": musicId} progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *songDic = [dic[@"data"][@"songList"] firstObject];
        self.songDic = songDic;
        self.musicUrl = [NSURL URLWithString:self.songDic[@"songLink"]];
        self.songItem = [[AVPlayerItem alloc] initWithURL:self.musicUrl];
        self.player = [[AVPlayer alloc] initWithPlayerItem:self.songItem];
        [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [self play];

    }    failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"请求失败");
    }];
}

- (void)updateMusicById:(NSString *)musicId {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = @"http://music.baidu.com/data/music/links";
    self.ProgressBar.value = 0.0;
    [manager GET:url parameters:@{@"songIds": musicId} progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *songDic = [dic[@"data"][@"songList"] firstObject];
        self.songDic = songDic;
        self.musicUrl = [NSURL URLWithString:self.songDic[@"songLink"]];
        self.songItem = [AVPlayerItem playerItemWithURL:self.musicUrl];
        [self.player replaceCurrentItemWithPlayerItem:self.songItem];
        [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [self play];
        [self addObserverAndNotification]; // 添加观察者，发布通知
    }    failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"请求失败");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *) object;
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown: {
                NSLog(@"未知转态");
            }
                break;
            case AVPlayerStatusReadyToPlay: {
                NSLog(@"准备播放");
                CMTime duration = item.duration; // 获取视频长度
                NSLog(@"%.2f", CMTimeGetSeconds(duration));
                // 设置时间
                [self setMaxDuration:CMTimeGetSeconds(duration)];
            }
                break;
            case AVPlayerStatusFailed: {
                NSLog(@"加载失败");
            }
                break;
            default:
                break;
        }
    }
}

- (void)play {
    self.isPlaying = YES;
    [self.player play]; // 调用avplayer 的play方法
    [self addObserverAndNotification]; // 添加观察者，发布通知
//    [self.playButton setImage:[UIImage imageNamed:@"Stop"] forState:(UIControlStateNormal)];
//    [self.playerButton setImage:[UIImage imageNamed:@"player_pause_iphone_window"] forState:(UIControlStateNormal)];
//    [self.playerFullScreenButton setImage:[UIImage imageNamed:@"player_pause_iphone_fullscreen"] forState:(UIControlStateNormal)];
}

- (void)pause {
    self.isPlaying = NO;
    [self.player pause];
//    [self.playButton setImage:[UIImage imageNamed:@"Play"] forState:(UIControlStateNormal)];
//    [self.playerButton setImage:[UIImage imageNamed:@"player_start_iphone_window"] forState:(UIControlStateNormal)];
//    [self.playerFullScreenButton setImage:[UIImage imageNamed:@"player_start_iphone_fullscreen"] forState:(UIControlStateNormal)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
