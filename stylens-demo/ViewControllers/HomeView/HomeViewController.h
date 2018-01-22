//
//  HomeViewController.h
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 21..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"

#import "CHTCollectionViewWaterfallLayout.h"

@class AppDelegate;

@interface HomeViewController : UIViewController <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, UIGestureRecognizerDelegate>

@property (nonatomic, strong) AppDelegate* app;
@property (nonatomic, assign) CGRect frame;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

-(id)initWithFrame:(CGRect)aFrame;
-(void)processFeedApi;
-(void)sameProductButtonClicked:(ProductInfo*)productInfo;

@end
