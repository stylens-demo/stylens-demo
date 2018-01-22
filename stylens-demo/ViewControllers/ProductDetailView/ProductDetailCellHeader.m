//
//  ProductDetailCellHeader.m
//  stylense-demo
//
//  Created by 김대섭 on 2017. 12. 5..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import "ProductDetailCellHeader.h"

#import "AppDelegate.h"
#import "BaseViewController.h"

#import "ProductDetailViewController.h"

#import "AloImage.h"

@implementation ProductDetailCellHeader

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        self.backgroundColor = [UIColor whiteColor];
        
//        CGFloat curY = statusBarHeight*self.app.heightRatio;
        UIImageView *anImageView = [[UIImageView alloc] initWithFrame:CGRectZero]; //CGRectMake(0, curY, self.frame.size.width, self.frame.size.width)];
        anImageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:anImageView];
        self.mainImageView = anImageView;
        
//        curY += anImageView.frame.size.height;
        CGFloat curY;
        
        CGSize aScanButtonSize = CGSizeMake(52*self.app.widthRatio, 52*self.app.heightRatio);
        CGSize aWebLinkButtonSize = CGSizeMake(362*self.app.widthRatio, 48*self.app.heightRatio);
        
        UIButton* aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        curY = self.frame.size.height - 3*self.app.heightRatio - aWebLinkButtonSize.height - (9 + 9)*self.app.heightRatio - aScanButtonSize.height;
        aButton.frame = CGRectMake(self.frame.size.width - 10*self.app.widthRatio - aScanButtonSize.width, curY, aScanButtonSize.width, aScanButtonSize.height);
        [aButton setImage:[UIImage imageNamed:@"btnScanObjectNor"] forState:UIControlStateNormal];
                [aButton addTarget:self action:@selector(pushToEditorView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:aButton];
//        aButton.backgroundColor = [UIColor grayColor];
        self.scanObjectButton = aButton;
        
        curY += 9*self.app.heightRatio;
        
        aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        curY = self.frame.size.height - 3*self.app.heightRatio - aWebLinkButtonSize.height;
        aButton.frame = CGRectMake(self.frame.size.width/2 - aWebLinkButtonSize.width/2, curY, aWebLinkButtonSize.width, aWebLinkButtonSize.height);
        [aButton setImage:[UIImage imageNamed:@"btnShoppingmallDetailNor"] forState:UIControlStateNormal];
        [aButton addTarget:self action:@selector(pushToProductWebView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:aButton];
        self.toWebsiteButton = aButton;
//        aButton.backgroundColor = [UIColor grayColor];
        
        // titleLabel
        UILabel* aLabel = [[UILabel alloc] initWithFrame:CGRectZero]; // [[UILabel alloc] initWithFrame:CGRectMake(labelMargin, 0, aWebLinkButtonSize.width - labelMargin, aWebLinkButtonSize.height)];
        aLabel.textAlignment = NSTextAlignmentLeft;
        aLabel.font = [UIFont fontWithName:cMainFontBoldName size:12*self.app.widthRatio];
        aLabel.textColor = [UIColor whiteColor];
        [aButton addSubview:aLabel];
        self.titleLabel = aLabel;
        
        // priceLabel
        aLabel = [[UILabel alloc] initWithFrame:CGRectZero]; // [[UILabel alloc] initWithFrame:CGRectMake(0, 0, aWebLinkButtonSize.width - labelMargin, aWebLinkButtonSize.height)];
        aLabel.textAlignment = NSTextAlignmentRight;
        aLabel.font = [UIFont fontWithName:cMainFontBoldName size:12*self.app.widthRatio];
        aLabel.adjustsFontSizeToFitWidth = YES;
        aLabel.textColor = [UIColor whiteColor];
        [aButton addSubview:aLabel];
        self.priceLabel = aLabel;
    }
    return self;
}

-(void)setProductInfo:(ProductInfo *)aProductInfo {
    _productInfo = aProductInfo;
    
#if DEBUG
    self.mainImageView.frame = CGRectMake(0, statusBarHeight*self.app.heightRatio, self.frame.size.width, [Global calcImageHeight:[UIImage imageNamed:_productInfo.mainImageName]]);
    
    CGFloat scale = [UIScreen mainScreen].scale;
    self.mainImageView.image = [Global resizeAndAdjustCropImage:[UIImage imageNamed:_productInfo.mainImageName] ToRect:CGRectMake(0, 0, self.mainImageView.frame.size.width*scale, self.mainImageView.frame.size.height*scale)];
#else
    NSString* imageUrl = _productInfo.mainImageName;
    [AloImage imageWithUrl:imageUrl WithCompletionBlock:^(BOOL bSuccess, NSError *error, UIImage *anImage) {
        if (bSuccess) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                // calc mainImageHeight for mainImage
                self.mainImageView.frame = CGRectMake(0, statusBarHeight*self.app.heightRatio, self.frame.size.width, [Global calcImageHeight:anImage]);
                
                // set image
                CGFloat scale = [UIScreen mainScreen].scale;
                self.mainImageView.image = [Global resizeAndAdjustCropImage:anImage ToRect:CGRectMake(0, 0, self.mainImageView.frame.size.width*scale, self.mainImageView.frame.size.height*scale)];
                
                [self bringSubviewToFront:self.scanObjectButton];
            }];
        }
    }];
#endif
    
    CGFloat labelMargin = 16*self.app.widthRatio;
    
    CGSize priceTextSize = [Global textSize:_productInfo.priceLabel Font:_priceLabel.font];
    self.priceLabel.frame = CGRectMake(self.toWebsiteButton.frame.size.width - labelMargin - priceTextSize.width, 0, priceTextSize.width, self.toWebsiteButton.frame.size.height);
    self.priceLabel.text = _productInfo.priceLabel;
    
    self.titleLabel.frame = CGRectMake(labelMargin, 0, self.toWebsiteButton.frame.size.width - self.priceLabel.frame.size.width - labelMargin*2 - 4*self.app.widthRatio , self.toWebsiteButton.frame.size.height);
    self.titleLabel.text = _productInfo.titleLabel;
}

+(CGFloat)heightWithMainImageHeight:(CGFloat)mainImageHeight {
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return mainImageHeight + (statusBarHeight + 9 + 48 + 3) * app.heightRatio;
}

#pragma mark - Methods
-(void)pushToEditorView {
    [self.productDetailViewController pushToEditorView];
}

-(void)pushToProductWebView {
    [self.productDetailViewController pushToProductWebView];
}

@end
