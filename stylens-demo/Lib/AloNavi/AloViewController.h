//
//  AloViewController.h
//  TestApp
//
//  Created by 기대 여 on 2016. 4. 7..
//  Copyright © 2016년 기대 여. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Global.h"
#import "AloToolbar.h"

@class AloNavi;
@class AppDelegate;

@interface AloViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, assign) AppDelegate* app;

@property (nonatomic, assign) AloNavi* aloNavi;

@property (nonatomic, retain) AloToolbar* toolbar;
@property (nonatomic, assign, setter=setBNotUseToolbar:, getter=bNotUseToolbar) BOOL bNotUseToolbar;

@property (nonatomic, readonly) CGRect portFrame;
@property (nonatomic, readonly) CGRect landFrame;


@property (nonatomic, assign) CGFloat portToolbarHeight;
@property (nonatomic, assign) CGFloat landToolbarHeight;

@property (nonatomic, retain) UIView* bodyView;
@property (nonatomic, retain) UIImageView* bodyBgImageView;
@property (nonatomic, retain, setter=setBgImage:, getter=bgImage) UIImage* bgImage;
@property (nonatomic, retain) UIImage* bodyPortBGImage;
@property (nonatomic, retain) UIImage* bodyLandBGImage;


@property (nonatomic, assign) BOOL bFirstPan;
@property (nonatomic, assign) BOOL bPanForBackStarted;

@property (nonatomic, assign) BOOL bShowToolbar;

@property (nonatomic, assign) BOOL bUsePanGesture;

// screen size로 만들 때는 전체 화면을 다 사용한다로 가정한다.
-(id)initWithSize:(CGSize)aSize;
-(void)setSize:(CGSize)aSize;

-(id)initWithPortSize:(CGSize)aPortSize LandSize:(CGSize)aLandSize;

-(void)backItemTapped;

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end
