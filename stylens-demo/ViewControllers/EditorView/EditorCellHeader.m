//
//  EditorCellHeader.m
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 28..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import "EditorCellHeader.h"

#import "AppDelegate.h"
#import "BaseViewController.h"

#import "AloImage.h"

#import "TKImageView.h"

CGRect cropAreaRect;

@implementation EditorCellHeader

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *aView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:aView];
        self.productImageBgView = aView;
//        aView.backgroundColor = [UIColor orangeColor];
        
        cropAreaRect = CGRectZero;
        
        _tkImageView = [[TKImageView alloc] initWithFrame:CGRectZero];
        [self.productImageBgView addSubview:_tkImageView];
        
//        UIImageView *anImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        anImageView.backgroundColor = [UIColor lightGrayColor];
//        [self.productImageBgView addSubview:anImageView];
//        self.productImageView = anImageView;
    
    }
    return self;
}

-(void)setProductInfo:(ProductInfo *)aProductInfo {
    if (!aProductInfo) {
        return;
    }
    _productInfo = aProductInfo;
    
    NSString* imageUrl = _productInfo.mainImageName;
#if DEBUG
    self.productImage = [UIImage imageNamed:imageUrl];
#else
    [AloImage imageWithUrl:imageUrl WithCompletionBlock:^(BOOL bSuccess, NSError *error, UIImage *anImage) {
        if (bSuccess) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [self setProductImageWithUIImage:anImage];
            }];
        }
    }];
#endif
}

-(void)setProductImage:(UIImage *)aProductImage {
    if (!aProductImage) {
        return;
    }
    _productImage = aProductImage;
    
    [self setProductImageWithUIImage:_productImage];
}

-(void)setProductImageWithUIImage:(UIImage*)anImage {
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        // calc productImageHeight for mainImage
        self.productImageBgView.frame = CGRectMake(0, statusBarHeight*self.app.heightRatio, self.frame.size.width, [Global calcImageHeight:anImage]);
        [self setUpTKImageView:anImage];
        
        // set image
        // CGFloat scale = [UIScreen mainScreen].scale;
        // self.productImageView.image = [Global resizeAndAdjustCropImage:anImage ToRect:CGRectMake(0, 0, self.productImageView.frame.size.width*scale, self.productImageView.frame.size.height*scale)];
    }];
}

-(void)setBoxRect:(CGRect)aBoxRect {
    _boxRect = aBoxRect;
    
    cropAreaRect = aBoxRect;
//    [_tkImageView resetCropAreaWithCGRect:cropAreaRect];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(cropAreaRect, CGRectZero)) {
        [_tkImageView resetCropAreaWithCGRect:cropAreaRect];
    }
}

#pragma mark -
#pragma mark - Methods
- (void)setUpTKImageView:(UIImage*)anImage {
    
    _tkImageView.frame = CGRectMake(0, 0, self.productImageBgView.frame.size.width, self.productImageBgView.frame.size.height);
    _tkImageView.toCropImage = anImage;
    _tkImageView.showMidLines = NO;
    _tkImageView.needScaleCrop = YES;
    _tkImageView.showCrossLines = NO;
    _tkImageView.cornerBorderInImage = NO;
    
    _tkImageView.cropAreaCornerWidth = 25;
    _tkImageView.cropAreaCornerHeight = 25;
    _tkImageView.cropAreaCornerLineWidth = 6;
    _tkImageView.cropAreaCornerLineColor = [UIColor whiteColor];
    _tkImageView.minSpace = 0;
    
    _tkImageView.cropAreaBorderLineWidth = 0;
}

#pragma mark -
#pragma mark - Static
+(CGFloat)heightWithMainImageHeight:(CGFloat)mainImageHeight {
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return statusBarHeight + mainImageHeight * app.heightRatio;
}

@end
