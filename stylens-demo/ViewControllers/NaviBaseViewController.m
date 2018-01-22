//
//  NaviBaseViewController.m
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 22..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import "NaviBaseViewController.h"

#import "AppDelegate.h"
#import "BaseViewController.h"

@interface NaviBaseViewController ()

@end

@implementation NaviBaseViewController

-(void)loadView {
    
    self.app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    UIView* aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.app.screenRect.size.width, self.app.screenRect.size.height)];
    self.view = aView;
    
    _indicatorViewController = [[IndicatorViewController alloc] init];
    self.indicatorViewController.superView = self.view;
    [self.view addSubview:self.indicatorViewController.view];
    self.indicatorViewController.view.hidden = YES;
    
    // alo navi
    self.naviController = [[AloNavi alloc] initWithScreenSize:self.app.screenRect.size withStartInterfaceOrientation:self.interfaceOrientation];
    [self.view addSubview:self.naviController.view];
    
    BaseViewController* baseViewController = [[BaseViewController alloc] initWithSize:self.app.screenRect.size];
    self.app.baseViewController = baseViewController;
    baseViewController.naviBaseViewController = self;
    [self.naviController pushViewController:baseViewController animated:NO];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self.app.baseViewController viewDidAppear:animated];
}

-(void)startIndicator {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self.indicatorViewController startIndicator];
}

-(void)stopIndicator {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self.indicatorViewController stopIndicator];
}

@end
