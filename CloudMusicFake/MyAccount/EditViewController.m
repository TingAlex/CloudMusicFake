//
//  EditViewController.m
//  WYY
//
//  Created by OurEDA on 2018/5/13.
//  Copyright © 2018年 123. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的资料";

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 5;
    else if (section == 1)
        return 3;
    return 0;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *reuseFlag = @"reuseableFlag";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:@"userName"];
    NSString *userHeadpic = [userDefaults objectForKey:@"userHeadpic"];
    NSURL *url = [NSURL URLWithString:userHeadpic];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HeadpicCellOfPersonalView *cell = [tableView dequeueReusableCellWithIdentifier:reuseFlag];
            if (cell == nil) {
                cell = [[HeadpicCellOfPersonalView alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseFlag];
            }
            cell.myLabel.text = @"头像";
            cell.myImageView.image = [[UIImage alloc] initWithData:data];;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        } else {
            NicknameCellOfPersonalView *cell = [tableView dequeueReusableCellWithIdentifier:reuseFlag];
            if (cell == nil) {
                cell = [[NicknameCellOfPersonalView alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseFlag];
            }
            if (indexPath.row == 1) {
                cell.myLabel_1.text = @"个人主页背景";
                cell.myLabel_2.text = @" ";
            } else if (indexPath.row == 2) {
                cell.myLabel_1.text = @"昵称";
                cell.myLabel_2.text = userName;
            } else if (indexPath.row == 3) {
                cell.myLabel_1.text = @"性别";
                cell.myLabel_2.text = @"男";
            } else {
                cell.myLabel_1.text = @"二维码";
                cell.myLabel_2.text = @" ";
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    } else {
        NicknameCellOfPersonalView *cell = [tableView dequeueReusableCellWithIdentifier:reuseFlag];
        if (cell == nil) {
            cell = [[NicknameCellOfPersonalView alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseFlag];
        }
        switch (indexPath.row) {
            case 0:
                cell.myLabel_1.text = @"生日";
                cell.myLabel_2.text = @"1998-03-29";
                break;
            case 1:
                cell.myLabel_1.text = @"地区";
                cell.myLabel_2.text = @"辽宁 大连";
                break;
            default:
                cell.myLabel_1.text = @"大学";
                cell.myLabel_2.text = @"大连理工大学";
                break;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (void)back_onClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UILabel *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 3)];
    myLabel.text = @" ";
    myLabel.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:235 / 255.0 blue:237 / 255.0 alpha:1];

    return myLabel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

//    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
