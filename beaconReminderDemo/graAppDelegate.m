//
//  graAppDelegate.m
//  beaconReminderDemo
//
//  Created by li lin on 3/17/14.
//  Copyright (c) 2014 li lin. All rights reserved.
//

#import "graAppDelegate.h"
#import "iBeaconUser.h"
#import "reminderOnBeaconViewController.h"
#import "nearBeaconViewController.h"
#import "graBeaconManagerTableViewController.h"
@implementation graAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    

    // Override point for customization after application launch.
    nearBeaconViewController *beaconVC = [[nearBeaconViewController alloc] initWithNibName:@"nearBeaconViewController" bundle:nil];
    UINavigationController  *reminderNav = [[UINavigationController alloc] initWithRootViewController:beaconVC];
    reminderNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"提醒" image:nil selectedImage:nil];

    graBeaconManagerTableViewController *beaconMangerVC = [[graBeaconManagerTableViewController alloc] initWithNibName:@"graBeaconManagerTableViewController" bundle:nil];
    UINavigationController *beaconManagerNav = [[UINavigationController alloc] initWithRootViewController:beaconMangerVC];
    beaconManagerNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的Mozi" image:nil selectedImage:nil];
    
    UITabBarController *tabvc = [[UITabBarController alloc]  init];
    NSArray *tabArray = [NSArray arrayWithObjects:reminderNav, beaconManagerNav, nil];
    tabvc.viewControllers = tabArray;
    self.window.rootViewController = tabvc;
    iBeaconUser *beaconUser = [iBeaconUser sharedInstance];
    beaconUser.loggedIn = NO;
    self.user = beaconUser;
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    iBeaconUser *beaconUser = [iBeaconUser sharedInstance];
    [beaconUser saveAllData];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
