//
//  MusicRecommendViewController.m
//  CloudMusicFake
//
//  Created by OurEDA on 2018/5/7.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import "MusicRecommendViewController.h"

@interface MusicRecommendViewController ()
@property(nonatomic, strong) UISearchController *searchController;
@property(nonatomic, strong) UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *songsListArray;

@end

@implementation MusicRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.songsListArray = [self.sandboxDic allValues];
    self.navigationItem.title = @"每日推荐";

    self.songsListArray = [[NSMutableArray alloc] initWithObjects:nil];
    [self getRecommendMusicList];
//    NSLog(@"%@", self.songsListArray);
    CGRect screen = [[UIScreen mainScreen] bounds];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, screen.size.width, screen.size.height - 100) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"音乐.png"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (nonnull UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusableFlag = @"resuableFlag";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableFlag];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reusableFlag];
        NSLog(@"______");
    }
    NSDictionary *temp = self.songsListArray[indexPath.row];
    cell.textLabel.text = [temp objectForKey:@"songTitle"];
    NSString *artist_album = [[NSString alloc] initWithFormat:@"%@ - %@", [temp objectForKey:@"artistName"], [temp objectForKey:@"albumTitle"]];
    cell.detailTextLabel.text = artist_album;
    NSURL *url = [NSURL URLWithString:[temp objectForKey:@"albumPic"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.imageView.image = [[UIImage alloc] initWithData:data];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songsListArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicPlayViewController *musicPlay = [[MusicPlayViewController alloc] initWithNibName:@"MusicPlayViewController" bundle:nil];
    extern NSInteger playingIndex;
    playingIndex = indexPath.row;
//    NSLog(@"playingIndex is %ld", playingIndex);
//    NSLog(@"show songInfo: %@", musicPlay.songInfo);
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:musicPlay animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)getRecommendMusicList {
    //在每日推荐中，我们需要这些信息
    //歌曲缩略图：album_500_500，歌曲名：title，歌曲id：song_id，歌手名：artist_name，歌手id：artist_id，专辑名：album_title，专辑id：album_id
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSString *method = @"baidu.ting.billboard.billList&type=1&size=10&offset=0";
//    NSString *url = @"http://tingapi.ting.baidu.com/v1/restserver/ting?format=json&calback=&from=webapp_music&method=";
//    NSString *fullUrl = [url stringByAppendingString:method];
//    [manager GET:fullUrl parameters:nil progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
//
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
////        NSLog(@"%@",dic);
//        self.songsListArray = dic[@"song_list"];
////        [self storeRecommendMusicListInBmob:self.songsListArray];
//        extern NSMutableArray *playingList;
//        playingList = self.songsListArray;
////        NSLog(@"playingList is %@", playingList);
//        [self.tableView reloadData];
////        NSLog(@"%@", songList[0]);
//    }    failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
//        NSLog(@"请求失败");
//    }];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Music"];
    extern NSMutableArray *playingList;
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        self.songsListArray = array;
        playingList = self.songsListArray;
        NSLog(@"playingList now is : %@", playingList);
        [self.tableView reloadData];
    }];

}

- (void)storeRecommendMusicListInBmob:(NSMutableArray *)songsListArray {
    NSDictionary *musicDic;
    BmobObjectsBatch *batch = [[BmobObjectsBatch alloc] init];
    for (NSInteger i = 0; i < songsListArray.count; i++) {
        musicDic = @{@"albumPic": songsListArray[i][@"album_500_500"], @"songTitle": songsListArray[i][@"title"], @"songId": songsListArray[i][@"song_id"], @"artistName": songsListArray[i][@"artist_name"], @"artistId": songsListArray[i][@"artist_id"], @"albumTitle": songsListArray[i][@"album_title"], @"albumId": songsListArray[i][@"album_id"]};
        [batch saveBmobObjectWithClassName:@"Music" parameters:musicDic];
    }
    [batch batchObjectsInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (error != nil) {
            NSLog(@"batch error %@", [error description]);
        } else {
            NSLog(@"add recommend music list in bmob successful!");
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
