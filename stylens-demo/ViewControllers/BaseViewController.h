//
//  BaseViewController.h
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 21..
//  Copyright © 2017년 김대섭. All rights reserved.
//

//#define statusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define statusBarHeight 20

//static int statusBarHeight = 20;

#import <UIKit/UIKit.h>

#import "AloViewController.h"

#import "DataManager.h"

@class NaviBaseViewController;
@class BHTabbar;

@class HomeViewController;
@class CameraViewController;

@interface BaseViewController : AloViewController

@property (nonatomic, strong) DataManager* dataManager;

@property (nonatomic, weak) NaviBaseViewController* naviBaseViewController;
@property (nonatomic, strong) BHTabbar* tabbar;

@property (nonatomic, weak) UIViewController* curViewController;
@property (nonatomic, strong) HomeViewController* homeViewController;
@property (nonatomic, strong) CameraViewController* cameraViewController;

-(void)showHomeView;
-(void)showCameraView;

-(void)startIndicator;
-(void)stopIndicator;

@end
