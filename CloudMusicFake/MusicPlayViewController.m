//
//  MusicPlayViewController.m
//  CloudMusicFake
//
//  Created by OurEDA on 2018/5/7.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import "MusicPlayViewController.h"

@interface MusicPlayViewController ()
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
@property(weak, nonatomic) IBOutlet UIView *RotatePart;
@property(nonatomic, assign) bool flagForAnimation;
@property(nonatomic, assign) bool flagForLikeState;
// 播放状态
@property(nonatomic, assign) BOOL isPlaying;
@property(nonatomic, assign) BOOL isSliding; // 是否正在滑动
extern NSMutableArray *playingList;
extern NSInteger playingIndex;

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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userId"];
    BmobObject *post = [BmobObject objectWithoutDataWithClassName:@"User" objectId:userId];
//新建relation对象
    BmobRelation *relation = [[BmobRelation alloc] init];
    if (self.flagForLikeState == false) {
        [self setupLikedBtn];
        //获取要添加关联关系的
        [relation addObject:[BmobObject objectWithoutDataWithClassName:@"Music" objectId:[self.songInfo objectForKey:@"objectId"]]];
//添加关联关系到likes列中
        [post addRelation:relation forKey:@"likes"];
//异步更新obj的数据
        [post updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"add like music successful");
            } else {
                NSLog(@"error %@", [error description]);
            }
        }];
    } else {
        [self setupLikeBtn];
        [relation removeObject:[BmobObject objectWithoutDataWithClassName:@"Music" objectId:[self.songInfo objectForKey:@"objectId"]]];
//添加关联关系到likes列中
        [post addRelation:relation forKey:@"likes"];
//异步更新obj的数据
        [post updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"remove like music successful");
            } else {
                NSLog(@"error %@", [error description]);
            }
        }];
    }
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
    [self prepareStateForAnotherMusic];
    [self removeObserveAndNOtification];
    playingIndex = (playingIndex - 1) % playingList.count;
    self.songInfo = [playingList objectAtIndex:playingIndex];
    [self setMusicPicByInfo];
    self.flagForAnimation = false;
    [self playMusicById:[self.songInfo objectForKey:@"songId"]];
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
    [self prepareStateForAnotherMusic];
    [self removeObserveAndNOtification];
    playingIndex = (playingIndex + 1) % playingList.count;
    self.songInfo = [playingList objectAtIndex:playingIndex];
    [self setMusicPicByInfo];
    self.flagForAnimation = false;
    [self playMusicById:[self.songInfo objectForKey:@"songId"]];
    [self addObserverAndNotification]; // 添加观察者，发布通知
}

- (void)prepareStateForAnotherMusic {
    self.NowTime.text = @"00:00";
    self.TotalTime.text = @"00:00";
    self.flagForAnimation = false;
    [self.RotatePart.layer removeAllAnimations];
    [self setupLikeBtn];
    [self setupDownloadBtn];
}

- (void)setMusicPicByInfo {
    [self setLikeState];
    NSURL *albumPicUrl = [NSURL URLWithString:[self.songInfo objectForKey:@"albumPic"]];
    NSData *albumPicData = [NSData dataWithContentsOfURL:albumPicUrl];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgView.image = [[UIImage alloc] initWithData:albumPicData];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, bgImgView.frame.size.width, bgImgView.frame.size.height);
    [bgImgView addSubview:effectView];
    bgImgView.tag = 111;
    UIView *subviews = [self.view viewWithTag:111];
    [subviews removeFromSuperview];
    [self.view insertSubview:bgImgView atIndex:0];
    self.AlbumBackImage.image = [UIImage imageNamed:@"cm2_play_disc"];
    self.AlbumImage.image = [[UIImage alloc] initWithData:albumPicData];
    self.AlbumImage.layer.masksToBounds = YES;
    self.AlbumImage.layer.cornerRadius = 165 / 2.0f;
}

- (void)setLikeState {
    NSString *likes = [self.songInfo objectForKey:@"objectId"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userId"];

    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
//构造约束条件
    BmobQuery *inQuery = [BmobQuery queryWithClassName:@"Music"];
    [inQuery whereKey:@"objectId" equalTo:likes];
//匹配查询
    [bquery whereKey:@"likes" matchesQuery:inQuery];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"network error");
        } else if (array) {
            if (array.count == 0) {
                NSLog(@"not found like this music");
                [self setupLikeBtn];
            } else {
                NSLog(@"found like this music %@", array[0]);
                [self setupLikedBtn];
            }
        }
    }];
}

- (IBAction)PlayList:(id)sender {
}

- (IBAction)playerSliderTouchDown:(id)sender {
    [self pause];
    self.isSliding = YES;
}

- (IBAction)playerSliderTouchUpInside:(id)sender {
    self.isSliding = NO; // 滑动结束
    [self play];
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
//    [self.player removeTimeObserver:self._playTimeObserver]; // 移除playTimeObserver
}

- (void)removeObserveAndNOtification {
    [self.player replaceCurrentItemWithPlayerItem:nil];
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [self.player removeTimeObserver:self._playTimeObserver];
        self._playTimeObserver = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
//    [self.songItem removeObserver:self forKeyPath:@"status"];
//    [self.songItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
//    [self.player removeTimeObserver:self._playTimeObserver];
//    self._playTimeObserver = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
//            NSLog(@"not sliding");
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
    self.NowTime.text = [formatterS stringFromDate:dateS];
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
    self.TotalTime.text = [formatterS stringFromDate:dateS];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Add glass effect background picture.
//    [self setupInitialState];
//    extern NSMutableArray *playingList;
//    extern NSInteger playingIndex;
//    self.songInfo = [playingList objectAtIndex:playingIndex];
//    NSLog(@"now songInfo is %@", self.songInfo);
//    [self setMusicPicByInfo];
//    [self playMusicById:[self.songInfo valueForKey:@"song_id"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [self removeObserveAndNOtification];
    [self setupInitialState];
    self.songInfo = [playingList objectAtIndex:playingIndex];
    [self setMusicPicByInfo];
    [self playMusicById:[self.songInfo objectForKey:@"songId"]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserveAndNOtification];
}

- (void)playMusicById:(NSString *)musicId {
    NSLog(@"play music by id %@ %d", playingList, playingIndex);
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

- (void)setupInitialState {
    self.flagForLikeState = false;
    self.NowTime.text = @"00:00";
    self.TotalTime.text = @"00:00";
    self.NowTime.textColor = [UIColor whiteColor];
    self.TotalTime.textColor = [UIColor whiteColor];
    self.flagForAnimation = false;
    self.RotatePart.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
    [self setupPlayBtn];
    [self setupLikeBtn];
    [self setPlayStyle:0];
    [self setupDownloadBtn];
    [self setupCommentBtn];
    [self setupMoreInfoBtn];
    [self setupUpMusicBtn];
    [self setupNextBtn];
    [self setupPlayListBtn];
}

- (void)play {
    self.isPlaying = YES;
    [self startAnimation];
    [self.player play]; // 调用avplayer 的play方法
    [self addObserverAndNotification]; // 添加观察者，发布通知
    [self setupPlayBtn];
}

- (void)pause {
    self.isPlaying = NO;
    [self stopAnimation];
    [self.player pause];
    [self setupPauseBtn];
}

- (void)setPlayStyle:(NSInteger)style {
    switch (style) {
        case 0://Loop
        {
            [self.PlayMode setImage:[UIImage imageNamed:@"cm2_icn_loop"] forState:UIControlStateNormal];
            [self.PlayMode setImage:[UIImage imageNamed:@"cm2_icn_loop_prs"] forState:UIControlStateHighlighted];
        }
            break;
        case 1://Random
        {
            [self.PlayMode setImage:[UIImage imageNamed:@"cm2_icn_shuffle"] forState:UIControlStateNormal];
            [self.PlayMode setImage:[UIImage imageNamed:@"cm2_icn_shuffle_prs"] forState:UIControlStateHighlighted];
        }
            break;
        case 2://Line
        {
            [self.PlayMode setImage:[UIImage imageNamed:@"cm2_icn_one"] forState:UIControlStateNormal];
            [self.PlayMode setImage:[UIImage imageNamed:@"cm2_icn_one_prs"] forState:UIControlStateHighlighted];
        }
            break;

        default:
            break;
    }
}

- (void)setupPlayBtn {
    [self.PlayOrStop setImage:[UIImage imageNamed:@"cm2_fm_btn_pause"] forState:UIControlStateNormal];
    [self.PlayOrStop setImage:[UIImage imageNamed:@"cm2_fm_btn_pause_prs"] forState:UIControlStateHighlighted];
}

- (void)setupPauseBtn {
    [self.PlayOrStop setImage:[UIImage imageNamed:@"cm2_fm_btn_play"] forState:UIControlStateNormal];
    [self.PlayOrStop setImage:[UIImage imageNamed:@"cm2_fm_btn_play_prs"] forState:UIControlStateHighlighted];
}

- (void)setupLikeBtn {
    [self.Like setImage:[UIImage imageNamed:@"cm2_play_icn_love"] forState:UIControlStateNormal];
    [self.Like setImage:[UIImage imageNamed:@"cm2_play_icn_love_prs"] forState:UIControlStateHighlighted];
    self.flagForLikeState = false;
}

- (void)setupLikedBtn {
    [self.Like setImage:[UIImage imageNamed:@"cm2_play_icn_loved"] forState:UIControlStateNormal];
    [self.Like setImage:[UIImage imageNamed:@"cm2_play_icn_loved_prs"] forState:UIControlStateHighlighted];
    self.flagForLikeState = true;
}

- (void)setupDownloadBtn {
    [self.Download setImage:[UIImage imageNamed:@"cm2_icn_dld"] forState:UIControlStateNormal];
    [self.Download setImage:[UIImage imageNamed:@"cm2_icn_dld_prs"] forState:UIControlStateHighlighted];
}

- (void)setupCommentBtn {
    [self.Comment setImage:[UIImage imageNamed:@"cm2_fm_btn_cmt"] forState:UIControlStateNormal];
    [self.Comment setImage:[UIImage imageNamed:@"cm2_fm_btn_cmt_prs"] forState:UIControlStateHighlighted];
}

- (void)setupMoreInfoBtn {
    [self.MoreInfo setImage:[UIImage imageNamed:@"cm2_play_icn_more"] forState:UIControlStateNormal];
    [self.MoreInfo setImage:[UIImage imageNamed:@"cm2_play_icn_more_prs"] forState:UIControlStateHighlighted];
}

- (void)setupUpMusicBtn {
    [self.UpMusic setImage:[UIImage imageNamed:@"cm2_fm_btn_previous"] forState:UIControlStateNormal];
    [self.UpMusic setImage:[UIImage imageNamed:@"cm2_fm_btn_previous_prs"] forState:UIControlStateHighlighted];
}

- (void)setupNextBtn {
    [self.NextMusic setImage:[UIImage imageNamed:@"cm2_fm_btn_next"] forState:UIControlStateNormal];
    [self.NextMusic setImage:[UIImage imageNamed:@"cm2_fm_btn_next_prs"] forState:UIControlStateHighlighted];
}

- (void)setupPlayListBtn {
    [self.PlayList setImage:[UIImage imageNamed:@"cm2_icn_list"] forState:UIControlStateNormal];
    [self.PlayList setImage:[UIImage imageNamed:@"cm2_icn_list_prs"] forState:UIControlStateHighlighted];
}

- (void)startAnimation {
    if (self.flagForAnimation == false) {
        NSLog(@"flag is false!");
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
        animation.fromValue = [NSNumber numberWithFloat:0.f];
        animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
        animation.duration = 3;
        animation.autoreverses = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
        [self.RotatePart.layer addAnimation:animation forKey:@"run"];
        self.flagForAnimation = true;
    } else {
        NSLog(@"flag is true!");
        CFTimeInterval pausedTime = [self.RotatePart.layer timeOffset];
        self.RotatePart.layer.speed = 1.0;
        self.RotatePart.layer.timeOffset = 0.0;
        self.RotatePart.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [self.RotatePart.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        self.RotatePart.layer.beginTime = timeSincePause;
    }
}

- (void)stopAnimation {
    CFTimeInterval pausedTime = [self.RotatePart.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.RotatePart.layer.speed = 0.0;
    self.RotatePart.layer.timeOffset = pausedTime;
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
