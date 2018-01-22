//
//  BHTabbar.h
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 21..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface BHTabbar : UIView

@property (nonatomic, strong) AppDelegate* app;

@property (nonatomic, strong) UIButton* homeButton;
@property (nonatomic, strong) UIButton* cameraButton;
@property (nonatomic, strong) UIButton* galleryButton;

+(CGFloat)height;

@end
