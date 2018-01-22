//
//  AloViewController.m
//  TestApp
//
//  Created by 기대 여 on 2016. 4. 7..
//  Copyright © 2016년 기대 여. All rights reserved.
//

#import "AloViewController.h"

#import "AppDelegate.h"
#import "AloNavi.h"


@interface AloViewController ()

@end

@implementation AloViewController

-(void)setUp {
    
    self.app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    self.portToolbarHeight = 44 + 20;
    self.landToolbarHeight = 32;
    
    self.bShowToolbar = YES;
    
    self.bUsePanGesture = YES;
}

-(id)initWithSize:(CGSize)aSize {
 
    self = [super init];
 
    if( self ) {
        
        CGFloat longSide;
        CGFloat shortSide;
        
        if( aSize.width > aSize.height) {
            longSide = aSize.width;
            shortSide = aSize.height;
        } else {
            longSide = aSize.height;
            shortSide = aSize.width;
        }
        
        _portFrame = CGRectMake(0, 0, shortSide, longSide);
        _landFrame = CGRectMake(0, 0, longSide, shortSide);
        
        [self setUp];
    }
    
    return self;
}

-(void)setSize:(CGSize)aSize {
    
    CGFloat longSide;
    CGFloat shortSide;
    
    if( aSize.width > aSize.height) {
        longSide = aSize.width;
        shortSide = aSize.height;
    } else {
        longSide = aSize.height;
        shortSide = aSize.width;
    }
    
    _portFrame = CGRectMake(0, 0, shortSide, longSide);
    _landFrame = CGRectMake(0, 0, longSide, shortSide);
    
    self.portToolbarHeight = 44 + 20;
    self.landToolbarHeight = 32;
    
}

-(id)initWithPortSize:(CGSize)aPortSize LandSize:(CGSize)aLandSize {
    
    self = [super init];
    
    if( self ) {
        
        _portFrame = CGRectMake(0, 0, aPortSize.width, aPortSize.height);
        _landFrame = CGRectMake(0, 0, aLandSize.width, aLandSize.height);
        
        [self setUp];
    }
    
    return self;
}

-(void)loadView {

    UIView* aView = [[UIView alloc] initWithFrame:self.portFrame];
    self.view = aView;
//    [aView release], aView = nil;
    aView = nil;

    if( self.bShowToolbar == YES) {
        _toolbar = [[AloToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.portToolbarHeight)];
        [self.view addSubview:self.toolbar];
        self.toolbar.aloViewCotroller = self;
        
        _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.toolbar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.toolbar.frame.size.height)];
        
    } else {
        
        _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
    }
    
    [self.view addSubview:self.bodyView];
    
    
    // bg view
    _bodyBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bodyView.frame.size.width, self.bodyView.frame.size.height)];
    [self.bodyView addSubview:self.bodyBgImageView];
    
    /*
    // swipe gesture
    UISwipeGestureRecognizer* swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipePiece:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    swipeGesture.delegate = self;
    [self.view addGestureRecognizer:swipeGesture];
    [swipeGesture release], swipeGesture = nil;
    */
    
    // pan
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
//    [panGesture release], panGesture = nil;
    panGesture = nil;
}


-(void)dealloc {

    self.bodyPortBGImage = nil;
    self.bodyLandBGImage = nil;
    self.bodyBgImageView = nil;
    self.bgImage = nil;
    
    self.bodyView = nil;
    self.toolbar = nil;
    
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

-(void)backItemTapped {
    
    [self.aloNavi popViewCointroller:YES];
}


#pragma mark -
#pragma mark Gesture

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return self.bUsePanGesture;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
// scale and rotation transforms are applied relative to the layer's anchor point
// this method moves a gesture recognizer's view's anchor point between the user's fingers
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

-(void)swipePiece:(UITapGestureRecognizer*)gesture {
    NSLog(@"swipe....");
    //[self backItemTapped];
    [self.aloNavi swipeView];
}

-(void)panPiece:(UIPanGestureRecognizer*)gestureRecognizer {

    
    
    UIView* piece = gestureRecognizer.view;
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    
    CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
    
    
    if( [gestureRecognizer state] == UIGestureRecognizerStateBegan ) {
        
        
        self.bFirstPan = YES;
        self.bPanForBackStarted = NO;
        
        //NSLog(@"start trans x: %f y: %f", translation.x, translation.y);
        
    } else if ( [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        if( self.bFirstPan == YES ) {
            
            if( translation.x > fabs(translation.y)) {
                self.bPanForBackStarted = YES;
                [self.aloNavi startPan];
            } else {
                
            }
            self.bFirstPan = NO;
            
        } else {
        }
        
        if( self.bPanForBackStarted == YES ) {
            [self.aloNavi panWithTranslationX:translation.x];
        }
        //NSLog(@"trans x: %f y: %f", translation.x, translation.y);
        
    } else {
        
        NSLog(@"x velocity: %f",
              [gestureRecognizer velocityInView:self.view].x);
        if( self.bPanForBackStarted == YES ) {
            
            [self.aloNavi finishPanWithXVelocity:[gestureRecognizer velocityInView:self.view].x];
        }
        
    }
    
    [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    
    
}


#pragma mark -
#pragma mark Orientation

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    CGRect toolbarRect = self.toolbar.frame;
    
    if( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) == YES || toInterfaceOrientation == UIInterfaceOrientationUnknown) {
        
        self.view.frame = self.portFrame;
    
        toolbarRect.size.height = self.portToolbarHeight;
        
        
        self.bodyBgImageView.image = self.bodyPortBGImage;
        
    } else {
        
        self.view.frame = self.landFrame;
        
        toolbarRect.size.height = self.landToolbarHeight;
        
        self.bodyBgImageView.image = self.bodyLandBGImage;
    }
    
    if( self.bShowToolbar == YES ) {
        toolbarRect.size.width = self.view.frame.size.width;
        self.toolbar.frame = toolbarRect;
        [self.toolbar willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
        
        self.bodyView.frame = CGRectMake(0, self.toolbar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.toolbar.frame.size.height);
        
        
    } else {
        
        self.bodyView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.bodyBgImageView.frame = CGRectMake(0, 0, self.bodyView.frame.size.width, self.bodyView.frame.size.height);
}

#pragma mark -
#pragma mark Setter
-(void)setBgImage:(UIImage *)aBgImage {
    
    if( self.bgImage ) {
//        [_bgImage release], _bgImage = nil;
        _bgImage = nil;
    }
    
    if( aBgImage == nil ) {
        
        self.bodyBgImageView.image = nil;
        self.bodyPortBGImage = nil;
        self.bodyLandBGImage = nil;
        return;
    }
    
#if !__has_feature(objc_arc)
    _bgImage = [aBgImage retain];
#else
    _bgImage = aBgImage;
#endif
    
    CGRect portBodyViewRect;
    CGRect landBodyViewRect;
    
    if( self.bShowToolbar == YES ) {
        
        // port
        portBodyViewRect = CGRectMake(0, self.portToolbarHeight, self.portFrame.size.width, self.portFrame.size.height - self.portToolbarHeight);
        
        // land
        portBodyViewRect = CGRectMake(0, self.landToolbarHeight, self.landFrame.size.width, self.landFrame.size.height - self.landToolbarHeight);
        
    } else {
        
        // port
        portBodyViewRect = CGRectMake(0, 0, self.portFrame.size.width, self.portFrame.size.height);
        
        // land
        portBodyViewRect = CGRectMake(0, 0, self.landFrame.size.width, self.landFrame.size.height);
    }
    
    self.bodyPortBGImage = [Global resizeAndAdjustCropImage:self.bgImage ToRect:CGRectMake(0, 0, portBodyViewRect.size.width*2, portBodyViewRect.size.height*2)];
    self.bodyLandBGImage = [Global resizeAndAdjustCropImage:self.bgImage ToRect:CGRectMake(0, 0, landBodyViewRect.size.width*2, landBodyViewRect.size.height*2)];
    
    self.bodyBgImageView.image = self.bodyPortBGImage;
                        
    
}

-(void)setBNotUseToolbar:(BOOL)aBNotUseToolbar {
    
    _bNotUseToolbar = aBNotUseToolbar;
    
    if( self.bNotUseToolbar == YES ) {
        [self.toolbar removeFromSuperview];
    }
    
}
@end
