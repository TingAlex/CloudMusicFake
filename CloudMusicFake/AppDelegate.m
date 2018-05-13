//
//  AppDelegate.m
//  CloudMusicFake
//
//  Created by OurEDA on 2018/4/24.
//  Copyright © 2018年 OurEDA. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
NSMutableArray *playingList;
NSInteger playingIndex;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Bmob registerWithAppKey:@"ce94e7b2a412e84d71c28f8d8b1236f8"];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];

    BmobQuery *bquery = [BmobQuery queryWithClassName:@"_User"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"userPhone"] != nil && [userDefaults objectForKey:@"password"] != nil) {
        NSArray *array = @[@{@"mobilePhoneNumber": [userDefaults objectForKey:@"userPhone"]}, @{@"password": [userDefaults objectForKey:@"password"]}];
        [bquery addTheConstraintByAndOperationWithArray:array];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array1, NSError *error) {
            if (error) {
                NSLog(@"network error!");
            } else {
                if (array1.count == 1) {
                    NSLog(@"%@", [array1[0] objectForKey:@"mobilePhoneNumber"]);
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
                } else {
                    NSLog(@"need login!");
                    //TODO:need login part
                    UINavigationController *logOrSign = [[UINavigationController alloc] initWithRootViewController:[[LogOrSignViewController alloc] init]];
                    logOrSign.navigationBar.barTintColor = [UIColor redColor];
                    NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
                    [logOrSign.navigationBar setTitleTextAttributes:dict];
                    self.window.rootViewController = logOrSign;
                    self.window.backgroundColor = [UIColor whiteColor];
                    [self.window makeKeyAndVisible];
                }
            }
        }];
        HoldingViewController *holdingViewController = [[HoldingViewController alloc] init];
        self.window.rootViewController = holdingViewController;
        self.window.backgroundColor = [UIColor redColor];
        [self.window makeKeyAndVisible];
        return YES;
    } else {
        NSLog(@"need login!");
        //TODO:need login part
        UINavigationController *logOrSign = [[UINavigationController alloc] initWithRootViewController:[[LogOrSignViewController alloc] init]];
        logOrSign.navigationBar.barTintColor = [UIColor redColor];
        NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
        [logOrSign.navigationBar setTitleTextAttributes:dict];
        self.window.rootViewController = logOrSign;
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        return YES;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"CloudMusicFake"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }

    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
