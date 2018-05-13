//
//  PersonalViewController.m
//  WYY
//
//  Created by OurEDA on 2018/4/26.
//  Copyright © 2018年 123. All rights reserved.
//

#import "PersonalViewController.h"

@interface PersonalViewController ()
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIWindow *window;
@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账号";

    CGRect screen = [[UIScreen mainScreen] bounds];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    else if (section == 1)
        return 1;
    else if (section == 2)
        return 3;
    else if (section == 3)
        return 2;
    else if (section == 4)
        return 1;
    else
        return 0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *reuseFlag = @"reuseableFlag";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseFlag];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseFlag];
    }
    if (indexPath.section == 0) {

        return cell;
    } else {
        if (indexPath.section == 1) {
            cell.textLabel.text = @"我的消息";
            //        cell.imageView.image = [UIImage imageNamed:@"Icons/Me.png"];
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"VIP会员";
                //            cell.imageView.image = [UIImage imageNamed:@"Wo/Pocket.png"];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"商城";
                //cell.imageView.image = [UIImage imageNamed:@"Wo/Pocket.png"];
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"在线听歌免流量";
                //cell.imageView.image = [UIImage imageNamed:@"Wo/Pocket.png"];
            }
        } else if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"设置";
                //            cell.imageView.image = [UIImage imageNamed:@"Wo/Collection.png"];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"扫一扫";
                //            cell.imageView.image = [UIImage imageNamed:@"Wo/Album.png"];
            }
        } else if (indexPath.section == 4) {
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.text = @"退出登录";
            cell.textLabel.textColor = [UIColor redColor];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 4) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"网易云音乐" message:@"确定退出当前帐号吗" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"取消");
        }];

        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

//            NSLog(@"is userdfault clear?");
//            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//            if ([userDefaults objectForKey:@"userPhone"] != nil) {
//                NSLog(@"%@", [userDefaults objectForKey:@"userPhone"] != nil);
//            } else {
//                NSLog(@"isclear!");
//            }

            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [self.window makeKeyAndVisible];
            UINavigationController *viewController = [[UINavigationController alloc] initWithRootViewController:[[LogOrSignViewController alloc] init]];
            viewController.navigationBar.barTintColor = [UIColor redColor];
            NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
            [viewController.navigationBar setTitleTextAttributes:dict];
            self.window.rootViewController = viewController;
            self.window.backgroundColor = [UIColor whiteColor];
            [self.window makeKeyAndVisible];
        }];

        [alertController addAction:noAction];
        [alertController addAction:yesAction];

        [self presentViewController:alertController animated:true completion:nil];
    }
}

- (UILabel *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 3)];
    myLabel.text = @" ";
    myLabel.backgroundColor = [UIColor grayColor];

    return myLabel;
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
