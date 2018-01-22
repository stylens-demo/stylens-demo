//
//  CameraViewController.h
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 24..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"

@class AppDelegate;

@interface CameraViewController : UIViewController

@property (nonatomic, strong) AppDelegate* app;
@property (nonatomic, assign) CGRect frame;

@property (nonatomic, strong) UIView *cameraCaptureArea;
@property (nonatomic, strong) UIImageView *previewImageView;

-(id)initWithFrame:(CGRect)aFrame;
-(void)startCaptureSession;

@end
