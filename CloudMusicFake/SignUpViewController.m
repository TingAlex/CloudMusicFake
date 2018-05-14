//
//  SignUpViewController.m
//  WYY
//
//  Created by OurEDA on 2018/5/12.
//  Copyright © 2018年 123. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
@property(strong, nonatomic) UITextField *identity;
@property(strong, nonatomic) UITextField *password;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"手机号注册";
    CGRect screen = [[UIScreen mainScreen] bounds];
    self.identity = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, screen.size.width - 40, 30)];
    self.identity.borderStyle = UITextBorderStyleNone;
    self.identity.backgroundColor = [UIColor whiteColor];
    self.identity.placeholder = @"输入手机号";
    self.identity.font = [UIFont fontWithName:@"Arial" size:20.0f];
    self.identity.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.identity.keyboardType = UIKeyboardTypeNumberPad;
    //    UIImageView *self.identityImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"self.identity.png"]];
    //    self.identity.leftView = self.identityImage;
    //    self.identity.leftViewMode = UITextFieldViewModeAlways;
    self.identity.delegate = self;
    [self.view addSubview:self.identity];

    self.password = [[UITextField alloc] initWithFrame:CGRectMake(20, 110, screen.size.width - 40, 30)];
    self.password.borderStyle = UITextBorderStyleNone;
    self.password.backgroundColor = [UIColor whiteColor];
    self.password.placeholder = @"设置登录密码";
    self.password.font = [UIFont fontWithName:@"Arial" size:20.0f];
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password.secureTextEntry = YES;
    //    UIImageView *self.passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"self.password.png"]];
    //    self.password.leftView = self.passwordImage;
    //    self.password.leftViewMode = UITextFieldViewModeAlways;
    self.password.delegate = self;
    [self.view addSubview:self.password];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(back_onClick:)];
    self.navigationItem.leftBarButtonItem = leftItem;

    UIButton *next = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [next.layer setCornerRadius:20.0];
    next.frame = CGRectMake(20, 180, screen.size.width - 40, 40);
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    next.backgroundColor = [UIColor redColor];
    [next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    next.titleLabel.font = [UIFont systemFontOfSize:20];
    [next addTarget:self action:@selector(next_onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:next];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back_onClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)next_onClick:(id)sender {
    BmobObject *user = [BmobObject objectWithClassName:@"User"];

    NSDictionary *userDic = @{@"password": self.password.text, @"mobilePhoneNumber": self.identity.text, @"username": @"萌新", @"headpic": @"https://i.imgur.com/gYYnOMZg.jpg"};
    [user saveAllWithDictionary:userDic];
    //异步保存
    [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //储存密码
            [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:@"password"];
            //储存账户
            [[NSUserDefaults standardUserDefaults] setObject:self.identity.text forKey:@"userPhone"];
            [[NSUserDefaults standardUserDefaults] setObject:@"萌新" forKey:@"userName"];
//            https://i.imgur.com/gYYnOMZg.jpg
            [[NSUserDefaults standardUserDefaults] setObject:@"https://i.imgur.com/gYYnOMZg.jpg" forKey:@"userHeadpic"];
            //必须
            [[NSUserDefaults standardUserDefaults] setObject:user.objectId forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        } else if (error) {
            //发生错误后的动作
            NSLog(@"%@", error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
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
