//
//  MyMusicViewController.m
//  WYY
//
//  Created by OurEDA on 2018/4/26.
//  Copyright © 2018年 123. All rights reserved.
//

#import "MyMusicViewController.h"

@interface MyMusicViewController ()
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation MyMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的音乐";

    CGRect screen = [[UIScreen mainScreen] bounds];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    [self.view addSubview:self.tableView];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cloud.png"] style:UIBarButtonItemStylePlain target:self action:nil];
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
    return 4;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *reuseFlag = @"reuseableFlag";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseFlag];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseFlag];
    }

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"本地音乐";
            cell.imageView.image = [UIImage imageNamed:@"本地音乐.png"];
            break;
        case 1:
            cell.textLabel.text = @"最近播放";
            cell.imageView.image = [UIImage imageNamed:@"最近播放.png"];
            break;
        case 2:
            cell.textLabel.text = @"我的电台";
            cell.imageView.image = [UIImage imageNamed:@"我的电台.png"];
            break;
        case 3:
            cell.textLabel.text = @"我的收藏";
            cell.imageView.image = [UIImage imageNamed:@"我的收藏.png"];
            break;

        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        MyCollectionViewController *myCollection = [[MyCollectionViewController alloc] init];
        [self.navigationController pushViewController:myCollection animated:YES];
    }
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
