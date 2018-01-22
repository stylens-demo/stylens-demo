//
//  BHTabbar.m
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 21..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import "BHTabbar.h"

#import "AppDelegate.h"
#import "BaseViewController.h"

@implementation BHTabbar

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        self.app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        self.backgroundColor = [UIColor whiteColor];
        
        CGSize aButtonSize = CGSizeMake(36*self.app.widthRatio, 36*self.app.heightRatio);
        UIButton* aButton;
        
        CGFloat curX = 0;
        CGFloat curY = 9*self.app.heightRatio;
        
        curX = 64*self.app.widthRatio;
        
        // home button
        aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aButton.frame = CGRectMake(curX, curY, aButtonSize.width, aButtonSize.height);
        [aButton setImage:[UIImage imageNamed:@"btnHomeSel"] forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(homeTabClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:aButton];
        self.homeButton = aButton;
        
        curX = self.frame.size.width/2 - aButtonSize.width/2;
        
        // camera button
        aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aButton.frame = CGRectMake(curX, curY, aButtonSize.width, aButtonSize.height);
        [aButton setImage:[UIImage imageNamed:@"btnCameraNor"] forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(cameraTabClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:aButton];
        self.cameraButton = aButton;
        
        curX = self.frame.size.width - 64*self.app.widthRatio - aButtonSize.width;
        
        // gallary button
        aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aButton.frame = CGRectMake(curX, curY, aButtonSize.width, aButtonSize.height);
        [aButton setImage:[UIImage imageNamed:@"btnGalleryNor"] forState:UIControlStateNormal];
//        [aButton addTarget:self action:@selector(communityTabClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:aButton];
        self.galleryButton = aButton;
        
        aButton = nil;
    }
    return self;
}

-(void)updateMenus {
    [self.homeButton setImage:[UIImage imageNamed:@"btnHomeNor"] forState:UIControlStateNormal];
    [self.cameraButton setImage:[UIImage imageNamed:@"btnCameraNor"] forState:UIControlStateNormal];
    [self.galleryButton setImage:[UIImage imageNamed:@"btnGalleryNor"] forState:UIControlStateNormal];
    
    if (self.app.baseViewController.curViewController == (UIViewController*)self.app.baseViewController.homeViewController) {
       [self.homeButton setImage:[UIImage imageNamed:@"btnHomeSel"] forState:UIControlStateNormal];
    } else if (self.app.baseViewController.curViewController == (UIViewController*)self.app.baseViewController.cameraViewController) {
       [self.cameraButton setImage:[UIImage imageNamed:@"btnCameraSel"] forState:UIControlStateNormal];
    }
    // TODO
    // updateMenus for GalleryViewController.
}

-(void)homeTabClicked:(id)sender {
    [self.app.baseViewController showHomeView];
    [self updateMenus];
}

-(void)cameraTabClicked:(id)sender {
    [self.app.baseViewController showCameraView];
    [self updateMenus];
}

+(CGFloat)height {
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return 54 * app.heightRatio;
}

@end
