//
//  EditorCellHeader.h
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 28..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"

@class AppDelegate;
@class TKImageView;

@interface EditorCellHeader : UICollectionReusableView

@property (nonatomic, assign) AppDelegate* app;

@property (nonatomic, strong, setter=setProductInfo:) ProductInfo* productInfo;
@property (nonatomic, strong, setter=setProductImage:) UIImage *productImage;
@property (nonatomic, assign, setter=setBoxRect:) CGRect boxRect;
@property (nonatomic, strong) UIView *productImageBgView;
@property (nonatomic, strong) TKImageView *tkImageView;
@property (nonatomic, strong) UIImageView* productImageView;

+(CGFloat)heightWithMainImageHeight:(CGFloat)mainImageHeight;

//@property (nonatomic, strong, setter=setProductImage:) UIImage *productImage;

@end
