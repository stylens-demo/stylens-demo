//
//  AloNavi.h
//  TestApp
//
//  Created by 기대 여 on 2016. 4. 7..
//  Copyright © 2016년 기대 여. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AloViewController;

@interface AloNavi : UIViewController


@property (nonatomic, retain) NSMutableArray* viewControllers;

//@property (nonatomic, readonly) CGFloat swipeFactor;
@property (nonatomic, readonly) CGRect portFrame;
@property (nonatomic, readonly) CGRect landFrame;
@property (nonatomic, assign) UIInterfaceOrientation curInterfaceOrientation;

@property (nonatomic, assign) BOOL bAnimating;

// for view animation
@property (nonatomic, retain) UIView* baseToolbar;
@property (nonatomic, retain) UIView* bottomViewToolbar;
@property (nonatomic, retain) UIView* topViewToolbar;

@property (nonatomic, assign) BOOL bPanningView;
@property (nonatomic, assign) BOOL bSwipingView;


// screen size로 만들 때는 전체 화면을 다 사용한다로 가정한다.
// view controller도 맞춰서 size로 만들어줘야한다.
-(id)initWithScreenSize:(CGSize)aScreenSize withStartInterfaceOrientation:(UIInterfaceOrientation)aStartOrientation;

// tab bar에 들어갈 때 고려
-(id)initWithPortSize:(CGSize)aPortSize LandSize:(CGSize)aLandSize withStartInterfaceOrientation:(UIInterfaceOrientation)aStartOrientation;



-(void)pushViewController:(AloViewController*)viewController animated:(BOOL)animated;
-(void)popViewCointroller:(BOOL)animated;

-(UIImage*)captureView:(UIView*)aView;

-(void)startPan;
-(void)panWithTranslationX:(CGFloat)translationX;
-(void)finishPanWithXVelocity:(CGFloat)xVelocity;

-(void)swipeView;

@end


#define cBottomViewMoveRatio (11.0/75.0)