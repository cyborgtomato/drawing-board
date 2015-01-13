//
//  AppDelegate.m
//  DrawingBoard
//
//  Created by Sergei Smagleev on 07/11/14.
//  Copyright (c) 2014 Sergei Smagleev. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *mainVC = [[ViewController new] autorelease];
    self.window.rootViewController = [[[UINavigationController alloc] initWithRootViewController:mainVC] autorelease];;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
