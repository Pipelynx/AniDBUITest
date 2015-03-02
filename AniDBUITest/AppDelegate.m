//
//  AppDelegate.m
//  AniDBUITest
//
//  Created by Martin Fellner on 16.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "AppDelegate.h"
#import "MWLogging.h"
#import "ADBPersistentConnection.h"

@interface AppDelegate ()

@property (strong, nonatomic) ADBPersistentConnection *anidb;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    MWLogDebug(@"application:didFinishLaunchingWithOptions:");
    [application setMinimumBackgroundFetchInterval:1];
    self.anidb = [ADBPersistentConnection sharedConnection];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    MWLogDebug(@"applicationDidEnterBackground:");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    MWLogDebug(@"applicationWillEnterForeground:");
    if (![self.anidb checkSession]) {
        [self.anidb loginWithUsername:[[NSUserDefaults standardUserDefaults] valueForKey:@"username_preference"] andPassword:[[NSUserDefaults standardUserDefaults] valueForKey:@"password_preference"]];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    MWLogDebug(@"applicationDidBecomeActive:");
    if (![self.anidb isKeepingAlive]) {
        [self.anidb startKeepAliveWithInterval:60];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    MWLogDebug(@"applicationWillTerminate:");
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    return NO;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    return NO;
}

@end
