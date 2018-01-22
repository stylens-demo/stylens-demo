//
//  EditorCell.h
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 28..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"

@class AppDelegate;

@interface EditorCell : UICollectionViewCell

@property (nonatomic, assign) AppDelegate* app;

@property (nonatomic, strong, setter=setProductInfo:) ProductInfo* productInfo;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* priceLabel;

@end
