//
//  EditorDemoCell.h
//  stylens-demo
//
//  Created by 김대섭 on 2018. 1. 19..
//  Copyright © 2018년 Bluehack Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"

@class AppDelegate;

@interface EditorDemoCell : UICollectionViewCell

@property (nonatomic, assign) AppDelegate* app;

@property (nonatomic, strong, setter=setProductInfo:) ProductInfo* productInfo;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* priceLabel;

@end
