//
//  MusicRecommendViewController.h
//  CloudMusicFake
//
//  Created by OurEDA on 2018/5/7.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicPlayViewController.h"
#import <AFNetworking.h>
#import "AppDelegate.h"

@interface MusicRecommendViewController : UIViewController <UISearchBarDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate>

@end
