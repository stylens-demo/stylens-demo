//
//  EditorDemoCellHeader.h
//  stylens-demo
//
//  Created by 김대섭 on 2018. 1. 19..
//  Copyright © 2018년 Bluehack Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"

@class AppDelegate;
@class TKImageView;
@class EditorDemoViewController;

@interface EditorDemoCellHeader : UICollectionReusableView

@property (nonatomic, assign) AppDelegate* app;

@property (nonatomic, weak) EditorDemoViewController *editorView;

@property (nonatomic, strong, setter=setProductMainImage:) UIImage *productMainImage;
@property (nonatomic, strong) UIView *productMainImageBgView;
@property (nonatomic, strong) TKImageView *tkImageView;

@property (nonatomic, strong) NSMutableArray *objectDetectionButtons;
@property (nonatomic, strong) UIButton *currentButton;

@property (nonatomic, strong) UIImageView* productMainImageView;

+(CGFloat)heightWithMainImageHeight:(CGFloat)mainImageHeight;

@end
