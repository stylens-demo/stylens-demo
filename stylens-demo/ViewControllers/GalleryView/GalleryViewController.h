//
//  GalleryViewController.h
//  stylens-demo
//
//  Created by 김대섭 on 2018. 1. 28..
//  Copyright © 2018년 Bluehack Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"

@class AppDelegate;

@interface GalleryViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) AppDelegate* app;
@property (nonatomic, assign) CGRect frame;

@property (nonatomic, strong) UIImage *previewImage;

-(id)initWithFrame:(CGRect)aFrame;
-(void)showGallery;

@end
