//
//  SampleViewController.m
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 21..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import "SampleViewController.h"

#import "AppDelegate.h"
#import "AloBackItemView.h"

@interface SampleViewController ()

@end

@implementation SampleViewController

-(void)loadView {
    
    [super loadView];
    
    self.app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // tool bar
//    self.portToolbarHeight = 70*self.app.heightRatio;
    self.toolbar.backgroundColor = [Global uiColorWithHexR:233 G:77 B:80];
    
    // title label
    UILabel *aTestTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.toolbar.frame.size.width, self.toolbar.frame.size.height - 20)];
    aTestTitleLabel.textAlignment = NSTextAlignmentCenter;
    aTestTitleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18];
    aTestTitleLabel.textColor = [UIColor whiteColor];
    aTestTitleLabel.adjustsFontSizeToFitWidth = YES; // Font Size 에 따라서 Width 변경
    aTestTitleLabel.text = @"Sample";
    aTestTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.toolbar addSubview:aTestTitleLabel]; // toolbar 영역에 addSubView
    self.titleLabel = aTestTitleLabel; // titleLabel 변수에 대입
    
    self.toolbar.backItemView.itemColor = [UIColor whiteColor];
    self.toolbar.backItemView.arrowSpan = 10;
    self.toolbar.backItemView.arrowWidth = 2;
    
    UIImageView *anImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.toolbar.frame.size.height, self.app.screenRect.size.width, self.app.screenRect.size.width)];
    [self.view addSubview:anImageView];
    self.myImageView = anImageView;
}

-(void)setMyImage:(UIImage *)aMyImage {
    _myImage = aMyImage;
    
    self.myImageView.image = _myImage;
}

@end
