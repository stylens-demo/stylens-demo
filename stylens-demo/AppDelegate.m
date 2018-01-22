//
//  AppDelegate.m
//  stylens-demo
//
//  Created by 김대섭 on 2017. 12. 28..
//  Copyright © 2017년 Bluehack Inc. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self configScreen];
    
    return YES;
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
}

#pragma mark -
#pragma mark Internal
-(void)configScreen {
    
    _scType = [Global screenType];
    _screenRect = [Global screenRect];
    
    
    // width and hieght ratio
    /*
     SC_TYPE_3_5,
     SC_TYPE_4,
     SC_TYPE_4_7,
     SC_TYPE_5_5,
     
     SC_TYPE_iPad
     */
    CGSize baseSize = CGSizeMake(375, 667);
    
    if( self.scType == SC_TYPE_3_5) {
        
        self.widthRatio = 320.0/baseSize.width;
        self.heightRatio = 480.0/baseSize.height;
        
        
    } else if( self.scType == SC_TYPE_4) {
        
        self.widthRatio = 320.0/baseSize.width;
        self.heightRatio = 568.0/baseSize.height;
        
    } else if( self.scType == SC_TYPE_4_7) {
        
        self.widthRatio = 375.0/baseSize.width;
        self.heightRatio = 667.0/baseSize.height;
        
    } else if( self.scType == SC_TYPE_5_5) {
        
        self.widthRatio = 414.0/baseSize.width;
        self.heightRatio = 736.0/baseSize.height;
        
    } else if( self.scType == SC_TYPE_9_7 ) {
        
        self.widthRatio = 768.0/baseSize.width;
        self.heightRatio = 1024.0/baseSize.height;
        
    } else if( self.scType == SC_TYPE_12_9 ) {
        
        self.widthRatio = 1024.0/baseSize.width;
        self.heightRatio = 1366.0/baseSize.height;
        
    } else {
        
        self.widthRatio = 1.0;
        self.heightRatio = 1.0;
    }
}

@end

