//
//  AppDelegate.h
//  CloudMusicFake
//
//  Created by OurEDA on 2018/4/24.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <BmobSDK/Bmob.h>
#import "MyCollectionViewController.h"
#import "PersonalViewController.h"
#import "LogOrSignViewController.h"
#import "MusicRecommendViewController.h"
#import "HoldingViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;

@property(readonly, strong) NSPersistentContainer *persistentContainer;
@property(strong, nonatomic) NSMutableArray *playingList;
@property(nonatomic) NSInteger playingIndex;

- (void)saveContext;


@end

