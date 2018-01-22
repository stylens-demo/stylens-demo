//
//  ProductWebViewController.h
//  stylense-demo
//
//  Created by 김대섭 on 2017. 12. 11..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AloViewController.h"

@interface ProductWebViewController : AloViewController <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *productWebView;
@property (nonatomic, strong, setter=setUrlForLoad:) NSString *urlForLoad;
@property (nonatomic, strong) UIButton *backButton;

@end
