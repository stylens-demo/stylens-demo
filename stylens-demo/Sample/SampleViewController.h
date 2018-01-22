//
//  SampleViewController.h
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 21..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AloViewController.h"

@interface SampleViewController : AloViewController

@property (nonatomic, retain) UILabel* titleLabel;

@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong, setter=setMyImage:) UIImage *myImage;

@end
