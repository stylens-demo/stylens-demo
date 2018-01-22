//
//  ProductInfo.h
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 29..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <SwaggerClient/SWGImage.h>

@interface ProductInfo : NSObject

@property (nonatomic, strong) SWGImage* swgImage;
@property (nonatomic, strong) NSString* _id; // (== imageId)
@property (nonatomic, strong) NSString* titleLabel;
@property (nonatomic, strong) NSString* mainImageName;
@property (nonatomic, strong) NSValue* imageSize;
@property (nonatomic, strong) NSString* mobileThumbImageName;
@property (nonatomic, strong) NSString* priceLabel;
@property (nonatomic, strong) NSString* productUrl;

@end
