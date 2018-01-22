//
//  ProductDetailCellHeader.h
//  stylense-demo
//
//  Created by 김대섭 on 2017. 12. 5..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"

@class AppDelegate;
@class ProductDetailViewController;

@interface ProductDetailCellHeader : UICollectionReusableView

@property (nonatomic, assign) AppDelegate* app;

@property (nonatomic, strong, setter=setProductInfo:) ProductInfo* productInfo;
@property (nonatomic, assign) ProductDetailViewController* productDetailViewController;

@property (nonatomic, strong) UIImageView* mainImageView;
@property (nonatomic, strong) UIButton* scanObjectButton;
@property (nonatomic, strong) UIButton* toWebsiteButton;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* priceLabel;

+(CGFloat)heightWithMainImageHeight:(CGFloat)mainImageHeight;

@end
