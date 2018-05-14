//
//  LoginViewController.m
//  WYY
//
//  Created by OurEDA on 2018/5/12.
//  Copyright © 2018年 123. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property(strong, nonatomic) UITextField *identity;
@property(strong, nonatomic) UITextField *password;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"手机号登录";

    CGRect screen = [[UIScreen mainScreen] bounds];

    self.identity = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, screen.size.width - 40, 30)];
    self.identity.borderStyle = UITextBorderStyleNone;
    self.identity.backgroundColor = [UIColor whiteColor];
    self.identity.placeholder = @"手机号";
    self.identity.font = [UIFont fontWithName:@"Arial" size:20.0f];
    self.identity.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.identity.keyboardType = UIKeyboardTypeNumberPad;
    UIView *leftView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    leftView1.backgroundColor = [UIColor clearColor];
    UIImageView *identityImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 25, 25)];
    identityImage.image = [UIImage imageNamed:@"phone.png"];
    [leftView1 addSubview:identityImage];
    self.identity.leftView = leftView1;
    self.identity.leftViewMode = UITextFieldViewModeAlways;
    self.identity.delegate = self;
    [self.view addSubview:self.identity];

    self.password = [[UITextField alloc] initWithFrame:CGRectMake(20, 110, screen.size.width - 40, 30)];
    self.password.borderStyle = UITextBorderStyleNone;
    self.password.backgroundColor = [UIColor whiteColor];
    self.password.placeholder = @"密码";
    self.password.font = [UIFont fontWithName:@"Arial" size:20.0f];
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password.secureTextEntry = YES;
    UIView *leftView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    leftView2.backgroundColor = [UIColor clearColor];
    UIImageView *passwordImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 25, 25)];
    passwordImage.image = [UIImage imageNamed:@"password.png"];
    [leftView2 addSubview:passwordImage];
    self.password.leftView = leftView2;
    self.password.leftViewMode = UITextFieldViewModeAlways;
    self.password.delegate = self;
    [self.view addSubview:self.password];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back_onClick:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];

    UIButton *signIn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signIn.layer setCornerRadius:20.0];
    signIn.frame = CGRectMake(20, 180, screen.size.width - 40, 40);
    [signIn setTitle:@"登录" forState:UIControlStateNormal];
    signIn.backgroundColor = [UIColor redColor];
    [signIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signIn.titleLabel.font = [UIFont systemFontOfSize:20];
    [signIn addTarget:self action:@selector(signIn_onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signIn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back_onClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)signIn_onClick:(id)sender {
    NSString *mobilePhoneNumber = self.identity.text;
    NSString *password = self.password.text;
    NSArray *array = @[@{@"mobilePhoneNumber": mobilePhoneNumber}, @{@"password": password}];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"User"];
    [bquery addTheConstraintByAndOperationWithArray:array];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array1, NSError *error) {
        if (error) {
            NSLog(@"network error!");
        } else {
            if (array1.count == 1) {
                NSLog(@"%@", [array1[0] objectForKey:@"mobilePhoneNumber"]);
                //储存
                [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setObject:mobilePhoneNumber forKey:@"userPhone"];
                [[NSUserDefaults standardUserDefaults] setObject:[array1[0] objectForKey:@"headpic"] forKey:@"userHeadpic"];
                [[NSUserDefaults standardUserDefaults] setObject:[array1[0] objectForKey:@"username"] forKey:@"userName"];
                [[NSUserDefaults standardUserDefaults] setObject:[array1[0] objectForKey:@"objectId"] forKey:@"userId"];
                [[NSUserDefaults standardUserDefaults] setObject:[array1[0] objectForKey:@"email"] forKey:@"userEmail"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                [self.window makeKeyAndVisible];
                UITabBarController *tabBarController = [[UITabBarController alloc] init];
                self.window.rootViewController = tabBarController;
                UIViewController *musicRecommend = [[MusicRecommendViewController alloc] init];
                UIViewController *myMusic = [[MyMusicViewController alloc] init];
                UIViewController *personal = [[PersonalViewController alloc] init];

                UINavigationController *musicRecommendNC = [[UINavigationController alloc] initWithRootViewController:musicRecommend];
                UINavigationController *myMusicNC = [[UINavigationController alloc] initWithRootViewController:myMusic];
                UINavigationController *personalNC = [[UINavigationController alloc] initWithRootViewController:personal];

                [musicRecommendNC.navigationBar setBarTintColor:[UIColor redColor]];
                [myMusicNC.navigationBar setBarTintColor:[UIColor redColor]];
                [personalNC.navigationBar setBarTintColor:[UIColor redColor]];
                [musicRecommendNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil]];
                [myMusicNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil]];
                [personalNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil]];
                tabBarController.tabBar.tintColor = [UIColor whiteColor];
                tabBarController.tabBar.backgroundColor = [UIColor redColor];

//                    tabBarController.tabBar.frame.size.height=80;
                UIView *bgView = [[UIView alloc] initWithFrame:tabBarController.tabBar.bounds];
                bgView.backgroundColor = [UIColor colorWithRed:43 / 255.0 green:43 / 255.0 blue:43 / 255.0 alpha:1];
                [tabBarController.tabBar insertSubview:bgView atIndex:0];

                musicRecommendNC.tabBarItem.image = [UIImage imageNamed:@"find_2.png"];
                myMusicNC.tabBarItem.image = [UIImage imageNamed:@"mine_2.png"];
                personalNC.tabBarItem.image = [UIImage imageNamed:@"account_2.png"];

                musicRecommendNC.tabBarItem.selectedImage = [UIImage imageNamed:@"find.png"];
                myMusicNC.tabBarItem.selectedImage = [UIImage imageNamed:@"mine.png"];
                personalNC.tabBarItem.selectedImage = [UIImage imageNamed:@"account.png"];

                musicRecommendNC.tabBarItem.title = @"发现";
                myMusicNC.tabBarItem.title = @"我的";
                personalNC.tabBarItem.title = @"账号";


                tabBarController.viewControllers = @[musicRecommendNC, myMusicNC, personalNC];
                //to avoid lazyondemond.
                for (UIViewController *controller in tabBarController.viewControllers) {
                    UIView *view = controller.view;
                }
            } else {
                NSLog(@"need login!");
                //TODO:need login part
                self.identity.text = @"";
                self.password.text = @"";
            }
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
