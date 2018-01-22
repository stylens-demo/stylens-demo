//
//  AloNavi.m
//  TestApp
//
//  Created by 기대 여 on 2016. 4. 7..
//  Copyright © 2016년 기대 여. All rights reserved.
//

#import "AloNavi.h"

#import "AloViewController.h"
#import "AloBackItemView.h"

#define cXVelocityToSwipeBack 100.0
@interface AloNavi ()

@end

@implementation AloNavi


-(id)initWithScreenSize:(CGSize)aScreenSize withStartInterfaceOrientation:(UIInterfaceOrientation)aStartOrientation {
    
    self = [super init];
    
    if( self ) {
        
        /*
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            _swipeFactor = 30;
        } else {
            _swipeFactor = 15;
        }
         */
        
        _viewControllers = [[NSMutableArray alloc] init];
        
        
        CGFloat longSide;
        CGFloat shortSide;
        
        if( aScreenSize.width > aScreenSize.height) {
            longSide = aScreenSize.width;
            shortSide = aScreenSize.height;
        } else {
            longSide = aScreenSize.height;
            shortSide = aScreenSize.width;
        }
        
        
        _portFrame = CGRectMake(0, 0, shortSide, longSide);
        _landFrame = CGRectMake(0, 0, longSide, shortSide);
        
        // view를 load하기 위해서
        //self.view.backgroundColor = [UIColor whiteColor];
        //[self willRotateToInterfaceOrientation:aStartOrientation duration:0];
    }
    
    return self;
}

-(id)initWithPortSize:(CGSize)aPortSize LandSize:(CGSize)aLandSize withStartInterfaceOrientation:(UIInterfaceOrientation)aStartOrientation {
    
    self = [super init];
    
    if( self ) {
        
        /*
         if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
         _swipeFactor = 30;
         } else {
         _swipeFactor = 15;
         }
         */
        
        _viewControllers = [[NSMutableArray alloc] init];
        
        _portFrame = CGRectMake(0, 0, aPortSize.width, aPortSize.height);
        _landFrame = CGRectMake(0, 0, aLandSize.width, aLandSize.height);
        
        // view를 load하기 위해서
        //self.view.backgroundColor = [UIColor whiteColor];
        //[self willRotateToInterfaceOrientation:aStartOrientation duration:0];
    }
    
    return self;
    
}

-(void)loadView {
 
    UIView* aView = nil;
    
    if( UIInterfaceOrientationIsPortrait(self.curInterfaceOrientation) == YES || self.curInterfaceOrientation == UIInterfaceOrientationUnknown ) {
        aView = [[UIView alloc] initWithFrame:self.portFrame];
    } else {
        aView = [[UIView alloc] initWithFrame:self.landFrame];
    }
    self.view = aView;
//    [aView release], aView = nil;
    aView = nil;
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)dealloc {
    
    self.baseToolbar = nil;
    self.bottomViewToolbar = nil;
    self.topViewToolbar = nil;
    
    self.viewControllers = nil;
    
//    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark View Management
-(void)pushViewController:(AloViewController*)viewController animated:(BOOL)animated {
    
    if( self.bAnimating == YES ) {
        return;
    }
    self.bAnimating = YES;
    
    viewController.aloNavi = self;
    
    [self.view addSubview:viewController.view];
    [self.viewControllers addObject:viewController];
    
    if( [self.viewControllers count] <= 1 ) {
        
        viewController.toolbar.backItemView.hidden = YES;
        self.bAnimating = NO;
        return;
    }
    
    
    [viewController willRotateToInterfaceOrientation:self.curInterfaceOrientation duration:0];
    
    viewController.toolbar.backItemView.hidden = NO;
    
    if( animated == YES ) {
        
        NSInteger curViewIndex = [self.viewControllers count] -2;
        NSInteger newViewIndex = [self.viewControllers count] -1;
        
        AloViewController* curViewController = [self.viewControllers objectAtIndex:curViewIndex];
        AloViewController* newViewController = [self.viewControllers objectAtIndex:newViewIndex];
        
        
        __block UIView* baseToolbar = nil;
        UIView* curViewToolbar = nil;
        
        if( curViewController.bNotUseToolbar == NO  ) {
            baseToolbar = [[UIView alloc] initWithFrame:curViewController.toolbar.frame];
            baseToolbar.backgroundColor = curViewController.toolbar.backgroundColor;
            [self.view addSubview:baseToolbar];
        
            [curViewController.toolbar snapshotViewAfterScreenUpdates:NO];
            curViewController.toolbar.hidden = YES;
            [self.view addSubview:curViewToolbar];
        }
        
        UIView* newViewToolbar = nil;
        
        if( newViewController.bNotUseToolbar == NO ) {
            newViewToolbar = [newViewController.toolbar snapshotViewAfterScreenUpdates:YES];
            newViewController.toolbar.hidden = YES;
            [self.view addSubview:newViewToolbar];
            newViewToolbar.alpha = 0;
        }
        
        
        __block CGRect curViewRect = curViewController.view.frame;
        
        __block CGRect newViewRect = newViewController.view.frame;
        newViewRect.origin.x += newViewRect.size.width;
        newViewController.view.frame = newViewRect;
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             
                             curViewRect = curViewController.view.frame;
                             curViewRect.origin.x = -curViewRect.size.width * cBottomViewMoveRatio;
                             curViewController.view.frame = curViewRect;
                             
                             newViewRect = newViewController.view.frame;
                             newViewRect.origin.x -= newViewRect.size.width;
                             newViewController.view.frame = newViewRect;
                             
                             curViewToolbar.alpha = 0;
                             newViewToolbar.alpha = 1;
                             
                         } completion:^(BOOL finished) {
                             
                             
                             curViewController.toolbar.hidden = NO;
                             curViewToolbar.alpha = 1.0;
                             [curViewToolbar removeFromSuperview];
                            
                             
                             newViewController.toolbar.hidden = NO;
                             [newViewToolbar removeFromSuperview];
                            
                             [baseToolbar removeFromSuperview];
//                             [baseToolbar release], baseToolbar = nil;
                             baseToolbar = nil;
                             
                             self.bAnimating = NO;
                         }];
        
        
    } else {
        
        
        self.bAnimating = NO;
    }
}

-(void)popViewCointroller:(BOOL)animated {
    
    if( [self.viewControllers count] == 0 ) {
        return;
    }
    
    
    
    
    if( animated == YES ) {
        
        
        NSInteger curViewIndex = [self.viewControllers count] -2;
        NSInteger newViewIndex = [self.viewControllers count] -1;
        
        AloViewController* curViewController = [self.viewControllers objectAtIndex:curViewIndex];
        AloViewController* newViewController = [self.viewControllers objectAtIndex:newViewIndex];
        
        
        __block UIView* baseToolbar = nil;
        UIView* curViewToolbar = nil;
        
        if( curViewController.bNotUseToolbar == NO ) {
            baseToolbar = [[UIView alloc] initWithFrame:curViewController.toolbar.frame];
            baseToolbar.backgroundColor = curViewController.toolbar.backgroundColor;
            [self.view addSubview:baseToolbar];
            
            curViewToolbar = [curViewController.toolbar snapshotViewAfterScreenUpdates:NO];
            curViewController.toolbar.hidden = YES;
            [self.view addSubview:curViewToolbar];
            curViewToolbar.alpha = 0;
        }
        
        UIView* newViewToolbar = nil;
        
        if( newViewController.bNotUseToolbar == NO ) {
            newViewToolbar = [newViewController.toolbar snapshotViewAfterScreenUpdates:YES];
            newViewController.toolbar.hidden = YES;
            [self.view addSubview:newViewToolbar];
            newViewToolbar.alpha = 1;
        }
        
        
        __block CGRect curViewRect = curViewController.view.frame;
        __block CGRect newViewRect = newViewController.view.frame;
        
        // call back
        [curViewController viewWillAppear:YES];
        //[newViewController viewWillDisappear:YES];
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             
                             
                             
                             curViewRect = curViewController.view.frame;
                             curViewRect.origin.x = 0;
                             curViewController.view.frame = curViewRect;
                             
                             newViewRect = newViewController.view.frame;
                             newViewRect.origin.x += newViewRect.size.width;
                             newViewController.view.frame = newViewRect;
                             
                             curViewToolbar.alpha = 1;
                             newViewToolbar.alpha = 0;
                             
                         } completion:^(BOOL finished) {
                             
                             
                             curViewController.toolbar.hidden = NO;
                             [curViewToolbar removeFromSuperview];
                             
                             // call back
                             [curViewController viewDidAppear:YES];
                             
                             newViewController.toolbar.hidden = NO;
                             newViewToolbar.alpha = 1;
                             [newViewToolbar removeFromSuperview];
                             
                             // call back
                             [newViewController viewDidDisappear:YES];
                             
                             [baseToolbar removeFromSuperview];
//                             [baseToolbar release], baseToolbar = nil;
                             baseToolbar = nil;
                             
                             
                             AloViewController* aViewController = [self.viewControllers lastObject];
                             [aViewController.view removeFromSuperview];
                             [self.viewControllers removeLastObject];
                             
                             self.bAnimating = NO;
                             self.bSwipingView = NO;
                         }];
        
    } else {
        
        AloViewController* aViewController = [self.viewControllers lastObject];
        [aViewController.view removeFromSuperview];
        [self.viewControllers removeLastObject];
        
        self.bAnimating = NO;
        self.bSwipingView = NO;
    }
    
}

-(void)startPan {
    
    if( [self.viewControllers count] < 2) {
        return;
    }
    
    self.bPanningView = YES;
    
    NSInteger curViewIndex = [self.viewControllers count] -2;
    NSInteger newViewIndex = [self.viewControllers count] -1;
    
    AloViewController* curViewController = [self.viewControllers objectAtIndex:curViewIndex];
    AloViewController* newViewController = [self.viewControllers objectAtIndex:newViewIndex];
    
    
    
    if( self.baseToolbar ) {
        [self.baseToolbar removeFromSuperview];
        self.baseToolbar = nil;
    }
    
    if( curViewController.bNotUseToolbar == NO ) {
        _baseToolbar = [[UIView alloc] initWithFrame:curViewController.toolbar.frame];
        self.baseToolbar.backgroundColor = curViewController.toolbar.backgroundColor;
        [self.view addSubview:self.baseToolbar];
    }
    
    
    
    if( self.bottomViewToolbar ) {
        [self.bottomViewToolbar removeFromSuperview];
        self.bottomViewToolbar = nil;
    }
    
    if( curViewController.bNotUseToolbar == NO ) {
        self.bottomViewToolbar = [curViewController.toolbar snapshotViewAfterScreenUpdates:YES];
        [self.view addSubview:self.bottomViewToolbar];
        self.bottomViewToolbar.alpha = 0;
    }
    
    
    if( self.topViewToolbar ) {
        [self.topViewToolbar removeFromSuperview];
        self.topViewToolbar = nil;
    }
    
    if( newViewController.bNotUseToolbar == NO ) {
        self.topViewToolbar = [newViewController.toolbar snapshotViewAfterScreenUpdates:YES];
        newViewController.toolbar.hidden = YES;
        [self.view addSubview:self.topViewToolbar];
        self.topViewToolbar.alpha = 1;
    }
    
    
}

-(void)panWithTranslationX:(CGFloat)translationX {
    
    if( [self.viewControllers count] < 2) {
        return;
    }
    
    if( self.bSwipingView == YES ) {
        return;
    }
    
    /*
    if( translationX > self.swipeFactor ) {
        
        [self swipeView];
        return;
    }
     */
    
    
    //NSLog(@"trans x: %f", translationX);
    
    NSInteger curViewIndex = [self.viewControllers count] -2;
    NSInteger newViewIndex = [self.viewControllers count] -1;
    
    AloViewController* curViewController = [self.viewControllers objectAtIndex:curViewIndex];
    AloViewController* newViewController = [self.viewControllers objectAtIndex:newViewIndex];
    
    
    CGRect newViewRect = newViewController.view.frame;
    newViewRect.origin.x += translationX;
    if( newViewRect.origin.x > 0 ) {
        newViewController.view.frame = newViewRect;
    } else {
        return;
    }
    
    CGRect curViewRect = curViewController.view.frame;
    curViewRect.origin.x +=  curViewRect.size.width * cBottomViewMoveRatio * (translationX)/newViewController.view.frame.size.width;
    curViewController.view.frame = curViewRect;
    
    
    // tool bar
    // bottom 1 -> 0
    // top 0 -> 1
    self.bottomViewToolbar.alpha = newViewController.view.frame.origin.x / newViewController.view.frame.size.width;
    self.topViewToolbar.alpha = 1.0 - newViewController.view.frame.origin.x / newViewController.view.frame.size.width;
}


// todo
// pan animation의 animating 체크

-(void)finishPanWithXVelocity:(CGFloat)xVelocity {
    
    if( [self.viewControllers count] < 2) {
        return;
    }
    
    if( self.bAnimating == YES ) {
        return;
    }
    self.bAnimating = YES;
    
    if( self.bSwipingView == YES ) {
        return;
    }
    
    
    
    //NSLog(@"Finish Pan");
    
    self.bPanningView = NO;
    
    NSInteger curViewIndex = [self.viewControllers count] -2;
    NSInteger newViewIndex = [self.viewControllers count] -1;
    
    AloViewController* curViewController = [self.viewControllers objectAtIndex:curViewIndex];
    AloViewController* newViewController = [self.viewControllers objectAtIndex:newViewIndex];
    
    __block CGRect newViewRect = newViewController.view.frame;
    __block CGRect curViewRect = curViewController.view.frame;
    
    // calback
    [curViewController viewWillAppear:YES];
    //[newViewController viewWillDisappear:YES];
    
    if( newViewRect.origin.x < newViewRect.size.width/2.0 && xVelocity < cXVelocityToSwipeBack) {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             newViewRect.origin.x = 0;
                             newViewController.view.frame = newViewRect;
                             
                             curViewRect = curViewController.view.frame;
                             curViewRect.origin.x = -curViewRect.size.width * cBottomViewMoveRatio;
                             curViewController.view.frame = curViewRect;
                             
                             
                             self.bottomViewToolbar.alpha = 0;
                             self.topViewToolbar.alpha = 1;
                             
                         } completion:^(BOOL finished) {
                             
                             // tool bar
                             curViewController.toolbar.hidden = NO;
                             [self.bottomViewToolbar removeFromSuperview];
                             self.bottomViewToolbar = nil;
                             
                             // call back
                             [curViewController viewDidAppear:YES];
                             
                             
                             newViewController.toolbar.hidden = NO;
                             [self.topViewToolbar removeFromSuperview];
                             self.topViewToolbar = nil;
                             
                             [self.baseToolbar removeFromSuperview];
                             self.baseToolbar = nil;
                             
                             self.bAnimating = NO;
                             
                             // call back
                             [newViewController viewDidDisappear:YES];
                             
                         }];
        
    } else {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             // pop
                             curViewRect = curViewController.view.frame;
                             curViewRect.origin.x = 0;
                             curViewController.view.frame = curViewRect;
                             
                             newViewRect = newViewController.view.frame;
                             newViewRect.origin.x += newViewRect.size.width;
                             newViewController.view.frame = newViewRect;
                             
                             self.bottomViewToolbar.alpha = 1;
                             self.topViewToolbar.alpha = 0;
                             
                         } completion:^(BOOL finished) {
                             
                             
                             curViewController.toolbar.hidden = NO;
                             [self.bottomViewToolbar removeFromSuperview];
                             self.bottomViewToolbar = nil;
                             
                             // call back
                             [curViewController viewDidAppear:YES];
                             
                             
                             newViewController.toolbar.hidden = NO;
                             [self.topViewToolbar removeFromSuperview];
                             self.topViewToolbar = nil;
                             
                             [self.baseToolbar removeFromSuperview];
                             self.baseToolbar = nil;
                             
                             // call back
                             [newViewController viewDidDisappear:YES];
                             
                             AloViewController* aViewController = [self.viewControllers lastObject];
                             [aViewController.view removeFromSuperview];
                             [self.viewControllers removeLastObject];
                             
                             self.bAnimating = NO;
                         }];
        
    }
    
}

-(void)swipeView {
    
    if( self.bAnimating == YES ) {
        return;
    }
    
    self.bAnimating = YES;
    
    if( self.bSwipingView == YES ) {
        return;
    }
    
    self.bSwipingView = YES;
    
    NSLog(@"Swipe Pan");
    
    if( self.bPanningView == YES ) {
        
        self.bPanningView = NO;
        
        NSInteger curViewIndex = [self.viewControllers count] -2;
        NSInteger newViewIndex = [self.viewControllers count] -1;
        
        AloViewController* curViewController = [self.viewControllers objectAtIndex:curViewIndex];
        AloViewController* newViewController = [self.viewControllers objectAtIndex:newViewIndex];
        
        __block CGRect newViewRect = newViewController.view.frame;
        __block CGRect curViewRect = curViewController.view.frame;
        
        
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             // pop
                             curViewRect = curViewController.view.frame;
                             curViewRect.origin.x = 0;
                             curViewController.view.frame = curViewRect;
                             
                             newViewRect = newViewController.view.frame;
                             newViewRect.origin.x = newViewRect.size.width;
                             newViewController.view.frame = newViewRect;
                             
                             self.bottomViewToolbar.alpha = 1;
                             self.topViewToolbar.alpha = 0;
                             
                         } completion:^(BOOL finished) {
                             
                             
                             
                             curViewController.toolbar.hidden = NO;
                             [self.bottomViewToolbar removeFromSuperview];
                             self.bottomViewToolbar = nil;
                             
                             newViewController.toolbar.hidden = NO;
                             [self.topViewToolbar removeFromSuperview];
                             self.topViewToolbar = nil;
                             
                             [self.baseToolbar removeFromSuperview];
                             self.baseToolbar = nil;
                             
                             AloViewController* aViewController = [self.viewControllers lastObject];
                             [aViewController.view removeFromSuperview];
                             [self.viewControllers removeLastObject];
                             
                             self.bAnimating = NO;
                             self.bSwipingView = NO;
                         }];
        
                
    } else {
        
        
        [self popViewCointroller:YES];
    }
    
    
}

#pragma mark -
#pragma mark Orientaiotn
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    self.curInterfaceOrientation = toInterfaceOrientation;
    
    
    if( UIInterfaceOrientationIsPortrait(self.curInterfaceOrientation ) == YES || self.curInterfaceOrientation == UIInterfaceOrientationUnknown ) {
        
        self.view.frame = self.portFrame;
    } else {
        
        self.view.frame = self.landFrame;
    }
    
    
    for(AloViewController* aViewController in self.viewControllers ) {
        [aViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
    
}

#pragma mark -
#pragma mark Util
-(UIImage*)captureView:(UIView*)aView {
    
    CGRect rect = [aView bounds];
    NSLog(@"rect: %@", NSStringFromCGRect(rect));
    
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [aView.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return capturedImage;
}

@end
