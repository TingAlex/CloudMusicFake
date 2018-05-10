//
//  ViewController.m
//  CloudMusicFake
//
//  Created by OurEDA on 2018/4/24.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) NSMutableArray *musicInfoArray;
@property(nonatomic, strong) NSDictionary *songDic;
@end

@implementation ViewController

//-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
//
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//***********analyse music info out of id3****
//    self.musicInfoArray=[self MusicInfoArray];
//    BmobObject *musicInfo=[BmobObject objectWithClassName:@"MusicInfo"];
//********************************************

//***********when using local music file***
//    NSString *pathstring=[[NSBundle mainBundle] pathForResource:@"testmic" ofType:@"mp3"];
//    NSURL *playurl=[NSURL fileURLWithPath:pathstring];
//    AVPlayerItem *songItem = [[AVPlayerItem alloc] initWithURL:playurl];
//    self.player= [[AVPlayer alloc] initWithPlayerItem:songItem];
//    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//    [self.player play];
//*****************************************

//****************test on baidu music api**
//    NSString *strURL = [[NSString alloc] initWithFormat:@"http://zhangmenshiting.qianqian.com/data2/music/42783748/42783748.mp3?xcode=75c3d46835796fcae4d6351b3c1b445d"];
//    strURL = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSURL *playurl=[NSURL fileURLWithPath:strURL];
//    //            NSURL *playUrl=[NSURL fileURLWithPath:dict[@"data"][0][@"url"]];
//    AVPlayerItem *songItem = [[AVPlayerItem alloc] initWithURL:playurl];
//    self.player= [[AVPlayer alloc] initWithPlayerItem:songItem];
//    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//    [self.player play];
//*****************************************

//    NSString *strURL = [[NSString alloc] initWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.song.play&songid=%@", @"877578"];
//    strURL = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSURL *url = [NSURL URLWithString:strURL];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//    NSLog(@"%@", url);
//
//    //管理对象SessionManager
//    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:defaultConfig];
//
//    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
//    [securityPolicy setAllowInvalidCertificates:YES];
//    [manager setSecurityPolicy:securityPolicy];
//
//    //接收序列化
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        NSLog(@"请求完成...");
//        if (!error) {
//            NSData *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"jsonData: %@", jsonData);
//
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//            NSLog(@"dict: %@", dict[@"bitrate"][@"show_link"]);
//            NSURL *playurl = [NSURL fileURLWithPath:dict[@"bitrate"][@"file_link"]];
//            AVPlayerItem *songItem = [[AVPlayerItem alloc] initWithURL:playurl];
//            self.player = [[AVPlayer alloc] initWithPlayerItem:songItem];
//            [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//            [self.player play];
//        } else {
//            NSLog(@"error : %@", error.localizedDescription);
//        }
//    }];
//********************************
//    NSBundle    *bundle = [NSBundle mainBundle];
//    NSString *fileString = [NSString stringWithFormat:@"%@/FangXia.mp3" ,[bundle bundlePath] ];
//    BmobFile *file1 = [[BmobFile alloc] initWithFilePath:fileString];
//    [file1 saveInBackground:^(BOOL isSuccessful, NSError *error) {
//        //如果文件保存成功，则把文件添加到filetype列
//        if (isSuccessful) {
//            //打印file文件的url地址
//            NSLog(@"file1 url %@",file1.url);
//        }else{
//            //进行处理
//        }
//    }];
//    NSString *tempMusicName = @"testmic.mp3";
//    [self uploadMusic:tempMusicName];
//    [self playMusicById:@"816477"];
//    [self getRecommendMusicList];
//    [self testTables];
//*******************************
//    [task resume];
}

- (void)playMusicById:(NSString *)musicId {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = @"http://music.baidu.com/data/music/links";
    [manager GET:url parameters:@{@"songIds": musicId} progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *songDic = [dic[@"data"][@"songList"] firstObject];
        self.songDic = songDic;

        NSURL *tempURL = [NSURL URLWithString:songDic[@"songLink"]];
        AVPlayerItem *songItem = [[AVPlayerItem alloc] initWithURL:tempURL];
        self.player = [[AVPlayer alloc] initWithPlayerItem:songItem];
        [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [self.player play];
    }    failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"请求失败");
    }];
}

- (void)getRecommendMusicList {
    //在每日推荐中，我们需要这些信息
    //歌曲缩略图：album_500_500，歌曲名：title，歌曲id：song_id，歌手名：artist_name，歌手id：artist_id，专辑名：album_title，专辑id：album_id
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *method = @"baidu.ting.billboard.billList&type=1&size=10&offset=0";
    NSString *url = @"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=";
    NSString *fullUrl = [url stringByAppendingString:method];
    [manager GET:fullUrl parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",dic);
        NSArray *songList = dic[@"song_list"];
        NSLog(@"%@", songList[0]);
    }    failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"请求失败");
    }];
}

- (void)getUserCollectionMusicList {
    //TODO: 在Bmob中取得用户收藏的音乐列表。获得每首歌的这些信息：歌曲缩略图：album_500_500，歌曲名：title，歌曲id：song_id，歌手名：artist_name，歌手id：artist_id，专辑名：album_title，专辑id：album_id

}

- (void)storeUserCollectionMusic {
    //TODO: 向Bmob中存储用户收藏的音乐信息，包括歌曲缩略图：album_500_500，歌曲名：title，歌曲id：song_id，歌手名：artist_name，歌手id：artist_id，专辑名：album_title，专辑id：album_id

}

- (void)getMusicInfoById:(NSString *)musicId {
    //TODO: 播放页面，需要歌曲缩略图：album_500_500，歌曲名：title，歌曲id：song_id，歌手名：artist_name，歌手id：artist_id，专辑名：album_title，专辑id：album_id

}

- (void)testTables {
    BmobObject *user = [BmobObject objectWithClassName:@"_User"];
    NSDictionary *userDic = @{@"username": @"小黑", @"password": @"12345", @"email": @"158@qq.com", @"headpic": @""};
    [user saveAllWithDictionary:userDic];
    //异步保存
    [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //创建成功后的动作
        } else if (error) {
            //发生错误后的动作
            NSLog(@"%@", error);
        } else {
            NSLog(@"Unknow error");
        }
    }];

    BmobObject *music = [BmobObject objectWithClassName:@"Music"];
    NSDictionary *musicDic = @{@"songTitle": @"TingING", @"artistName": @"Ting"};
    [music saveAllWithDictionary:musicDic];
    //异步保存
    [music saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //创建成功后的动作
        } else if (error) {
            //发生错误后的动作
            NSLog(@"%@", error);
        } else {
            NSLog(@"Unknow error");
        }
    }];

    BmobObject *comment = [BmobObject objectWithClassName:@"Comment"];
    //设置playerName列的值为小黑和age列的值18
    NSDictionary *commentDic = @{@"content": @"beautiful!", @"likeNum": @18};
    [comment saveAllWithDictionary:commentDic];
    //异步保存
    [comment saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //创建成功后的动作
        } else if (error) {
            //发生错误后的动作
            NSLog(@"%@", error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
}


- (void)uploadMusic:(NSString *)name {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *fileString = [NSString stringWithFormat:@"%@/%@", [bundle bundlePath], name];
//    NSURL *fileURL = [NSURL fileURLWithPath:fileString];
//    NSLog(@"music filePath: %@", fileString);
//    AVPlayerItem *songItem = [[AVPlayerItem alloc] initWithURL:fileURL];
//    self.player = [[AVPlayer alloc] initWithPlayerItem:songItem];
//    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
//    [self.player play];
    BmobFile *file1 = [[BmobFile alloc] initWithFilePath:fileString];
    [file1 saveInBackground:^(BOOL isSuccessful, NSError *error) {
        //如果文件保存成功，则把文件添加到filetype列
        if (isSuccessful) {
            //打印file文件的url地址
            NSLog(@"music url %@", file1.url);
        } else {
            NSLog(@"upload failed!");
        }
    }];
}

- (NSMutableArray *)MusicInfoArray {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSArray *mp3Array = [NSBundle pathsForResourcesOfType:@"mp3" inDirectory:[[NSBundle mainBundle] resourcePath]];

    for (NSString *filePath in mp3Array) {
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSString *MusicName = [filePath lastPathComponent];
        AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:url options:nil];
        NSLog(@"%@", mp3Asset);
        for (NSString *format in [mp3Asset availableMetadataFormats]) {
            NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
            [infoDict setObject:MusicName forKey:@"MusicName"];
            NSLog(@"format type = %@", format);
            for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
                NSLog(@"commonKey = %@", metadataItem.commonKey);

                if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                    NSString *mime = [(NSDictionary *) metadataItem.value objectForKey:@"MIME"];
                    NSLog(@"mime: %@", mime);

                    [infoDict setObject:mime forKey:@"artwork"];
                } else {
                    NSLog(@"mime: %@", @"Not contain picture");
                    [infoDict setObject:@"defaultAlbumPic.jpg" forKey:@"artwork"];
                }

                if ([metadataItem.commonKey isEqualToString:@"title"]) {
                    NSString *title = (NSString *) metadataItem.value;
                    NSLog(@"title: %@", title);

                    [infoDict setObject:title forKey:@"title"];
                } else if ([metadataItem.commonKey isEqualToString:@"artist"]) {
                    NSString *artist = (NSString *) metadataItem.value;
                    NSLog(@"artist: %@", artist);

                    [infoDict setObject:artist forKey:@"artist"];
                } else if ([metadataItem.commonKey isEqualToString:@"albumName"]) {
                    NSString *albumName = (NSString *) metadataItem.value;
                    NSLog(@"albumName: %@", albumName);

                    [infoDict setObject:albumName forKey:@"albumName"];
                }
            }

            [resultArray addObject:infoDict];
        }
    }

    return resultArray;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown: {
                NSLog(@"未知转态");
            }
                break;
            case AVPlayerStatusReadyToPlay: {
                NSLog(@"准备播放");
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
