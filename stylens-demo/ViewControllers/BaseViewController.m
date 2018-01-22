//
//  BaseViewController.m
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 21..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import "BaseViewController.h"

#import "AppDelegate.h"
#import "DataManager.h"
#import "NaviBaseViewController.h"

#import "BHTabbar.h"
#import "HomeViewController.h"
#import "CameraViewController.h"

#import "SampleViewController.h"



@interface BaseViewController ()

@end

@implementation BaseViewController

-(void)loadView {
    
    [super loadView];
    
//    NSLog(@"StatusBar Height : %f",  [[UIApplication sharedApplication] statusBarFrame].size.height);
    
    self.app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.toolbar.backgroundColor = [UIColor clearColor];
    
    self.dataManager = [[DataManager alloc] init];
    
    // tabbar
    CGFloat tabbarHeight = [BHTabbar height];
//    _tabbar = [[BHTabbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - tabbarHeight, self.view.frame.size.width, tabbarHeight)];
    _tabbar = [[BHTabbar alloc] initWithFrame:CGRectMake(0, self.app.screenRect.size.height - tabbarHeight, self.view.frame.size.width, tabbarHeight)];
    [self.view addSubview:self.tabbar];
    
    // homeViewController
    _homeViewController = [[HomeViewController alloc] initWithFrame:CGRectMake(0, statusBarHeight*self.app.heightRatio, self.view.frame.size.width, self.view.frame.size.height - self.tabbar.frame.size.height - statusBarHeight*self.app.heightRatio)];
    [self.view addSubview:self.homeViewController.view];
    [self.homeViewController processFeedApi];
    self.curViewController = self.homeViewController;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Sharing Activity
    NSUserDefaults *defauls = [[NSUserDefaults alloc] initWithSuiteName:@"group.stylens.share.extension"];
    NSDictionary *dict = [defauls valueForKey:@"img"];
    if (dict) {
        NSData *imgData = [dict valueForKey:@"imgData"];
        
        SampleViewController *aNewViewPush = [[SampleViewController alloc] initWithSize:self.app.screenRect.size];
        [self.app.baseViewController.aloNavi pushViewController:aNewViewPush animated:YES];
        aNewViewPush.myImage = [UIImage imageWithData:imgData];
        
        [defauls removeObjectForKey:@"img"];
    }
}

#pragma mark View Management
-(void)showHomeView {
    if (self.curViewController == self.homeViewController) {
        return;
    }
    
    if (self.homeViewController == nil) {
        self.homeViewController = [[HomeViewController alloc] initWithFrame:CGRectMake(0, statusBarHeight*self.app.heightRatio, self.view.frame.size.width, self.view.frame.size.height - self.tabbar.frame.size.height - statusBarHeight*self.app.heightRatio)];
        [self.view addSubview:self.homeViewController.view];
    }
    
    self.curViewController.view.hidden  = YES;
    self.homeViewController.view.hidden = NO;
    [self.homeViewController processFeedApi];
    self.curViewController = self.homeViewController;
}

-(void)showCameraView {
    if (self.curViewController == self.cameraViewController) {
        return;
    }
    
    if (self.cameraViewController == nil) {
        self.cameraViewController = [[CameraViewController alloc] initWithFrame:CGRectMake(0, statusBarHeight*self.app.heightRatio, self.view.frame.size.width, self.view.frame.size.height - self.tabbar.frame.size.height - statusBarHeight*self.app.heightRatio)];
        [self.view addSubview:self.cameraViewController.view];
    }
    
    self.curViewController.view.hidden  = YES;
    self.cameraViewController.view.hidden = NO;
    //    [self.homeViewController processItemCheckData];
    [self.cameraViewController startCaptureSession];
    self.curViewController = self.cameraViewController;
}

#pragma mark - Indicator
-(void)startIndicator {
    [self.naviBaseViewController startIndicator];
}

-(void)stopIndicator {
    [self.naviBaseViewController stopIndicator];
}

@end
