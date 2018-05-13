//
//  LogOrSignViewController.m
//  WYY
//
//  Created by OurEDA on 2018/4/26.
//  Copyright © 2018年 123. All rights reserved.
//

#import "LogOrSignViewController.h"

@interface LogOrSignViewController ()

@end

@implementation LogOrSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect screen = [[UIScreen mainScreen] bounds];

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.frame = CGRectMake(20, 150, screen.size.width - 40, 30);
    [btn1 setTitle:@"手机号登录" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:20];
    [btn1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    btn1.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:btn1];

    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn2.frame = CGRectMake(20, 200, screen.size.width - 40, 30);
    [btn2 setTitle:@"注册" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:20];
    [btn2 addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
    btn2.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:btn2];
}

- (void)btn1Click:(id)sender {
    LoginViewController *login = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];
}

- (void)btn2Click:(id)sender {
    SignUpViewController *signUp = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:signUp animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
