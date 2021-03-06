//
//  MyCollectionViewController.m
//  WYY
//
//  Created by OurEDA on 2018/5/12.
//  Copyright © 2018年 123. All rights reserved.
//

#import "MyCollectionViewController.h"

@interface MyCollectionViewController ()
@property(nonatomic, strong) UITableView *tableView;
@property(strong, nonatomic) NSMutableArray *songsListArray;
@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的音乐";
    self.songsListArray = [[NSMutableArray alloc] initWithObjects:nil];
    [self getLikedMusicList];

    CGRect screen = [[UIScreen mainScreen] bounds];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    [self.view addSubview:self.tableView];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back_onClick:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"音乐.png"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songsListArray count];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *reuseFlag = @"reuseableFlag";
    MusicCellOfMyCollectionView *cell = [tableView dequeueReusableCellWithIdentifier:reuseFlag];
    if (cell == nil) {
        cell = [[MusicCellOfMyCollectionView alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseFlag];
    }
    NSDictionary *temp = self.songsListArray[indexPath.row];

    cell.myLabel1.text = [temp objectForKey:@"songTitle"];
    cell.myLabel2.text = [[NSString alloc] initWithFormat:@"%@ - %@", [temp objectForKey:@"artistName"], [temp objectForKey:@"albumTitle"]];
    cell.myLabel2.textColor = [UIColor darkGrayColor];
    cell.myLabel3.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    cell.myLabel3.textColor = [UIColor darkGrayColor];
    cell.myImageView.image = [UIImage imageNamed:@"points.png"];

    return cell;
}

- (void)back_onClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)getLikedMusicList {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaults objectForKey:@"userId"];
    //关联对象表
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Music"];
//需要查询的列
    BmobObject *user = [BmobObject objectWithoutDataWithClassName:@"User" objectId:userId];
    [bquery whereObjectKey:@"likes" relatedTo:user];
    extern NSMutableArray *playingList;
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            self.songsListArray = array;
            playingList = self.songsListArray;
            NSLog(@"playingList now is : %@", playingList);
            [self.tableView reloadData];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self getLikedMusicList];
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
