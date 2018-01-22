//
//  AppDelegate.h
//  stylens-demo
//
//  Created by 김대섭 on 2017. 12. 28..
//  Copyright © 2017년 Bluehack Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Global.h"

@class BaseViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// UI
@property (nonatomic, readonly) SC_TYPE scType;
@property (nonatomic, readonly) CGRect screenRect;

@property (nonatomic, assign) CGFloat widthRatio;
@property (nonatomic, assign) CGFloat heightRatio;

@property (nonatomic, assign) BaseViewController* baseViewController;

@end
