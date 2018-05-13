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
//    UIImageView *self.identityImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"self.identity.png"]];
//    self.identity.leftView = self.identityImage;
//    self.identity.leftViewMode = UITextFieldViewModeAlways;
    self.identity.delegate = self;
    [self.view addSubview:self.identity];

    self.password = [[UITextField alloc] initWithFrame:CGRectMake(20, 110, screen.size.width - 40, 30)];
    self.password.borderStyle = UITextBorderStyleNone;
    self.password.backgroundColor = [UIColor whiteColor];
    self.password.placeholder = @"密码";
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
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"_User"];
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

                [musicRecommendNC.navigationBar setBarTintColor:[UIColor grayColor]];
                [myMusicNC.navigationBar setBarTintColor:[UIColor grayColor]];
                [personalNC.navigationBar setBarTintColor:[UIColor grayColor]];
//    [meNC.navigationBar setBarTintColor:[UIColor grayColor]];
                [musicRecommendNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil]];
                [myMusicNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil]];
                [personalNC.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil]];
                tabBarController.tabBar.tintColor = [UIColor redColor];
//    contactsNC.tabBarItem.image = [UIImage imageNamed:@"Contacts.png"];
//    findNC.tabBarItem.image = [UIImage imageNamed:@"Find.png"];
//    meNC.tabBarItem.image = [UIImage imageNamed:@"Me.png"];
                musicRecommendNC.tabBarItem.title = @"Daily";
                myMusicNC.tabBarItem.title = @"Mine";
                personalNC.tabBarItem.title = @"Account";
                tabBarController.viewControllers = @[musicRecommendNC, myMusicNC, personalNC];
                //to avoid lazyondemond.
                for (UIViewController *controller in tabBarController.viewControllers) {
                    UIView *view = controller.view;
                }
                NSLog(@"get here");
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
