//
//  AloBackItemView.h
//  TestApp
//
//  Created by 기대 여 on 2016. 4. 7..
//  Copyright © 2016년 기대 여. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Global.h"

@interface AloBackItemView : UIView

@property (nonatomic, retain, setter=setItemColor:) UIColor* itemColor;
@property (nonatomic, assign, setter=setArrowSpan:) CGFloat arrowSpan;
@property (nonatomic, assign, setter=setArrowWidth:) CGFloat arrowWidth;

@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, assign, setter=setImageSize:) CGSize imageSize;
@property (nonatomic, strong, setter=setNormalImageName:) NSString* normalImageName;

@property (nonatomic, assign) BOOL bNotUse;
@end
