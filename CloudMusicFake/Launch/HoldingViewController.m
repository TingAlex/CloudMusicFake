//
//  HoldingViewController.m
//  CloudMusicFake
//
//  Created by OurEDA on 2018/5/13.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import "HoldingViewController.h"

@interface HoldingViewController ()

@end

@implementation HoldingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect screen = [[UIScreen mainScreen] bounds];

    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
    bgImage.image = [UIImage imageNamed:@"LaunchImage.png"];
    [myView addSubview:bgImage];
    [self.view addSubview:myView];
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
